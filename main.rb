require 'sinatra'
require 'signalwire/sdk'

roster = []
$stdout.sync = true

post '/receive' do
  logger.info params['CallSid']
  roster << params['CallSid']
  response = Signalwire::Sdk::VoiceResponse.new do |response|
    response.play(loop: 0, url: 'https://files.freemusicarchive.org/storage-freemusicarchive-org/music/no_curator/Mid-Air_Machine/It_Rains__Abstract_Jazz/Mid-Air_Machine_-_Where_From.mp3')
  end
  response.to_s
end

get '/' do
  @roster = roster
  erb :index
end

get '/update' do
  app_url = "#{ENV['APP_URL']}/dial"
  logger.info app_url
  sid = params[:sid]
  roster.delete(sid)
  client = Signalwire::REST::Client.new ENV['SIGNALWIRE_PROJECT'], ENV['SIGNALWIRE_TOKEN'], 
    signalwire_space_url: ENV['SIGNALWIRE_SPACE']

  call = client.calls(sid).update(
    url: app_url, 
    fallback_url: app_url)
end

post '/dial' do
  logger.info "Dialing caller_id: #{ENV['APP_CALLER_ID']}, number: #{ENV['APP_CALL_DESTINATION']}"
  response = Signalwire::Sdk::VoiceResponse.new do |response|
    response.dial(caller_id: ENV['APP_CALLER_ID'], number: ENV['APP_CALL_DESTINATION'])
  end
  response.to_s
end

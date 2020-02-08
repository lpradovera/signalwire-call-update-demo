require 'sinatra'
require 'signalwire/sdk'

roster = []

post '/receive' do
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
  sid = params[:sid]
  roster.delete(sid)
  client = Signalwire::REST::Client.new ENV['SIGNALWIRE_PROJECT'], ENV['SIGNALWIRE_TOKEN'], 
    signalwire_space_url: ENV['SIGNALWIRE_SPACE']

  call = client.calls(sid).update(
    url: "#{ENV['SIGNALWIRE_SPACE']}/dial", 
    fallback_url: "#{ENV['SIGNALWIRE_SPACE']}/dial")
end

get '/dial' do
  response = Signalwire::Sdk::VoiceResponse.new do |response|
    response.dial(caller_id: ENV['APP_CALLER_ID'], number: ENV['APP_CALL_DESTINATION'])
  end
  response.to_s
end

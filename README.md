# LAML call updating demo

In this example, we are going to receive a call via LAML, have it paused in a sound loop, then update it with a destination and check the new target gets called.

The goal is to demonstrate a mechanism that could be used, for example, to wait for a mobile SIP endpoint to be registered before bridging the call.

## Usage

First of all, copy the `env.example` file into `.env` and adjust the values using your SignalWire project credentials.

Start the application with `dotenv ruby main.rb`.

Set up a number or SIP domain app to point at `APP_URL/receive`.

Call the number and listen to a bit of cool jazz.

Go to `APP_URL` then click on the call SID of the call you want to redirect.

The `APP_CALL_DESTINATION` will be dialed.

## API interactions

The inbound call is held in a looping pattern with a simple LAML document similar to the following:

```
<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Play loop="0">https://your-application.com/audio.mp3</Play>
</Response>
```

The call SID has to be saved somehow by the server generating the LAML.

That call SID is referenced in a REST API request that replaces the existing document with a new one:

```
curl https://example.signalwire.com/api/laml/2010-04-01/Accounts/{AccountSid}/Calls/{Sid}.json \
  -X POST \
  --data-urlencode "url=https://your-new-lamrl-url.com" \
  --data-urlencode "fallbackUrl=https://your-new-lamrl-url.com" \
  -u "YourProjectID:YourAuthToken"
```

The URL you pass in in the above request will be sending the call to the final destination:

```
<?xml version="1.0" encoding="UTF-8"?>
<Response>
    <Dial>
        <Sip>sip:alice@example.com</Sip>
    </Dial>
</Response>
```
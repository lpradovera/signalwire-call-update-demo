# LAML call updating demo

In this example, we are going to receive a call via LAML, have it paused in a sound loop, then update it with a destination and check the new target gets called.

The goal is to demonstrate a mechanism that could be used, for example, to wait for a mobile SIP endpoint to be registered before bridging the call.

## Usage

First of all, copy the `env.example` file into `.env` and adjust the values using your SignalWire project credentials.
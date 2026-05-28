# PHONE-FLEET-MONITOR 
> Your fleet, always watched — even when you are far away from it.

## The Problem
Monitoring multiple Android devices manually means constantly checking each one. Miss a disconnection or an overheating phone and you won't know until something goes wrong.

## What It Does
- Detects new device connections and disconnections in real time
- Monitors battery percentage and temperature of each connected phone
- Sends instant Telegram alerts for all events directly to your phone
- Runs continuously in the background — no manual intervention needed

## What You Need
- Linux environment
- ADB installed and configured with your device fleet
- Internet connection
- Telegram Bot token and Chat ID

## What's Next
- Refining edge case handling for connections and disconnections
- Adding real time CPU and RAM usage monitoring per device
- Improving alert reliability on unstable networks
- Adding another API calling too if telegram fails to send message

## Part of PHONE-FLEET
This script is a small linked part of the broader [PHONE-FLEET](https://github.com/devdutt-dave007/PHONE-FLEET) project.
*As we extract every bit of work from old devices, it's equally important to keep a watchful eye on them.

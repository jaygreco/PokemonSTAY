PokemonSTAY documentation
================
Note: download pokemon_unsigned.zip from https://github.com/rpplusplus/PokemonHook, it's not hosted here!

The same tool used to install the new pangu jailbreak can be used to sign and install this app, on any OS, without the need for xcode or fastlane! If no modification of the code is required, just use Cydia Impactor to resign and install using your personal iOS developer certificate.

http://www.cydiaimpactor.com
================

fastlane is required to resign the ipa and dylib. use homebrew or macports:
```
sudo brew install fastlane
```
Once all is installed, no need to build with xcode (unless you wish to).
You need to have your ios dev mobile provison downloaded and saved into the root of the project as
embedded.mobileprovision. if this doesn't make sense, look into a free ios dev membership for sideloading apps.
Once you have everything, run the build script with:
```
./gogo.sh
```
finally, copy the ipa to your device using xcode or itunes to do so. you'll know everything went okay if the app
installs and launches without a hitch.

----

I claim no responsibility for bans or any account issue! This is definitely against the TOS and is just for proof of concept. Use at your own risk...

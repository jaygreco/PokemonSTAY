PokemonSTAY documentation
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

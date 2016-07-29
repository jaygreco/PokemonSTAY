#!/bin/sh

# clean
rm pokemongo.ipa

# unzip
unzip -q "pokemon_unsigned.zip"

# cp dylib
cp LocationFaker.dylib Payload/pokemongo.app/libLocationFaker.dylib

# embedded.mobileprovision
cp embedded.mobileprovision Payload/pokemongo.app/embedded.mobileprovision

#copy edited info plist
cp Info_edited.plist Payload/pokemongo.app/Info.plist

#copy app icons to Payload/pokemongo.app/
command cp -R AppIcons/AppIcon57x57.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon57x57@2x.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon60x60@2x.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon60x60@3x.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon72x72@2x~ipad.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon72x72~ipad.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon76x76@2x~ipad.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon76x76~ipad.png Payload/pokemongo.app/
command cp -R AppIcons/AppIcon83.5x83.5@2x~ipad.png Payload/pokemongo.app/

# zip to ipa
zip -qr pokemongo.ipa Payload

#resign
fastlane ios resign

#clean
rm -rf "Payload"
rm -rf "__MACOSX"

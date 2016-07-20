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

# zip to ipa
zip -qr pokemongo.ipa Payload

#resign
fastlane ios resign

#clean
rm -rf "Payload"
rm -rf "__MACOSX"

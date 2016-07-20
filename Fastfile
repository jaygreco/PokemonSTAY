fastlane_version "1.80.0"

default_platform :ios

platform :ios do
  before_all do

  end

  desc "Runs all the tests"
  lane :test do
   
  end

  lane :resign do

    resign(
              ipa: "path/to/your/pokemongo.ipa",
              signing_identity: "iPhone Developer: Yourname Here (XXXXXXXXXX)",
              provisioning_profile: "path/to/embedded.mobileprovision"
           )

  end

  after_all do |lane|

  end

  error do |lane, exception|

  end
end
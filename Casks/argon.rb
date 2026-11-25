cask "argon" do
  version "2.41"
  sha256 "71097f9581ee2d35ea4546b2282cae7e73cacc1c1da617dd3adf6732a936ced1"

  url "https://argonmac.com/releases/Argon-#{version}.dmg"
  name "Argon"
  desc "Notch app for music, calls, AirPods, timers and files"
  homepage "https://argonmac.com/"

  livecheck do
    url "https://argonmac.com/releases/latest.json"
    strategy :json do |json|
      json["version"]
    end
  end

  auto_updates true
  depends_on arch: :arm64
  depends_on macos: :sonoma

  app "Argon.app"

  uninstall quit: "com.argonmac.argon"

  zap trash: [
    "~/Library/Application Support/Argon",
    "~/Library/Caches/Argon",
    "~/Library/Caches/com.argonmac.argon",
    "~/Library/HTTPStorages/com.argonmac.argon",
    "~/Library/Logs/Argon",
    "~/Library/Preferences/com.argonmac.argon.plist",
    "~/Library/Preferences/com.argonmac.argon.prefs.plist",
    "~/Library/Saved Application State/com.argonmac.argon.savedState",
  ]
end

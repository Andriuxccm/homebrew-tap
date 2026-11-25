cask "argon" do
  version "2.40"
  sha256 "a57056b7d1793791f742a53b15aa9501232298b98c8d2e9dbf06b4bb764a9b5a"

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

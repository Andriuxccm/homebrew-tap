cask "argon" do
  version "2.38"
  sha256 "ba4d57389dbe0676b2ae6486a6dd54251c171ba886baf01434a033ae7061eda5"

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

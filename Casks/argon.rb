cask "argon" do
  version "2.33"
  sha256 "91e808e40a94dd6ffd27617402a308a90981d251ff569bc6f80651c45a9615c5"

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
    "~/Library/Caches/com.argonmac.argon",
    "~/Library/HTTPStorages/com.argonmac.argon",
    "~/Library/Preferences/com.argonmac.argon.plist",
    "~/Library/Saved Application State/com.argonmac.argon.savedState",
  ]
end

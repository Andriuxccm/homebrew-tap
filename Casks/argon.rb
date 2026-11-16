cask "argon" do
  version "2.30"
  sha256 "6baedaf4d45178b8ce46efdb347115ed4b32953ecafdf3d58db6ce3ccdcd8aa2"

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
  depends_on macos: :sequoia

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

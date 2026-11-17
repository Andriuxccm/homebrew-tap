cask "argon" do
  version "2.32"
  sha256 "558c47ee38ebd2fb10632af9f056ed2fbd5e5eb919c60f7f2933a9fb9360725a"

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

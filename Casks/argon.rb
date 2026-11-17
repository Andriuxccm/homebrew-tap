cask "argon" do
  version "2.31"
  sha256 "0e835e0c9941a1a024fc42b11ee3194cf8375f2e8c42dc810f9ecb61a824d2e5"

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

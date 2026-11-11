cask "plume" do
  version "0.19.0"
  sha256 "ec75b67ee60834f11c87f29b2d1ea4b038dddd9d84c861becfbeb6bf9b66957c"

  url "https://github.com/ryanmoelter/plume/releases/download/v#{version}/Plume-#{version}.dmg"
  name "Plume"
  desc "Organize and parallelize coding-agent work"
  homepage "https://github.com/ryanmoelter/plume"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true

  depends_on macos: :tahoe

  app "Plume.app"
  binary "#{appdir}/Plume.app/Contents/Helpers/plume"

  uninstall launchctl: "com.ryanmoelter.Plume.SleepHelper",
            quit:      "com.ryanmoelter.Plume"

  zap trash: [
    "~/Library/Application Support/Plume",
    "~/Library/Application Support/Plume.debug",
    "~/Library/Preferences/com.ryanmoelter.Plume.plist",
    "~/Library/Saved Application State/com.ryanmoelter.Plume.savedState",
  ]
end

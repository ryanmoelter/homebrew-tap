cask "plume" do
  version "0.15.0"
  sha256 "3b29a3d54a8ff21fcb36b649f1daf6046cd92ba0aa9eaf7e1004bbd79d63f009"

  url "https://github.com/ryanmoelter/plume/releases/download/v#{version}/Plume-#{version}.dmg"
  name "Plume"
  desc "Organize and parallelize coding-agent work"
  homepage "https://github.com/ryanmoelter/plume"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :tahoe

  app "Plume.app"

  uninstall launchctl: "com.ryanmoelter.Plume.SleepHelper",
            quit:      "com.ryanmoelter.Plume"

  zap trash: [
    "~/Library/Application Support/Plume",
    "~/Library/Application Support/Plume.debug",
    "~/Library/Preferences/com.ryanmoelter.Plume.plist",
    "~/Library/Saved Application State/com.ryanmoelter.Plume.savedState",
  ]
end

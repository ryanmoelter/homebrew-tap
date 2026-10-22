cask "plume" do
  version "0.16.0"
  sha256 "b545d482a8459face4071fc64e5612acea39cde7e1f68f197cd78c9b2df8774f"

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

cask "plume" do
  version "0.16.1"
  sha256 "023f8ba437ca64d0e351b277effc2f6f67060668c60db3091ba282b0375d8bcd"

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

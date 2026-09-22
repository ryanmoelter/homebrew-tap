cask "plume" do
  version "0.11.0"
  sha256 "c54468c2821cb39479c2a15d60c8f7e19f9aff0025b35aac06c9956a528a19bb"

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

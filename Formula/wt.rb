class Wt < Formula
  desc "Git worktree helper for running several agents at once"
  homepage "https://github.com/ryanmoelter/cli-tools"
  url "https://github.com/ryanmoelter/cli-tools/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "814eb6085f8b6b89d24d9e03ffe87c852029f1b8ab607ce711e128ffa53f0ed8"
  license "MIT"

  depends_on "git"

  uses_from_macos "python", since: :catalina

  def install
    libexec.install "src/wt"
    libexec.install "src/_common"
    # gh/glab are found on PATH for PR status; a GUI-launched caller has none.
    (bin/"wt").write_env_script libexec/"wt", PATH: "#{HOMEBREW_PREFIX}/bin:$PATH"
  end

  def caveats
    configured = begin
      rc = File.expand_path("~/.zshrc")
      File.exist?(rc) && File.read(rc).include?("wt init zsh")
    rescue
      false
    end

    return if configured

    <<~EOS
      `wt switch` has to cd the shell that invoked it, which a subprocess
      cannot do. Add the wrapper (and zsh completions) to your ~/.zshrc:

        eval "$(wt init zsh)"

      Everything else works without it; `wt switch` will tell you to run this.
      For a plain path in scripts or other shells, use `wt path <name>`.

      Opening a worktree in a new tab needs cmux or Ghostty on macOS;
      elsewhere wt skips the tab and carries on.
    EOS
  end

  test do
    ENV["HOME"] = testpath
    system "git", "-C", testpath, "init", "-q", "-b", "main"
    system "git", "-C", testpath, "-c", "user.email=test@example.com",
           "-c", "user.name=Test", "-c", "commit.gpgsign=false",
           "commit", "-q", "--allow-empty", "-m", "root"

    assert_match version.to_s, shell_output("#{bin}/wt --version")

    require "json"
    out = JSON.parse(shell_output("#{bin}/wt list --json"))
    names = out["worktrees"].map { |w| w["name"] }
    assert_includes names, testpath.basename.to_s
    assert_equal "main", out["worktrees"].first["branch"]

    cur = JSON.parse(shell_output("#{bin}/wt current --json"))
    assert_equal "main", cur["branch"]

    # The scriptable half of switch: prints a path, needs no shell wrapper.
    assert_equal testpath.realpath.to_s,
                 shell_output("#{bin}/wt path #{testpath.basename}").strip

    # init must work outside any repo — it runs at shell startup.
    assert_match "compdef _wt wt", shell_output("#{bin}/wt init zsh")
  end
end

class Stack < Formula
  desc "Stacked-branch helper for a squash-merge PR/MR workflow"
  homepage "https://github.com/ryanmoelter/cli-tools"
  url "https://github.com/ryanmoelter/cli-tools/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "814eb6085f8b6b89d24d9e03ffe87c852029f1b8ab607ce711e128ffa53f0ed8"
  license "MIT"

  depends_on "git"

  uses_from_macos "python", since: :catalina

  def install
    libexec.install "src/stack"
    libexec.install "src/_common"
    (bin/"stack").write_env_script libexec/"stack", PATH: "#{HOMEBREW_PREFIX}/bin:$PATH"
  end

  def caveats
    <<~EOS
      `stack submit` and `stack sync` reach the forge through gh (GitHub) or
      glab (GitLab), auto-detected from your origin URL:

        brew install gh
        brew install glab

      Every other subcommand is local and needs neither. For zsh completions:

        eval "$(stack init zsh)"
    EOS
  end

  test do
    ENV["HOME"] = testpath
    git = ["git", "-C", testpath, "-c", "user.email=test@example.com",
           "-c", "user.name=Test", "-c", "commit.gpgsign=false"]
    system "git", "-C", testpath, "init", "-q", "-b", "main"
    system(*git, "commit", "-q", "--allow-empty", "-m", "root")

    assert_match version.to_s, shell_output("#{bin}/stack --version")

    # A fresh repo tracks no stack: exits 1 with a hint.
    assert_match "no stacks tracked yet",
                 shell_output("#{bin}/stack list 2>&1", 1)

    # Pin the prefix so the assertion holds regardless of the builder's
    # git config. The tool-specific key wins over the shared section, so this
    # holds even if a stack.branchPrefix is set globally.
    system "git", "-C", testpath, "config", "stack.branchPrefix", "prefix/"

    system bin/"stack", "create", "feat-a"

    require "json"
    out = JSON.parse(shell_output("#{bin}/stack list --json"))
    assert_equal "main", out["trunk"]
    assert_equal "prefix/feat-a", out["current"]

    assert_match "compdef _stack stack", shell_output("#{bin}/stack init zsh")
  end
end

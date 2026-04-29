class Dotfiles < Formula
  desc "Gerald Kanapathy's personal dotfiles (fish, neovim, ripgrep, starship)"
  homepage "https://github.com/gkanapathy/dotfiles"
  url "https://github.com/gkanapathy/dotfiles/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "be5ed481d1af28050d5a97dc752e5a2667f14ef71717286019d572792689b6c2"
  license "MIT"

  depends_on "fish"
  depends_on "neovim"
  depends_on "ripgrep"
  depends_on "starship"
  depends_on "uv"

  def install
    pkgshare.install Dir["*"]
    (bin/"dotfiles-install").write <<~SH
      #!/bin/bash
      set -e
      export DOTFILES="#{opt_pkgshare}"
      exec "${DOTFILES}/install.sh" "$@"
    SH
    chmod 0755, bin/"dotfiles-install"
  end

  def caveats
    <<~EOS
      To symlink the dotfiles into your home directory, run:
        dotfiles-install

      Existing files are backed up to <path>.backup.<timestamp>.
      The fish config auto-detects $DOTFILES from its symlink target,
      so no env var setup is required, even after `brew upgrade`.
    EOS
  end

  test do
    assert_predicate (opt_pkgshare/"install.sh"), :exist?
    assert_predicate (opt_pkgshare/"fish/config.fish"), :exist?
    assert_predicate (opt_pkgshare/"starship/build_preset.py"), :exist?
  end
end

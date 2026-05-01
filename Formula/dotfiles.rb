class Dotfiles < Formula
  desc "Gerald Kanapathy's personal dotfiles (bat, fish, neovim, ripgrep, starship)"
  homepage "https://github.com/gkanapathy/dotfiles"
  url "https://github.com/gkanapathy/dotfiles/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "e367e1e48ef8169191eca7fac7d793fcdb6deab02e4c7772a671e5185c9e0d04"
  license "MIT"

  depends_on "bat"
  depends_on "fish"
  depends_on "neovim"
  depends_on "ripgrep"
  depends_on "starship"
  depends_on "yq"

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
    assert_path_exists opt_pkgshare/"install.sh"
    assert_path_exists opt_pkgshare/"fish/config.fish"
    assert_path_exists opt_pkgshare/"starship/build"
  end
end

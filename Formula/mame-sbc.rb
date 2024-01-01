class MameSbc < Formula
  desc "MAME for for Single Board Computers"
  homepage "https://github.com/roscopeco/mame"
  head "https://github.com/roscopeco/mame.git", :branch => 'homebrew'

  depends_on "qt5"
  depends_on "python"

  def install
    system 'make', '-j9'
    # There is no make install for mame
    bin.install "sbc"
  end

  test do
    system "sh", "'sbc -version | grep mame'"
  end
end

class MameSbc < Formula
  desc "MAME for for Single Board Computers"
  homepage "https://github.com/roscopeco/mame"
  head "https://github.com/roscopeco/mame.git"

  depends_on "qt5"

  def install
    system 'make', '-j9', 'sbc64', 'install' 
  end

  test do
    system "sh", "'sbc64 -version | grep mame'"
  end
end

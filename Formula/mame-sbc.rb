class MameSBC < Formula
  desc "MAME for for Single Board Computers"
  homepage "https://github.com/mmicko/mame"
  head "https://github.com/mmicko/mame.git"

  depends_on "qt5"

  def install
    system 'make', '-j9', 'sbc64', 'install' 
  end

  test do
    system "sh", "'sbc64 -version | grep mame'"
  end
end

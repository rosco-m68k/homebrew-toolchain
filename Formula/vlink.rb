class Vlink < Formula
  desc "A portable linker for multiple file formats."
  homepage "http://sun.hasenbraten.de/vlink/"
  url "http://phoenix.owl.de/tags/vlink0_17a.tar.gz"
  version "0.17a"
  sha256 "f6754913d47bc97cf4771cc0aa7c51de368a04894be35b8dc5e4beac527f5b82"
  
  def install
    system "make"

    # There is no make install for vlink
    bin.install "vlink"
  end

  test do
    system "#{bin}/vlink"
  end
end

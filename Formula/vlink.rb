class Vlink < Formula
  desc "A portable linker for multiple file formats."
  homepage "http://sun.hasenbraten.de/vlink/"
  url "http://phoenix.owl.de/tags/vlink0_17a.tar.gz"
  version "0.17a"
  sha256 "f6754913d47bc97cf4771cc0aa7c51de368a04894be35b8dc5e4beac527f5b82"

  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "c64ec3f3a3c316c06f151d0c8b3ef3aabb7548216768177afea6bbd55a58f0ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "55d704f747b04791bba13f184a836dfe26ec8d8fc6b36112ade19487f19193d2"
  end

  def install
    system "make"

    # There is no make install for vlink
    bin.install "vlink"
  end

  test do
    system "#{bin}/vlink"
  end
end

class BinutilsCrossM68k < Formula
  desc "GNU Binutils for m68k cross-compiling"
  homepage "https://www.gnu.org/software/binutils/"
  url "http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-2.37.tar.bz2"
  sha256 "67fc1a4030d08ee877a4867d3dcab35828148f87e1fd05da6db585ed5a166bd4"

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--target=m68k-elf",
                          "--prefix=#{prefix}"

    system "make"
    system "make", "install"
  end

  test do
    assert_match "Usage:", shell_output("#{bin}/m68k-elf-strings #{bin}/m68k-elf-strings")
  end
end

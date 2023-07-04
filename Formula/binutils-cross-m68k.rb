class BinutilsCrossM68k < Formula
  desc "GNU Binutils for m68k cross-compiling"
  homepage "https://www.gnu.org/software/binutils/"
  url "http://www.mirrorservice.org/sites/ftp.gnu.org/gnu/binutils/binutils-2.40.tar.bz2"
  sha256 "f8298eb153a4b37d112e945aa5cb2850040bcf26a3ea65b5a715c83afe05e48a"

  depends_on "texinfo" => :build
  
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

class GccCrossM68kAT13 < Formula
  desc "GNU Compiler Collection 13 (Cross-compiler/m68k)"
  homepage "https://gcc.gnu.org"
  url "https://mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-13.3.0/gcc-13.3.0.tar.gz"
  sha256 "3a2b10cab86e32358fdac871546d57e2700e9bdb5875ef33fff5b601265b9e32"

  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    rebuild 1
    sha256 sonoma: "48076618fa7d81afc9c56273d3a6b04ac11b63e1526768ba710a9cd3b3cd0dff"
    sha256 arm64_sonoma: "28d545c3845a16740fb1a6c673ac49d5e2b7c9d07bce50a2f80bee77c627efc2"
    sha256 x86_64_linux: "9f9789fa8858dab70a46e2a1e8b4dce06f92c67b304ba0d22acbd776c40a2664"
  end

  depends_on "binutils-cross-m68k"
  
  # All of these are probably not needed but #3 was a case where it wouldn't
  # build without them (maybe no previous install of platform GCC)
  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  
  def install
    # GCC will suffer build errors if forced to use a particular linker.
    ENV.delete "LD"

    # Even when suffixes are appended, the info pages conflict when
    # install-info is run so pretend we have an outdated makeinfo
    # to prevent their build.
    ENV["gcc_cv_prog_makeinfo_modern"] = "no"
    
    args = [
      "--disable-debug",
      "--disable-dependency-tracking",
      "--disable-silent-rules",
      "--target=m68k-elf",
      "--enable-languages=c,c++",
      "--disable-nls",
      "--with-as=#{Formula["binutils-cross-m68k"].opt_bin}/m68k-elf-as",
      "--with-ld=#{Formula["binutils-cross-m68k"].opt_bin}/m68k-elf-ld",
      "--prefix=#{prefix}"
    ]
    
    mkdir "../build" do
      system "../gcc-#{version}/configure", *args
      system "make", "all-gcc", "all-target-libgcc"
      system "make", "install-gcc", "install-target-libgcc"
    end
  end

  test do
    (testpath/"hello-c.c").write <<~EOS
      int main()
      {
        return 0;
      }
    EOS
    system "#{bin}/m68k-elf-gcc", "-ffreestanding", "-c", "-o", "hello-c.o", "hello-c.c"

    (testpath/"hello-cc.cc").write <<~EOS
      int main()
      {
        return 0;
      }
    EOS
    system "#{bin}/m68k-elf-g++", "-ffreestanding", "-c", "-o", "hello-cc.o", "hello-cc.cc"
  end
end

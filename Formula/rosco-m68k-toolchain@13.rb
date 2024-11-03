class RoscoM68kToolchainAT13 < Formula
  desc "GCC + Newlib Toolchain for rosco_m68k"
  homepage "https://rosco-m68k.com"
  license "GPL-3.0 and MIT"
  url "https://github.com/rosco-m68k/newlib-rosco-build/releases/download/v20241103161658/rosco-m68k-toolchain-20241103161658.tar.gz"
  sha256 "f7230c8968d926e73386546198b5357274be4a6c93777bc6da0310679780ed79"


  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    sha256 sonoma: "b2ed1f9b4d8b4f9dd22d47da9ca051a216e7794d981b21a5511fa46f59ddc7ad"
    sha256 arm64_sonoma: "5ea107243446257dfb4ace223b5e3db08a48e69567de43aee59a7ed886e507b7"
    sha256 x86_64_linux: "f0c266c2fbadaaa2d059fb3a04a001006e3fb6b0bd640329b3259a47bd9403f6"
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"
  depends_on "zstd"
  depends_on "vasm-all"

#  on_sonoma :or_newer do
#    fails_with :clang
#  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo"  => :build
    depends_on "flex"
    depends_on "bison"    => :build
  end

  def install
    system "sh", "linkem.sh"
    mkdir "build-all"
    chdir "build-all" do
      system "../srcw/configure",
        "--target=m68k-elf-rosco",
        "--enable-languages=c,c++",
        "--with-newlib",
        "--with-arch=m68k",
        "--with-cpu=m68000",
        "--disable-debug",
        "--disable-dependency-tracking",
        "--disable-silent-rules",
        "--disable-nls",
#        "--with-gmp=#{Formula["gmp"]}",
#        "--with-mpfr=#{Formula["mpfr"]}",
#        "--with-mpc=#{Formula["libmpc"]}",
        *std_configure_args

      system "make",
        "MAKEINFO=true",
        "-j9",
        "all-build",
        "all-binutils",
        "all-gas",
        "all-ld",
        "all-gcc",
        "all-target-libgcc",
        "all-target-newlib",
        "all-target-libgloss"

      system "make",
        "install-binutils",
        "install-gas",
        "install-ld",
        "install-gcc"
      system "make",
        "install-target-libgcc"
      system "make",
        "install-target-newlib"
      system "make",
        "install-target-libgloss"
    end

    system "make",
      "-C",
      "Xosera/copper/CopAsm"

    bin.install "Xosera/copper/CopAsm/bin/xosera-copasm" => "xosera-copasm"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <stdio.h>
      #include <rosco_m68k/machine.h>

      int main(int argc, char **argv) {
          printf("Hello?\n");
      }
    EOS

    (testpath/"test.cpp").write <<~EOS
      #include <iostream>
      #include <rosco_m68k/machine.h>

      int main(int argc, char **argv) {
          std::cout << "Hello?" << std::endl;
      }
    EOS

    system "#{bin}/m68k-elf-rosco-gcc", "-o", "testc.elf", "test.c"
    system "#{bin}/m68k-elf-rosco-g++", "-o", "testcpp.elf", "test.cpp"
    system "#{bin}/m68k-elf-rosco-objcopy", "-O", "binary", "testc.elf", "testc.bin"
    system "#{bin}/m68k-elf-rosco-objcopy", "-O", "binary", "testcpp.elf", "testcpp.cpp"
  end
end

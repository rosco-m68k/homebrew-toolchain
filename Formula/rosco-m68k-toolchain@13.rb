class RoscoM68kToolchainAT13 < Formula
  desc "GCC + Newlib Toolchain for rosco_m68k"
  homepage "https://rosco-m68k.com"
  license "GPL-3.0 and MIT"
  url "https://github.com/rosco-m68k/newlib-rosco-build/releases/download/v20241026175022/rosco-m68k-toolchain-20241026175022.tar.gz"
  sha256 "eab3ff3bce2c205cdca17a29f02c517533a964b60cb643a3cc54bef85021891c"

  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    rebuild 1
    sha256 sonoma: "8b32ac1812c1ff4de21ad0010d510ab363be13b38084d26c840f39b42a919ef7"
    sha256 arm64_sonoma: "748ef52f9fa967c614ac47d8f890911e06d06c4c77b83ce3c664f3ee7c4cc981"
    sha256 x86_64_linux: "58188d0842662298f299740a0eb341c5965887948ecc4ce63f7994e68bd0b3f3"
  end

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

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

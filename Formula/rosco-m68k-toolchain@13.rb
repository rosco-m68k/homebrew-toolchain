class RoscoM68kToolchainAT13 < Formula
  desc "GCC + Newlib Toolchain for rosco_m68k"
  homepage "https://rosco-m68k.com"
  license "GPL-3.0-only"
  head "https://github.com/rosco-m68k/newlib-rosco-build.git", branch: "main"

  depends_on "gmp"
  depends_on "isl"
  depends_on "libmpc"
  depends_on "mpfr"

  depends_on "vasm-m68k" => :build

#  on_sonoma :or_newer do
#    fails_with :clang
#  end

  on_system :linux, macos: :ventura_or_newer do
    depends_on "texinfo"  => :build
    depends_on "flex"     => :build
    depends_on "bison"    => :build
  end

  def install
    system "git", "submodule", "update", "--init"

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

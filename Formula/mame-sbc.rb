class MameSbc < Formula
  desc "MAME for Single Board Computers"
  homepage "https://github.com/roscopeco/mame"
  url "https://github.com/roscopeco/mame.git", tag: 'mamerosco20240102'

  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "58454ee4772c2b1ae5d4e91c3ee6ab0d9ab8d57559dadac179ce97a837f54e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "4d46c84901f6dbd2b6d5959b2bccf6333b9c252185c5ae5430c72f9c3da9b97c"
  end

  depends_on "qt5"
  depends_on "asio" => :build
  depends_on "glm" => :build
  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "rapidjson" => :build
  depends_on "sphinx-doc" => :build
  depends_on "flac"
  depends_on "jpeg-turbo"
  # Need C++ compiler and standard library support C++17.
  depends_on macos: :high_sierra
  depends_on "portaudio"
  depends_on "portmidi"
  depends_on "pugixml"
  depends_on "sdl2"
  depends_on "sqlite"
  depends_on "utf8proc"

  uses_from_macos "expat"
  uses_from_macos "zlib"

  on_linux do
    depends_on "pulseaudio"
    depends_on "qt@5"
    depends_on "sdl2_ttf"
  end

  def install
    # Cut sdl2-config's invalid option.
    inreplace "scripts/src/osd/sdl.lua", "--static", ""

    # Use bundled lua instead of latest version.
    # https://github.com/mamedev/mame/issues/5349
    system 'make', "PYTHON_EXECUTABLE=#{Formula["python@3.11"].opt_bin}/python3.11",
                   "USE_LIBSDL=1",
                   "USE_SYSTEM_LIB_EXPAT=1",
                   "USE_SYSTEM_LIB_ZLIB=1",
                   "USE_SYSTEM_LIB_ASIO=1",
                   "USE_SYSTEM_LIB_LUA=",
                   "USE_SYSTEM_LIB_FLAC=1",
                   "USE_SYSTEM_LIB_GLM=1",
                   "USE_SYSTEM_LIB_JPEG=1",
                   "USE_SYSTEM_LIB_PORTAUDIO=1",
                   "USE_SYSTEM_LIB_PORTMIDI=1",
                   "USE_SYSTEM_LIB_PUGIXML=1",
                   "USE_SYSTEM_LIB_RAPIDJSON=1",
                   "USE_SYSTEM_LIB_SQLITE3=1",
                   "USE_SYSTEM_LIB_UTF8PROC=1" 
                   "-j9"

    bin.install "sbc"

    # TODO the following should really be in a post_install - do that next time we build bottles!
    system "#{bin}/sbc", '-createconfig'
    inreplace 'mamesbc.ini', /rompath\s+roms/, "rompath                   #{pkgshare}/roms;roms"
    FileUtils.cp('mamesbc.ini', 'ini/mamesbc.ini')
    pkgshare.install %w[roms ini]
  end

  def caveats
    return unless latest_version_installed?

    <<~EOS
      NOTE: Machine ROMs installed in #{pkgshare}/roms by default
      A mamesbc.ini has been created for you in #{pkgshare}/ini

      You can use this by passing the -inipath argument to sbc:
          sbc -inipath $(brew --prefix)/share/mame-sbc/ini

      Or, to use this config by default, create a symlink in your home directory:
          mkdir -p ~/.mamesbc && ln -s #{HOMEBREW_PREFIX}/share/mame-sbc/ini/mamesbc.ini ~/.mamesbc/mamesbc.ini

      If you want to edit the file, it's recommended to create a
      copy of the file instead, or your changes will be overwritten
      when you upgrade in future.

          mkdir -p ~/.mamesbc && cp #{HOMEBREW_PREFIX}/share/mame-sbc/ini/mamesbc.ini ~/.mamesbc/mamesbc.ini
    EOS
  end

  test do
    assert shell_output("#{bin}/sbc -help").start_with? "MAMESBC"
    system "#{bin}/sbc", "-validate"
  end
end

class VasmAll < Formula
  desc "vasm portable and retargetable assembler."
  homepage "http://sun.hasenbraten.de/vasm/"
  url "http://phoenix.owl.de/tags/vasm1_9d.tar.gz"
  version "1.9d"
  sha256 "0e5d4285bdca8d1db9eae4ea8061788bce603bf5c1f369f070c2218b4915c985"
  
  bottle do
    root_url "https://homebrew.rosco-m68k.com/bottles"
    rebuild 1
    sha256 cellar: :any_skip_relocation, ventura: "1a6e59cdcb06008ef2b314abad2effd0400222b08080e30b3bd004608de43f43"
  end

  def install
    cpus = %w{6502 6800 6809 arm c16x jagrisc m68k pdp11 ppc qnice tr3200 vidcore x86 z80}
    syntaxes = %w{mot std madmac oldstyle}

    cpus.product(syntaxes).each do |(cpu, syntax)|
      system "make", "CPU=#{cpu}", "SYNTAX=#{syntax}"

      # There is no make install for vasm
      bin.install "vasm#{cpu}_#{syntax}"
    end
  end

  test do
    (testpath/"test.S").write <<~EOS
        section .text                     ; This is normal code

    main::
        rts                               ; And return
    EOS
    
    system "#{bin}/vasmm68k_mot", "-o", "test", "test.S"
  end
end

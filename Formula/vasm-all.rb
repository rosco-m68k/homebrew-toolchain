class VasmAll < Formula
  desc "vasm portable and retargetable assembler."
  homepage "http://sun.hasenbraten.de/vasm/"
  url "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz"
  version "1.8f"
  sha256 "17f0fbf559c373ec533284672915a08727730e0f470e984f2a93e945270cc6cb"
  
  def install
    cpus = %w{6502 6800 arm c16x jagrisc m68k ppc qnice tr3200 vidcore x86 z80}
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

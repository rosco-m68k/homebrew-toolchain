class VasmAll < Formula
  desc "vasm portable and retargetable assembler."
  homepage "http://sun.hasenbraten.de/vasm/"
  url "http://sun.hasenbraten.de/vasm/release/vasm.tar.gz"
  version "1.8f"
  sha256 "2b7aba9b6d0a196a2ab009fbed08f10acd94da41d11d3a224cb59b2a6c2f2b41"
  
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

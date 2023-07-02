class VasmM68k < Formula
  desc "vasm portable and retargetable assembler (m68k relatives only)."
  homepage "http://sun.hasenbraten.de/vasm/"
  url "http://phoenix.owl.de/tags/vasm1_9d.tar.gz"
  version "1.9d"
  sha256 "0e5d4285bdca8d1db9eae4ea8061788bce603bf5c1f369f070c2218b4915c985"
  
  def install
    cpus = %w{6800 6809 m68k ppc}
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

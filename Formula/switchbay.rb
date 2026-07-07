class Switchbay < Formula
  desc "Terminal-first AI coding workbench with cloud and local model lanes"
  homepage "https://github.com/genoventures-labs/Switchbay"
  url "https://github.com/genoventures-labs/Switchbay/releases/download/v0.9.60/switchbay-0.9.60.tar.gz"
  sha256 "d52058d3f12e4b0b425b4202bad151fa927c4d61e2ca6f50b37af0e0f32e0beb"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    system "bun", "install", "--frozen-lockfile"
    (bin/"switchbay").write <<~SH
      #!/bin/bash
      exec bun "#{prefix}/index.tsx" "$@"
    SH
    prefix.install Dir["*"]
  end

  def caveats
    <<~EOS
      Cloud lane:
        export SWITCHBAY_LANE=cloud
        export OPENAI_API_KEY=...
        export ANTHROPIC_API_KEY=...

      Local lane:
        export SWITCHBAY_LANE=local
        export SWITCHBAY_LMSTUDIO_BASE=http://YOUR-LM-STUDIO-HOST:1234/v1
        export SWITCHBAY_LMSTUDIO_API_KEY=...
    EOS
  end

  test do
    assert_match "switchbay", shell_output("#{bin}/switchbay --help 2>&1")
  end
end

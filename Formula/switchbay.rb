class Switchbay < Formula
  desc "Terminal-first AI coding workbench with cloud and local model lanes"
  homepage "https://github.com/genoventures-labs/Switchbay"
  url "https://github.com/genoventures-labs/Switchbay/releases/download/v0.9.50/switchbay-0.9.50.tar.gz"
  sha256 "09f3e55b18497d0175967e15e718d446daab1182f6314da12d505789ee95c2cd"
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
        export SWITCHBAY_LMSTUDIO_BASE=http://127.0.0.1:1234/v1
    EOS
  end

  test do
    assert_match "switchbay", shell_output("#{bin}/switchbay --help 2>&1")
  end
end

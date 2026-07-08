class Switchbay < Formula
  desc "Terminal-first AI coding workbench with cloud, local, and MCP lanes"
  homepage "https://github.com/genoventures-labs/Switchbay"
  url "https://github.com/genoventures-labs/Switchbay/releases/download/v0.9.73/switchbay-0.9.73.tar.gz"
  sha256 "0f9666f2350b6cdb3141d78f71d0e9ada7e03ca4b98ac8c7ccfc05c7a2c6eebe"
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
        # Optional MCP lane:
        # export SWITCHBAY_LANE=local-mcp
        # switchbay mcp init
    EOS
  end

  test do
    assert_match "switchbay", shell_output("#{bin}/switchbay --help 2>&1")
  end
end

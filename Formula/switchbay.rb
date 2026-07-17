class Switchbay < Formula
  desc "Terminal-first AI coding workbench with cloud/local model lanes and MCP bridge"
  homepage "https://github.com/genoventures-labs/Switchbay"
  url "https://github.com/genoventures-labs/Switchbay/releases/download/v1.6.1410/switchbay-1.6.1410.tar.gz"
  sha256 "419e8dee64a60a9cf36aa7a759688a94836b35e0a995bc53a85a106993b5f8c5"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    system "bun", "install", "--frozen-lockfile"
    prefix.install Dir["*"]
    rm_f bin/"switchbay"
    (bin/"switchbay").write <<~SH
      #!/bin/bash
      exec bun "#{prefix}/index.tsx" "$@"
    SH
  end

  def caveats
    <<~EOS
      Cloud lane:
        export SWITCHBAY_LANE=cloud
        export OPENAI_API_KEY=...
        export ANTHROPIC_API_KEY=...

      Switchbay MCP bridge:
        export SWITCHBAY_MCP=on
        # or: export SWITCHBAY_TOOL_MODE=switchbay-mcp

      Cloud MCP lane:
        export SWITCHBAY_LANE=cloud-mcp
        export OPENAI_API_KEY=...
        export ANTHROPIC_API_KEY=...

      Switchbay MCP bridge:
        export SWITCHBAY_MCP=on
        # or: export SWITCHBAY_TOOL_MODE=switchbay-mcp

      Local lane:
        export SWITCHBAY_LANE=local
        export SWITCHBAY_LMSTUDIO_BASE=http://YOUR-LM-STUDIO-HOST:1234/v1
        export SWITCHBAY_LMSTUDIO_API_KEY=...
        # Legacy/native LM Studio MCP testing:
        # export SWITCHBAY_LANE=native-mcp
        # switchbay mcp init
        # Optional MCP lane:
        # export SWITCHBAY_LANE=local-mcp
        # switchbay mcp init
    EOS
  end

  test do
    assert_match "switchbay", shell_output("#{bin}/switchbay --help 2>&1")
  end
end

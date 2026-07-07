class OriCode < Formula
  desc "Terminal-first AI coding workbench with cloud and local model lanes"
  homepage "https://github.com/genoventures-labs/ori-code"
  url "https://github.com/genoventures-labs/ori-code/releases/download/v0.9.47/ori-code-0.9.47.tar.gz"
  sha256 "401b72a8da32979cd3f7b7c2f30c2ef49cbb6e2b11e57191bc8aeab88210c018"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    system "bun", "install", "--frozen-lockfile"
    (bin/"switchbay").write <<~SH
      #!/bin/bash
      exec bun "#{prefix}/index.tsx" "$@"
    SH
    (bin/"ori-code").write <<~SH
      #!/bin/bash
      exec bun "#{prefix}/index.tsx" "$@"
    SH
    (bin/"code-harness").write <<~SH
      #!/bin/bash
      exec bun "#{prefix}/index.tsx" "$@"
    SH
    (bin/"ori").write <<~SH
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

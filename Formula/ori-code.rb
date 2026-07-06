class OriCode < Formula
  desc "Provider-neutral terminal coding agent harness"
  homepage "https://github.com/genoventures-labs/ori-code"
  url "https://github.com/genoventures-labs/ori-code/releases/download/v0.9.46/ori-code-0.9.46.tar.gz"
  sha256 "073cc137375f878760556d86c859c9c40c7a2da77ce186c874647092275667c5"
  license "MIT"

  depends_on "oven-sh/bun/bun"

  def install
    system "bun", "install", "--frozen-lockfile"
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
        export HARNESS_LANE=cloud
        export OPENAI_API_KEY=...
        export ANTHROPIC_API_KEY=...

      Local lane:
        export HARNESS_LANE=local
        export HARNESS_LMSTUDIO_BASE=http://127.0.0.1:1234/v1
    EOS
  end

  test do
    assert_match "code-harness", shell_output("#{bin}/code-harness --help 2>&1")
  end
end

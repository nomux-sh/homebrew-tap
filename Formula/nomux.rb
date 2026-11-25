class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.2.1/nomux-0.2.1-aarch64-apple-darwin.tar.gz"
      sha256 "fe82a06c4606917787618d300da532c0456052aebf982174717de7ca0a7bf38c"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.2.1/nomux-0.2.1-x86_64-apple-darwin.tar.gz"
      sha256 "1f7a10b042bec336d5a19c050c8a56ebf9f5766621df714bbdcbf497774d0954"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.2.1/nomux-0.2.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "acdcc7ecfbf3794bda3758c82822b2ebcba9e4f8f2691fc14adfb9cfa3fb8fc9"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.2.1/nomux-0.2.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "130522a7a8543360c25d9b64c1e9c3e2b7249e9ba907ffcc58576f870d115ee2"
    end
  end

  def install
    bin.install "nomux", "nomuxd", "nomux-holder"
  end

  test do
    ["nomux", "nomuxd", "nomux-holder"].each do |binary|
      assert_equal "#{binary} #{version}", shell_output("#{bin}/#{binary} --version").strip
    end
  end
end

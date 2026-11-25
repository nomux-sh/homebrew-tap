class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.1.1/nomux-0.1.1-aarch64-apple-darwin.tar.gz"
      sha256 "19ad894e17870ee25cd1a938b3f3e9f3f7d7daf7909742414a8936b88fd97e53"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.1.1/nomux-0.1.1-x86_64-apple-darwin.tar.gz"
      sha256 "31cea4d5d3c6bbf3e9a2a1dae4ec0a45a9d01d8aa11599ec91f870ff1bee9a52"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.1.1/nomux-0.1.1-aarch64-unknown-linux-musl.tar.gz"
      sha256 "87d50e556d4ffa300b53ceef56848ea1c1526ebf0a7c31aacdbbe3b923e65fef"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.1.1/nomux-0.1.1-x86_64-unknown-linux-musl.tar.gz"
      sha256 "ceed8a6ac5a8725295c5843e5939113ade4bfc29340dff872200756138cd5a01"
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

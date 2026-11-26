class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

  on_macos do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.3.0/nomux-0.3.0-aarch64-apple-darwin.tar.gz"
      sha256 "5332dd0b26711fde546b79f683b72427be9ed20efade88b111ed605c1855ada1"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.3.0/nomux-0.3.0-x86_64-apple-darwin.tar.gz"
      sha256 "41517ab02e3ea6927a4ce680e0055a264066e7c0d939f19deeb0cec040cba3ab"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.3.0/nomux-0.3.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "7e76d2834b72efb20027636c5a18ccc3194426ba10c2da040d12f2d7cd039092"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.3.0/nomux-0.3.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "911cd0950af9df41672a40c36ec83952b3ebd594f201a858483d108d49c9410e"
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

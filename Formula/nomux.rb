class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/nomux-sh/homebrew-tap/releases/download/nomux-0.5.0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f203333960dac8ee3cc337a545aaef7bb0ae8100603a35cd01f1b42a0d5bad41"
    sha256 cellar: :any_skip_relocation, big_sur:       "bd3c69e909ceb2b1566701bf6f6b38008e6f0a6006123945316f2f6927574e26"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5b2b33b1272cec15fa9b19db5b7271142e610044b36aef854af7212b786e5e54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47b80c1a92a08fd7fe83cb0e005b86aff6be3b235d06169333d9a5498ff5e32a"
  end

  on_macos do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.5.0/nomux-0.5.0-aarch64-apple-darwin.tar.gz"
      sha256 "d4d67e31233188a0c9bc988613cb86207521c7134b630232d9edb5662723b8e9"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.5.0/nomux-0.5.0-x86_64-apple-darwin.tar.gz"
      sha256 "2545c13ff48053c9191a12acd2339a0eb6f12d83f14b1ac928e933d32bbac65f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.5.0/nomux-0.5.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "848a71518324ef65910c9805ac68bc055a020853e0297df97c83f8de04f0fde0"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.5.0/nomux-0.5.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "f3a1b8d50cc1a051e8d6102733898c81dc061d7b0ce017b8e2a0eaf415db04c4"
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

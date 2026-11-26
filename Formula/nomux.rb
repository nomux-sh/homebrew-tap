class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

  bottle do
    root_url "https://github.com/nomux-sh/homebrew-tap/releases/download/nomux-0.4.0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "14570b64b64426bfd82bc4043ffd70d7e84919134d5b5fce6247f36efd77745c"
    sha256 cellar: :any_skip_relocation, big_sur:       "c4f07834feaf8d7ceb8fa2efc37d193ebfcd4ce2330f24f972a4a0e3e8d435fe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "421200b614b66104faf912095f90e5539a81cf90980576143ad81d4297c0cb10"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "125dc1882a65e162c227ed59b5018b4166bcfc817288842edfe2ac8ccc543582"
  end

  on_macos do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.4.0/nomux-0.4.0-aarch64-apple-darwin.tar.gz"
      sha256 "d9632365f8f9b70dd4af4a1cbd70f35da9f70736361fdd6bfc69d9b8a33f9ec1"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.4.0/nomux-0.4.0-x86_64-apple-darwin.tar.gz"
      sha256 "4252dabdddcef583bc7b39fa00ab7387a9485502dafe02aac11de1bf4e089c7f"
    end
  end

  on_linux do
    on_arm do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.4.0/nomux-0.4.0-aarch64-unknown-linux-musl.tar.gz"
      sha256 "df80ae2f89ddf9252bc09f1d0e932d73b613a6cbb8f6e424c2939c755b0d71ed"
    end
    on_intel do
      url "https://github.com/nomux-sh/nomux/releases/download/v0.4.0/nomux-0.4.0-x86_64-unknown-linux-musl.tar.gz"
      sha256 "5fbd9c4bca24e5da0903e6a143b3e3b912bac05675bd453ce53f08ddf6619bdd"
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

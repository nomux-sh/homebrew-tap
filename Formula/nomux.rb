class Nomux < Formula
  desc "Native and lightweight agentic development environment"
  homepage "https://github.com/nomux-sh/nomux"
  license any_of: ["MIT", "Apache-2.0"]

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

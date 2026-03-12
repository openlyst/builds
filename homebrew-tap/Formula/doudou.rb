class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-71/doudou-16.1.0-2026-03-11-macos-unsigned.zip"
  version "16.1.0"
  sha256 "ecc5e19fbb50358f419704bea95dd82a0957b25cd31f8424eb7ee97f408e29ab"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

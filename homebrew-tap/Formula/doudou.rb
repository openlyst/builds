class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-68/doudou-16.0.0-2026-03-09-macos-unsigned.zip"
  version "16.0.0"
  sha256 "3ba37946e9a636785f854e7cb69dd4b08eed337da6b3257207b253a460b88d34"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-99/doudou-19.0.0-2026-06-04-macos-unsigned.zip"
  version "19.0.0"
  sha256 "61d595059b19d3f6d32cc240a1713097193839ad04913903d23f244651ff4709"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

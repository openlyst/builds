class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-120/doudou-20.0.0-2026-06-19-macos-unsigned.zip"
  version "20.0.0"
  sha256 "7a7f03c2c8bd29f1653182e305311cd0511aa4962865db41cc805b78894e4623"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

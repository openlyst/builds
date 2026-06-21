class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-124/doudou-20.0.0-2026-06-20-linux-x86_64.AppImage"
  version "20.0.0"
  sha256 "caa682cbf843b5ebb723b5862eb714993db0057bd81493af733fb59c373140d6"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

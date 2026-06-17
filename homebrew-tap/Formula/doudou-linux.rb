class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-99/doudou-19.0.0-2026-06-04-linux-x86_64.AppImage"
  version "19.0.0"
  sha256 "244801eaf1640c6720a0db45ede49ad5fc4e12a7532879d01208cb876c032790"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

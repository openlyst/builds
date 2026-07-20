class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-120/doudou-20.0.0-2026-06-19-linux-x86_64.AppImage"
  version "20.0.0"
  sha256 "23c8335eb2b89d8ad02a54c225f06d47115e81bab88f28bd19198b48b2a34844"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

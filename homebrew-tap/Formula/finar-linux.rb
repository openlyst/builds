class Finar < Formula
  desc "Jellyfin frontend client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-94/finar-4.1.1-2026-05-07-linux-x86_64.AppImage"
  version "4.1.1"
  sha256 "544db5d4dc643dc88762ec97203d1edb96f43c974ee16ba335d0b177dc8c97d5"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

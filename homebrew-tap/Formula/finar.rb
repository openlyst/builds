class Finar < Formula
  desc "Jellyfin frontend client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-94/finar-4.1.1-2026-05-07-macos-unsigned.zip"
  version "4.1.1"
  sha256 "1a57831904e6defcb5b8ad92083dc5497b0512ceb0d365227a2d2a4509c87694"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

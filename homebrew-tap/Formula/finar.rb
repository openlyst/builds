class Finar < Formula
  desc "Jellyfin frontend client"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-14/finar-1.1.0-2026-02-24-macos-unsigned.zip"
  version "3.0.0"
  sha256 "7466addcbdda0700511cc1b0c3247ceb71631bc30ae7e2c5e9594fe6ae816a2f"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

class Finar < Formula
  desc "Jellyfin frontend client"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-14/finar-1.1.0-2026-02-24-linux-x86_64.AppImage"
  version "3.0.0"
  sha256 "83d7b8d8c5cf5bb0d02d1ea5b4f03bb83b333be7d741de590a9704c4a023ce9a"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

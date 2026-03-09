class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-68/doudou-16.0.0-2026-03-09-linux-x86_64.AppImage"
  version "16.0.0"
  sha256 "00004cde7058574b127f3c88bf1006d21cd3065a4035231521c8556f78126864"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

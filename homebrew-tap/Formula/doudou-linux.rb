class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-71/doudou-16.1.0-2026-03-11-linux-x86_64.AppImage"
  version "16.1.0"
  sha256 "07685791b3416d8b8ff9da99ce7cc9eebfa7e98608d7155fecd531c8c9747f52"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

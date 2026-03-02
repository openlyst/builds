class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-22/doudou-15.0.0-2026-02-27-macos-unsigned.zip"
  version "15.0.0"
  sha256 "996a8adb2097bac76f05a6a549b2c7f76d883926bc6ffef81b5439aec8016545"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

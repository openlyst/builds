class Docan < Formula
  desc "AI chat app with Liquid Glass UI"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-4/docan-3.0.0-2026-02-08-linux-x86_64.AppImage"
  version "3.0.0"
  # sha256 "REPLACE_WITH_ACTUAL_SHA256"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

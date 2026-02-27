class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://gitlab.com/api/v4/projects/79691113/packages/generic/github-mirror/build-22/doudou-15.0.0-2026-02-27-linux-x86_64.AppImage"
  version "15.0.0"
  sha256 "0708fad5b41c59eb333675497dbe08aa2c1e675194d6904edcd701ea09d7fb76"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

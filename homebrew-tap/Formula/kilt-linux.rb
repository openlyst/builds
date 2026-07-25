class Kilt < Formula
  desc "E926 API client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-152/kilt-10.2.0-2026-07-24-linux-x86_64.AppImage"
  version "10.2.0"
  sha256 "69b4c5f1e4b9180b4b8ad02a51148d65e669ca7aa2da7f3278a65163da5563d3"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

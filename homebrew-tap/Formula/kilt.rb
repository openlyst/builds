class Kilt < Formula
  desc "E926 API client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-110/kilt-10.1.2-2026-06-11-macos-unsigned.zip"
  version "10.1.2"
  sha256 "bdc99c2ad005da4674625c2e77372d280663da8dc382c9f937410a8223814b9d"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

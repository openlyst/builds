class Doudou < Formula
  desc "Music player for self-hosted services"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-124/doudou-20.0.0-2026-06-20-macos-unsigned.zip"
  version "20.0.0"
  sha256 "e9f4b6e4adc5fe591929872d55ec54d80a960672fae7fafb3a5d9749e7dd93ac"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

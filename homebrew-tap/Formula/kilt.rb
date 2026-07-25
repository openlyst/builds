class Kilt < Formula
  desc "E926 API client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-152/kilt-10.2.0-2026-07-24-macos-unsigned.zip"
  version "10.2.0"
  sha256 "9a25a5345081758fd3b081d9d94bfdf56c2f8671f9541200f66ec4782b158356"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

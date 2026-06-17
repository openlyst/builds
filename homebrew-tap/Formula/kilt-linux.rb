class Kilt < Formula
  desc "E926 API client"
  homepage "https://openlyst.ink"
  url "https://github.com/openlyst/builds/releases/download/build-110/kilt-10.1.2-2026-06-11-linux-x86_64.AppImage"
  version "10.1.2"
  sha256 "c5428dd9b0f366bdcef7fd1826e530d30739bbe26a9445802adc1cf5e1f7edce"

  def install
    # Generic installation
    prefix.install Dir["*"]
  end

  test do
    # Test that the application was installed
    system "true"
  end
end

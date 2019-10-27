class Cocore < Formula
  desc "converts color representation such as HSL colors and RGB colors"
  homepage "https://github.com/KoharaKazuya/cocore"
  url "https://github.com/KoharaKazuya/cocore/releases/download/v0.1.0/cocore-x86_64-apple-darwin"
  version "0.1.0"
  sha256 "cbe2e2af98ef80d50fcc58e4f23a35fbc7674feeeb8e8a4f15ebc7af1e4b024f"
  head "https://github.com/KoharaKazuya/cocore.git"

  def install
    mv "cocore-x86_64-apple-darwin", "cocore"
    chmod "+x", "cocore"
    bin.install "cocore"
  end

  test do
    assert_match "cocore", shell_output("#{bin}/cocore -h")
  end
end

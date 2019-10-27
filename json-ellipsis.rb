class JsonEllipsis < Formula
  desc "replace a part of large JSON with ellipsis in order to a specified bytes or less"
  homepage "https://github.com/KoharaKazuya/json_ellipsis"
  url "https://github.com/KoharaKazuya/json_ellipsis/releases/download/v0.1.0/json-ellipsis-v0.1.0-x86_64-apple-darwin.zip"
  version "0.1.0"
  sha256 "1c254530955132fd6bfe3e919c56c70deb39a3c07ca5d5af6654bbca8d565703"
  head "https://github.com/KoharaKazuya/json_ellipsis.git"

  def install
    chmod "+x", "json-ellipsis"
    bin.install "json-ellipsis"
  end

  test do
    assert_match "json-ellipsis", shell_output("#{bin}/json-ellipsis -h")
  end
end

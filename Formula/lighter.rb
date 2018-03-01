class Lighter < Formula
  # cite Song_2014: "https://doi.org/10.1186/s13059-014-0509-9"
  desc "Fast and memory-efficient sequencing error corrector"
  homepage "https://github.com/mourisl/Lighter"
  url "https://github.com/mourisl/Lighter/archive/v1.1.1.tar.gz"
  sha256 "9b29b87cd87f6d57ef8c39d22fb8679977128a1bdf557d8c161eae2816e374b7"
  revision 2
  head "https://github.com/mourisl/Lighter.git"

  depends_on "zlib" unless OS.mac?

  def install
    # Miscompiles with -Os, see https://github.com/mourisl/Lighter/issues/24
    ENV.O2
    system "make"
    bin.install "lighter"
  end

  test do
    assert_match "num_of_threads", shell_output("#{bin}/lighter -h 2>&1")
    assert_match version.to_s, shell_output("#{bin}/lighter -v 2>&1")
  end
end

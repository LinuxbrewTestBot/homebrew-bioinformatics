class Kalign < Formula
  # cite Lassmann_2009: "https://doi.org/10.1093/nar/gkn1006"
  desc "SIMD accelerated multiple sequence alignment"
  homepage "https://github.com/TimoLassmann/kalign"
  url "https://github.com/TimoLassmann/kalign/archive/3.1.tar.gz"
  sha256 "cd10303d7b839b57531e94a87f758921947ebcd47bb7163e525415fa28c1c86b"

  bottle do
    cellar :any_skip_relocation
    sha256 "5f30bb01cdba0aaa3c93ef2a707ecb5687fcd42596bc08d033552f6b48a26051" => :mojave
    sha256 "0eb4240bdceebc5f95e5a07b36c85821d0d48719d33d6d032eb49751b9a0191b" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  def install
    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/kalign -V 2>&1")
  end
end

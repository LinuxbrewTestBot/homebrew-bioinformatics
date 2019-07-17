class Megahit < Formula
  # cite Li_2015: "https://doi.org/10.1093/bioinformatics/btv033"
  desc "Ultra-fast SMP/GPU succinct DBG metagenome assembly"
  homepage "https://github.com/voutcn/megahit"
  url "https://github.com/voutcn/megahit/archive/v1.1.4.tar.gz"
  sha256 "ecd64c8bfa516ef6b19f9b2961ede281ec814db836f1a91953c213c944e1575f"
  head "https://github.com/voutcn/megahit.git"

  bottle do
    root_url "https://linuxbrew.bintray.com/bottles-bio"
    sha256 "c82763b2625de5ccb1c9d5c671eb4c4aae36c584b569f3330618d70b7ac568d8" => :sierra
    sha256 "48f6cacd8476c46690ec7d4e094e3280a34762d4678c127633c8dc6ab5b9a006" => :x86_64_linux
  end

  depends_on "gcc@8" if OS.mac?
  depends_on "python@2"

  fails_with :gcc => "9"
  fails_with :clang # needs openmp

  if OS.mac?
    depends_on "gcc" # for openmp
  else
    depends_on "zlib"
  end

  def install
    system "make"
    bin.install Dir["megahi*"]
    pkgshare.install "example"
  end

  test do
    outdir = "megahit.outdir"
    system "#{bin}/megahit", "--12", "#{pkgshare}/example/readsInterleaved1.fa.gz", "-o", outdir
    assert_predicate testpath/"#{outdir}/final.contigs.fa", :exist?
    assert_match outdir, File.read("#{outdir}/opts.txt")
  end
end

class Treepl < Formula
  # cite Smith_2012: "https://doi.org/10.1093/bioinformatics/bts492"
  desc "Dating phylogenies with penalized likelihood"
  homepage "https://github.com/blackrim/treePL/wiki"
  url "https://github.com/blackrim/treePL/archive/fcddad99f4ecbada67ecd210f12fefa762f0d51c.tar.gz"
  version "2017.05.23"
  sha256 "7543dbf3cc174bc4b7a39618267439c11c9cd5d1f18ef5b42f0159f389684370"
  head "https://github.com/blackrim/treePL.git"

  bottle do
    root_url "https://homebrew.bintray.com/bottles-bio"
    prefix "/usr/local"
    cellar :any
    sha256 "32ca33f557f19da2355bf1c4ea00a176e7e4ad45420d9509f4c3a80555efabed" => :sierra
    sha256 "bc12c0f4376fd6c90835a47368654ea7f9c56eba6fbe78b40c7d23909742b7ac" => :x86_64_linux
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "gcc" if OS.mac? # needs OpenMP support
  depends_on "nlopt"

  fails_with :clang # needs OpenMP support

  def install
    ENV.refurbish_args

    # Use the vendored copy of ADOL-C
    cd "deps" do
      system "tar", "xvf", "adol-c_git_saved.tar.gz"
      cd "adol-c" do
        system "autoreconf", "-fvi"
        system "./configure", "--with-openmp-flag=-fopenmp", "--prefix=#{libexec}"
        system "make", "install"
      end
    end

    cd "src" do
      # Tell configure where to find libraries. The ordering is very strict
      nlopt = Formula["nlopt"]
      ENV.prepend "CPPFLAGS", "-I#{libexec}/include"
      ENV.append_to_cflags "-I#{nlopt.include}"
      ENV.append "LDFLAGS", "-L#{nlopt.lib}"
      ENV.prepend "LDFLAGS", "-L#{libexec}/lib64"
      ENV.prepend "LDFLAGS", "-Wl,-rpath,#{libexec}/lib64" unless OS.mac? # don't use RPATH on macOS

      system "./configure"
      system "make"
      bin.install "treePL"
    end

    pkgshare.install "examples"
  end

  test do
    cp_r opt_pkgshare/"examples", testpath
    cd testpath/"examples" do
      system "#{bin}/treePL", "clock.cppr8s"
      system "#{bin}/treePL", "test.cppr8s"
    end
  end
end

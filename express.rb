class Express < Formula
  desc "Streaming quantification for sequencing"
  homepage "http://bio.math.berkeley.edu/eXpress/"
  url "https://pachterlab.github.io/eXpress/downloads/express-1.5.1/express-1.5.1-src.tgz"
  sha256 "0c5840a42da830fd8701dda8eef13f4792248bab4e56d665a0e2ca075aff2c0f"
  revision 9
  head "https://github.com/adarob/eXpress.git"

  # doi "10.1038/nmeth.2251"
  # tag "bioinformatics"

  bottle do
    cellar :any
    sha256 "84931d98f06484db897be2e48de9bf2fbce638ecfa0964faba51de3d66ef305f" => :sierra
    sha256 "f6f7602f9b234eeca8da2f2abbb0fb5a0294a39c61fa91a9d20288baf84ed950" => :el_capitan
    sha256 "5958675433a77b743711c1c40b86bf8c8509f2316d2364000e6957c24d78a0a7" => :x86_64_linux
  end

  depends_on "bamtools"
  depends_on "boost"
  depends_on "cmake" => :build
  depends_on "protobuf" => :recommended
  depends_on "gperftools" => :recommended

  def install
    inreplace "CMakeLists.txt", "set(Boost_USE_STATIC_LIBS ON)", ""

    # Fix undefined reference to `deflate'
    inreplace "src/CMakeLists.txt", 'libbamtools.a"', 'libbamtools.a" "-lz"'

    mkdir "bamtools"
    ln_s Formula["bamtools"].include/"bamtools", "bamtools/include"
    ln_s Formula["bamtools"].lib, "bamtools/"
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/express 2>&1", 1)
  end
end

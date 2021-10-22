class Gnuplot < Formula
  desc "Command-driven, interactive function plotting (patched for --with-aquaterm)"
  homepage "http://www.gnuplot.info/"
  url "https://downloads.sourceforge.net/project/gnuplot/gnuplot/5.4.2/gnuplot-5.4.2.tar.gz"
  version "5.4.2-with-aquaterm"
  sha256 "e57c75e1318133951d32a83bcdc4aff17fed28722c4e71f2305cfc2ae1cae7ba"

  depends_on "pkg-config" => :build
  depends_on "gd"
  depends_on "libcerf"
  depends_on "lua"
  depends_on "pango"
  depends_on "readline"

  def install
    ENV.prepend "CPPFLAGS", "-F/Library/Frameworks"
    ENV.prepend "LDFLAGS", "-F/Library/Frameworks"

    args = %W[
      --disable-dependency-tracking
      --disable-silent-rules
      --prefix=#{prefix}
      --with-readline=#{Formula["readline"].opt_prefix}
      --without-tutorial
      --disable-wxwidgets
      --without-x
      --with-aquaterm
    ]

    system "./configure", *args
    ENV.deparallelize
    system "make"
    system "make", "install"
  end

  test do
    system "#{bin}/gnuplot", "-e", <<~EOS
      set terminal dumb;
      set output "#{testpath}/graph.txt";
      plot sin(x);
    EOS
    assert_predicate testpath/"graph.txt", :exist?
  end
end

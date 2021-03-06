# This file was generated and will be overwritten by ./generate.sh

{ stdenv, fetchurl, lib }:

stdenv.mkDerivation rec {
  name = "python27-docs-text-2.7.3";
  src = fetchurl {
    url = http://docs.python.org/ftp/python/doc/2.7.3/python-2.7.3-docs-text.tar.bz2;
    sha256 = "1rxlb3jhh3892y65i45nk1y2lx981fr22a5hmfkp9gvjvdykjnzp";
  };
  installPhase = ''
    mkdir -p $out/share/doc/python27
    cp -R ./ $out/share/doc/python27/text
  '';
  meta = {
    maintainers = [ lib.maintainers.chaoflow ];
  };
}

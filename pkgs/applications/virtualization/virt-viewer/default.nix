{ stdenv, fetchurl, pkgconfig, intltool, glib, libxml2, gtk3, gtkvnc, gmp
, libgcrypt, gnupg, cyrus_sasl, shared_mime_info, libvirt, yajl, xen
, gsettings_desktop_schemas, makeWrapper, libvirt-glib, libcap_ng, numactl
, libapparmor
, spiceSupport ? true
, spice_gtk ? null, spice_protocol ? null, libcap ? null, gdbm ? null
}:

assert spiceSupport ->
  spice_gtk != null && spice_protocol != null && libcap != null && gdbm != null;

with stdenv.lib;

stdenv.mkDerivation rec {
  baseName = "virt-viewer";
  version = "6.0";
  name = "${baseName}-${version}";

  src = fetchurl {
    url = "http://virt-manager.org/download/sources/${baseName}/${name}.tar.gz";
    sha256 = "1chqrf658niivzfh85cbwkbv9vyg8sv1mv3i31vawkfsfdvvsdwh";
  };

  nativeBuildInputs = [ pkgconfig intltool ];
  buildInputs = [
    glib libxml2 gtk3 gtkvnc gmp libgcrypt gnupg cyrus_sasl shared_mime_info
    libvirt yajl gsettings_desktop_schemas makeWrapper libvirt-glib
    libcap_ng numactl libapparmor
  ] ++ optionals stdenv.isx86_64 [
    xen
  ] ++ optionals spiceSupport [
    spice_gtk spice_protocol libcap gdbm
  ];

  postInstall = ''
    for f in "$out"/bin/*; do
        wrapProgram "$f" --prefix XDG_DATA_DIRS : "$GSETTINGS_SCHEMAS_PATH"
    done
  '';

  meta = {
    description = "A viewer for remote virtual machines";
    maintainers = [ maintainers.raskin ];
    platforms = platforms.linux;
    license = licenses.gpl2;
  };
  passthru = {
    updateInfo = {
      downloadPage = "http://virt-manager.org/download.html";
    };
  };
}

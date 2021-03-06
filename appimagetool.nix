{ stdenv, fetchurl, fuse, zlib }:

# This is from some binaries.

# Ideally, this should be source based,
# but I can't get it to build from GitHub

stdenv.mkDerivation rec {
  name = "appimagekit";

  src = fetchurl {
    url = "https://github.com/probonopd/AppImageKit/releases/download/continuous/appimagetool-x86_64.AppImage";
    sha256 = "0l3hxp169dpyj3h38q9nsnh1cynam1j5zx8q362p93448rhm7d0y";
  };

  sourceRoot = "squashfs-root";

  unpackPhase = ''
    cp $src appimagetool-x86_64.AppImage
    chmod u+wx appimagetool-x86_64.AppImage
    patchelf --set-interpreter $(cat $NIX_CC/nix-support/dynamic-linker) \
             --set-rpath ${fuse}/lib:${zlib}/lib \
             appimagetool-x86_64.AppImage
    ./appimagetool-x86_64.AppImage --appimage-extract
  '';

  installPhase = ''
    mkdir -p $out
    cp -r usr/* $out
  '';

  dontPatchELF = true;
}

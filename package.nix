{ stdenv
, src
, fetchFromGitHub
, pandoc
, openjdk8
, ocaml
, opam
, maven
, z3
, mpfr
, autoconf
, automake
, libtool
, ncurses
, unzip
, git
, curl
, rsync
, gcc
, perl
, which
, pkgconfig
, flex
, zlib
, python3
, gnused
}:

stdenv.mkDerivation {
  inherit src;

  name = "kevm";

  # patches = [ ./kevm.patch ];
  buildInputs = [ gnused pandoc openjdk8 ocaml opam maven z3 mpfr autoconf automake libtool ncurses unzip git curl rsync gcc perl which pkgconfig flex zlib python3 ];

  configurePhase = ''
    export HOME="$NIX_BUILD_TOP"
    export NIX_CFLAGS_COMPILE="-Wno-error=unused-result $NIX_CFLAGS_COMPILE"
    sed -i "s#mvn#mvn -Dmaven.repo.local=$HOME/.m2#" Makefile
    make deps
  '';

  installPhase = ''
    mkdir $out
    mv .build/local/lib $out/
    mv .build/vm $out/bin
  '';
}

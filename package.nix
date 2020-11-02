{ stdenv
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
}:

stdenv.mkDerivation {
  name = "kevm";

  src = fetchFromGitHub {
    owner = "kframework";
    repo = "evm-semantics";
    rev = "cc9c659510383215e5333d7f60088a2fdf2d120d";
    sha256 = "sha256-ZY9IQKIUmbfe7qgnr69XdHe+oVq5qXiHsv24nFc/Wlo=";
    fetchSubmodules = true;
    leaveDotGit = true;
  };

  patches = [ ./kevm.patch ];
  buildInputs = [ pandoc openjdk8 ocaml opam maven z3 mpfr autoconf automake libtool ncurses unzip git curl rsync gcc perl which pkgconfig flex zlib python3 ];

  configurePhase = ''
    export HOME="$NIX_BUILD_TOP"
    export NIX_CFLAGS_COMPILE="-Wno-error=unused-result $NIX_CFLAGS_COMPILE"
    make deps
  '';

  installPhase = ''
    mkdir $out
    mv .build/local/lib $out/
    mv .build/vm $out/bin
  '';
}

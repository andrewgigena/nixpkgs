{
  lib,
  stdenv,
  fetchFromGitHub,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
  headers = [
    "include/GL/internal/dri_interface.h"
    "include/EGL/eglext_angle.h"
    "include/EGL/eglmesaext.h"
  ];
in
stdenv.mkDerivation rec {
  pname = "mesa-gl-headers";

  # These are a bigger rebuild and don't change often, so keep them separate.
  version = "25.0.6";

  src = fetchFromGitHub {
    owner = "andrewgigena";
    repo = "mesa-terakan";
    rev = "terakan-mesa-${version}";
    hash = "sha256-vmQtTB1/O51AW9N+vMMj5aKsXdZh8oYOuZBPZAeUB0w=";
  };
  # src = builtins.path {
  #   name = "mesa-terakan";
  #   path = /disks/frodo/development/mesa-terakan;
  # };

  dontBuild = true;

  installPhase = ''
    for header in ${toString headers}; do
      install -Dm444 $header $out/$header
    done
  '';

  passthru = { inherit headers; };

  inherit (common) meta;
}

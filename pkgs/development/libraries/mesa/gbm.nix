{
  lib,
  stdenv,
  fetchFromGitHub,
  libglvnd,
  bison,
  flex,
  meson,
  pkg-config,
  ninja,
  python3Packages,
  libdrm,
}:

let
  common = import ./common.nix { inherit lib fetchFromGitHub; };
in
stdenv.mkDerivation rec {
  pname = "mesa-libgbm";

  # We don't use the versions from common.nix, because libgbm is a world rebuild,
  # so the updates need to happen separately on staging.
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

  # Install gbm_backend_abi.h header - this is to simplify future iteration
  # on building Mesa and friends with system libgbm.
  # See also:
  # - https://github.com/NixOS/nixpkgs/pull/387292
  # - https://gitlab.freedesktop.org/mesa/mesa/-/merge_requests/33890
  patches = [ ./gbm-header.patch ];

  mesonAutoFeatures = "disabled";

  mesonFlags = [
    "--sysconfdir=/etc"

    (lib.mesonEnable "gbm" true)
    (lib.mesonOption "gbm-backends-path" "${libglvnd.driverLink}/lib/gbm")

    (lib.mesonEnable "egl" false)
    (lib.mesonEnable "glx" false)
    (lib.mesonEnable "zlib" false)

    (lib.mesonOption "platforms" "")
    (lib.mesonOption "gallium-drivers" "")
    (lib.mesonOption "vulkan-drivers" "")
    (lib.mesonOption "vulkan-layers" "")
  ];

  strictDeps = true;

  propagatedBuildInputs = [ libdrm ];

  nativeBuildInputs = [
    bison
    flex
    meson
    pkg-config
    ninja
    python3Packages.packaging
    python3Packages.python
    python3Packages.mako
    python3Packages.pyyaml
  ];

  inherit (common) meta;
}

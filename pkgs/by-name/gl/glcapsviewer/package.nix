{
  lib,
  stdenv,
  fetchFromGitHub,
  glew,
  glfw,
  libsForQt5,
  pkg-config,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "glcapsviewer";
  version = "1.1-unstable-2025-06-20";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "glCapsViewer";
    rev = "eb621b2066f74dd277d25bdf46e28a062b592f92";
    hash = "sha256-r/Y5weCpLJapxek50aiFIP2xzPnW1TGgrtDI7Qfo5ac=";
  };

  nativeBuildInputs = [
    libsForQt5.qmake
    libsForQt5.wrapQtAppsHook
    pkg-config
  ];

  buildInputs = [
    glew
    glfw
    libsForQt5.qtx11extras
    libsForQt5.qtbase
  ];

  qmakeFlags = [
    "glCapsViewer.pro"
    "CONFIG+=x11"
  ];

  installPhase = ''
    install -Dm0555 glCapsViewer -t $out/bin
  '';

  enableParallelBuilding = true;

  meta = {
    mainProgram = "glcapsviewer";
    description = "OpenGL hardware capability viewer";
    longDescription = ''
      Client application for the OpenGL hardware capabilitiy database.
      This tool uploads OpenGL hardware reports to the OpenGL hardware database at http://opengl.gpuinfo.org
    '';
    homepage = "https://opengl.gpuinfo.org/";
    platforms = lib.platforms.linux;
    license = lib.licenses.gpl2Only;
    maintainers = with lib.maintainers; [ andrewgigena ];
    broken = stdenv.hostPlatform.isDarwin;
  };
})

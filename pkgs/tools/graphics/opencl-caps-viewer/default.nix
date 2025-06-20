{
  lib,
  stdenv,
  fetchFromGitHub,
  qmake,
  ocl-icd,
  opencl-headers,
  wrapQtAppsHook,
  qtx11extras,
  qtbase,
}:

stdenv.mkDerivation rec {
  pname = "opencl-caps-viewer";
  version = "1.20";

  src = fetchFromGitHub {
    owner = "SaschaWillems";
    repo = "OpenCLCapsViewer";
    rev = version;
    hash = "sha256-P7G8FvVXzDAfN3d4pGXC+c9x4bY08/cJNYQ6lvjyVCQ=";
    fetchSubmodules = true;
  };

  nativeBuildInputs = [
    qmake
    wrapQtAppsHook
  ];

  buildInputs = [
    ocl-icd
    opencl-headers
    qtx11extras
    qtbase
  ];

  patchPhase = ''
    # Fix installation paths
    substituteInPlace OpenCLCapsViewer.pro \
      --replace 'target.path = /usr/bin' 'target.path = /bin/' \
      --replace 'desktop.path = /usr/share/applications' 'desktop.path = /share/applications' \
      --replace 'icon.path = /usr/share/icons/hicolor/256x256/apps/' 'icon.path = /share/icons/hicolor/256x256/apps/' \
      --replace 'else: unix:!android: target.path = /opt/$${TARGET}/bin' ""

    # Fix binary path in desktop file
    substituteInPlace OpenCLCapsViewer.desktop \
      --replace 'Exec=/opt/OpenCLCapsViewer/bin/OpenCLCapsViewer' 'Exec=OpenCLCapsViewer'
  '';

  qmakeFlags = [
    "OpenCLCapsViewer.pro"
    "CONFIG+=x11"
  ];

  installFlags = [ "INSTALL_ROOT=$(out)" ];

  qtWrapperArgs = [
    "--prefix LD_LIBRARY_PATH : ${ocl-icd}/lib"
  ];

  enableParallelBuilding = true;

  meta = with lib; {
    mainProgram = "OpenCLCapsViewer";
    description = "OpenCL hardware capability viewer";
    longDescription = ''
      Client application to display hardware implementation details for devices supporting the OpenCL API by Khronos.
      The hardware reports can be submitted to a public online database that allows comparing different devices, browsing available features, extensions, formats, etc.
    '';
    homepage = "https://opencl.gpuinfo.org/";
    platforms = platforms.linux;
    license = licenses.gpl2Only;
    maintainers = with maintainers; [ andrewgigena ];
    changelog = "https://github.com/SaschaWillems/OpenCLCapsViewer/releases/tag/${version}";
    broken = stdenv.hostPlatform.isDarwin;
  };
}

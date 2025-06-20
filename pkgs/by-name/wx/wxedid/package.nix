{
  lib,
  stdenv,
  fetchurl,
  autoreconfHook,
  pkg-config,
  wxGTK32,
  makeWrapper,
  wrapGAppsHook,
  gsettings-desktop-schemas,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "wxedid";
  version = "0.0.32";

  src = fetchurl {
    url = "mirror://sourceforge/${finalAttrs.pname}/${finalAttrs.version}/${finalAttrs.pname}-${finalAttrs.version}.tar.gz";
    hash = "sha256-XYbRNuQ+ha05gJgs7P+HzxdRksFRJHxLiWDfnF5GHMI=";
  };

  nativeBuildInputs = [
    pkg-config
    autoreconfHook
    makeWrapper
    wrapGAppsHook
  ];

  buildInputs = [
    wxGTK32
    gsettings-desktop-schemas
  ];

  preConfigure = ''
    patchShebangs src/rcode/rcd_autogen
    chmod +x src/rcode/rcd_autogen
  '';

  enableParallelBuilding = true;

  meta = {
    description = "Extended Display Identification Data editor";
    longDescription = ''
      wxEDID is a wxWidgets - based EDID (Extended Display Identification Data) editor.
      This is an early stage of development, allowing to modify the base EDID v1.3+
      structure and CEA-861 (as first extension block).
      Besides normal editor functionality, the app has been equipped with a DTD
      constructor, which aims to ease timings selection/editing. It's also possible to
      export and import EDID data to/from text files (hex ASCII format) and also to
      save the structures as a human-readable text.
    '';
    homepage = "https://sourceforge.net/projects/wxedid/";
    license = lib.licenses.gpl3Plus;
    maintainers = with lib.maintainers; [ andrewgigena ];
    platforms = lib.platforms.linux;
    mainProgram = "wxedid";
  };
})

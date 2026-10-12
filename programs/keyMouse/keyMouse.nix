{ lib
, stdenv
}:

stdenv.mkDerivation {
  pname = "keymouse";
  version = "1.0.0";

  # Clean the current source directory so .git and binaries aren't copied
  src = lib.cleanSource ./.;

  # Standard C build (gcc and linux kernel headers are already in stdenv)
  buildPhase = ''
    runHook preBuild
    $CC -O3 keymouse.c -o keymouse
    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall
    install -Dm755 keymouse $out/bin/keymouse
    runHook postInstall
  '';

  meta = with lib; {
    description = "Lightweight Linux daemon to control mouse pointer via keyboard";
    homepage = "https://github.com/ritishDas/keyMouse";
    license = licenses.mit;
    platforms = platforms.linux;
    mainProgram = "keymouse";
  };
}

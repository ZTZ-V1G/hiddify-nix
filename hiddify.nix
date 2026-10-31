{ appimageTools, fetchurl }:

let
  pname = "hiddify";
  version = "4.1.1";
  src = fetchurl {
    url = "https://github.com/hiddify/hiddify-app/releases/download/v${version}/Hiddify-Linux-x64-AppImage.AppImage";
    hash = "sha256-6yu2wIlxuY4tCgH8W2R+KboXsWYRScyfl+2g53v1vcM=";
  };

  appimageContents = appimageTools.extract { inherit pname version src; };
in
appimageTools.wrapType2 {
  inherit pname version src;

  extraPkgs = pkgs: with pkgs; [
    libepoxy
    zstd
  ];

  extraInstallCommands = ''
    install -Dm444 ${appimageContents}/hiddify.desktop \
      $out/share/applications/hiddify.desktop
    install -Dm444 ${appimageContents}/hiddify.png \
      $out/share/pixmaps/hiddify.png
    sed -i 's|^Exec=.*|Exec=${pname}|' \
      $out/share/applications/hiddify.desktop
  '';

  meta = {
    description = "Multi-platform proxy client based on sing-box";
    homepage = "https://github.com/hiddify/hiddify-app";
    license = {
      fullName = "Hiddify Extended GPLv3";
      url = "https://github.com/hiddify/hiddify-app/blob/main/LICENSE.md";
      free = false;
    };
    mainProgram = "hiddify";
    platforms = [ "x86_64-linux" ];
  };
}

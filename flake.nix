{
  description = "Hiddify (unofficial Nix packaging of the upstream AppImage)";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";

    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
  };

  outputs =
    {
      nixpkgs,
      flake-utils,
      ...
    }:
    {
      overlays.default = final: prev: {
        hiddify = final.callPackage ./hiddify.nix { };
      };
    }
    // flake-utils.lib.eachSystem [ "x86_64-linux" ] (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfreePredicate = pkg: (nixpkgs.lib.getName pkg) == "hiddify";
        };
        hiddify = pkgs.callPackage ./hiddify.nix { };
      in
      {
        packages = {
          inherit hiddify;
          default = hiddify;
        };
        apps.default = {
          type = "app";
          program = "${hiddify}/bin/hiddify";
        };
      }
    );
}

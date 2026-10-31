# Hiddify Nix Flake

An **unofficial** Nix flake that packages
[Hiddify](https://github.com/hiddify/hiddify-app), a multi-platform proxy client
based on sing-box, from the upstream AppImage.

> Not affiliated with or endorsed by the Hiddify project.

## Quick Start

### Using with Flakes

Add this flake as an input to your `flake.nix`:

```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    hiddify = {
      url = "github:ZTZ-V1G/hiddify-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
}
```

Then install it in your system configuration:

```nix
environment.systemPackages = [
  inputs.hiddify.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

### Direct Installation

You can also use Hiddify without adding the flake to your inputs:

```sh
# Install to user profile
nix profile install github:ZTZ-V1G/hiddify-nix

# Or run directly
nix run github:ZTZ-V1G/hiddify-nix
```

### Home Manager

```nix
home.packages = [
  inputs.hiddify.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

### Overlay

If you prefer the overlay, note that the package is unfree (see
[License](#license)), so you must allow it yourself:

```nix
nixpkgs.overlays = [ inputs.hiddify.overlays.default ];
nixpkgs.config.allowUnfreePredicate = pkg:
  builtins.elem (lib.getName pkg) [ "hiddify" ];
```

## Features

- **Automatic updates:** a GitHub Actions workflow checks for new Hiddify
  releases daily and opens a pull request with the new version and hash.
- **AppImage packaging:** uses Nix's `appimageTools` to run the upstream
  AppImage in an FHS environment.
- **Desktop integration:** installs a desktop entry and icon.
- **Platform:** `x86_64-linux` only, because upstream ships an x86_64 AppImage.

## Known limitations

- Plain proxy and system proxy modes work. **TUN mode is untested** and may not
  work inside the sandboxed wrapper because it needs elevated network
  privileges.
- The tray icon needs AppIndicator support from your desktop environment.

## Development

```sh
# Build the package
nix build .#hiddify

# Run without installing
nix run
```

## Automated Maintenance

The update workflow (`.github/workflows/update.yml`):

- Checks the latest upstream release daily
- Rewrites `version` and `hash` in `hiddify.nix`
- Builds the package to catch changes in the AppImage layout
- Opens a pull request if the build succeeds

## License

This repository contains **only Nix expressions**, which are licensed under the
[MIT License](LICENSE). That license covers the packaging files only.

This repository does **not** contain or redistribute any Hiddify code or
binaries. The upstream AppImage is downloaded from the official
[Hiddify releases](https://github.com/hiddify/hiddify-app/releases) at build
time.

Hiddify itself is licensed under the **Hiddify Extended GPLv3**, which adds
conditions to GPLv3, including non-commercial use only. For that reason the
package is marked as unfree. Read the
[upstream license](https://github.com/hiddify/hiddify-app/blob/main/LICENSE.md)
before using it. The flake's own `packages` output allows only `hiddify` as
unfree, so you don't need to enable `allowUnfree` globally to use it.

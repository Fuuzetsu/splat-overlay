{
  description = "splat";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "22.11";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    pip2nix = {
      url = "github:nix-community/pip2nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    splat = {
      url = "github:ethteck/splat";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , flake-compat
    , splat
    , pip2nix
    }:
    let
      outputs = flake-utils.lib.eachDefaultSystem
        (system:
          let
            splat = { writeShellScriptBin, callPackage, python3, lib }:
              let
                packageOverrides = callPackage ./python-packages.nix { };
                python = python3.override { inherit packageOverrides; };
                dependencyNames = lib.attrsets.attrNames (packageOverrides null null);
                splatPython = python.withPackages (ps: builtins.map (n: ps."${n}") dependencyNames);
              in
              writeShellScriptBin "split.py" ''
                ${splatPython}/bin/python ${inputs.splat}/split.py "$@"
              '';
            pkgs = import nixpkgs {
              inherit system;
              overlays = [
              ];
            };

            # Update script for this repo.
            #
            # I thought I was supposed to be able to do
            # inputs.pip2nix.defaultPackages.${system} and get pip2nix via flake but
            # it's crying about something I don't understand so we're doing this weird
            # thing...

            update-splat = pkgs.writeShellScriptBin "update-splat" ''
              ${pkgs.nix}/bin/nix flake lock --update-input splat \
                  --extra-experimental-features nix-command \
                  --extra-experimental-features flakes
              nix run \
                  --extra-experimental-features nix-command \
                  --extra-experimental-features flakes \
                  ${inputs.pip2nix}# -- \
                  generate -r ${inputs.splat}/requirements.txt
            '';
          in
          rec
          {
            legacyPackages = { };

            packages = flake-utils.lib.flattenTree
              {
                splat = pkgs.callPackage splat { };
                inherit update-splat;
              };
            checks = {
              splat-builds = packages.splat;
            };
          });
    in
    outputs //
    {
      overlays.default = final: _prev: {
        splat = outputs.packages.${final.system}.splat;
      };
    };




}

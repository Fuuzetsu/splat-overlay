{
  description = "splat";
  inputs = {
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs = {
      type = "github";
      owner = "NixOS";
      repo = "nixpkgs";
      ref = "nixos-26.05";
    };
    flake-compat = {
      url = "github:edolstra/flake-compat";
      flake = false;
    };
    pyproject-nix = {
      url = "github:pyproject-nix/pyproject.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    splat = {
      url = "github:ethteck/splat";
      flake = false;
    };
    # splat dependencies that are not packaged in nixpkgs; we build them from
    # source and track them alongside splat itself.
    spimdisasm = {
      url = "github:Decompollaborate/spimdisasm";
      flake = false;
    };
    rabbitizer = {
      url = "github:Decompollaborate/rabbitizer";
      flake = false;
    };
    crunch64 = {
      url = "github:decompals/crunch64";
      flake = false;
    };
    pygfxd = {
      url = "github:Thar0/pygfxd";
      flake = false;
    };
    n64img = {
      url = "github:decompals/n64img";
      flake = false;
    };
    pylibyaml = {
      url = "github:philsphicas/pylibyaml";
      flake = false;
    };
  };

  outputs =
    inputs@{ self
    , nixpkgs
    , flake-utils
    , flake-compat
    , pyproject-nix
    , splat
    , spimdisasm
    , rabbitizer
    , crunch64
    , pygfxd
    , n64img
    , pylibyaml
    }:
    let
      outputs = flake-utils.lib.eachDefaultSystem
        (system:
          let
            pkgs = import nixpkgs {
              inherit system;
            };

            # For inputs whose version lives in a PEP 621 pyproject.toml.
            projectVersion = pyprojectFile:
              (builtins.fromTOML (builtins.readFile pyprojectFile)).project.version;

            python = pkgs.python3.override {
              packageOverrides = self: _super: {
                rabbitizer = self.buildPythonPackage {
                  pname = "rabbitizer";
                  version = projectVersion "${inputs.rabbitizer}/pyproject.toml";
                  pyproject = true;
                  src = inputs.rabbitizer;
                  build-system = [ self.setuptools self.wheel ];
                };

                spimdisasm = self.buildPythonPackage {
                  pname = "spimdisasm";
                  version = projectVersion "${inputs.spimdisasm}/pyproject.toml";
                  pyproject = true;
                  src = inputs.spimdisasm;
                  build-system = [ self.setuptools self.wheel ];
                  # Upstream lists twine (a release tool) in build-system
                  # requires; skip the check instead of pulling it in.
                  pypaBuildFlags = [ "--skip-dependency-check" ];
                  dependencies = [ self.rabbitizer ];
                };

                # Rust package built with maturin; the python project lives in
                # lib/. importCargoLock needs no vendor hash, so upstream
                # updates don't invalidate anything.
                crunch64 = self.buildPythonPackage {
                  pname = "crunch64";
                  version = projectVersion "${inputs.crunch64}/lib/pyproject.toml";
                  pyproject = true;
                  src = inputs.crunch64;
                  buildAndTestSubdir = "lib";
                  cargoDeps = pkgs.rustPlatform.importCargoLock {
                    lockFile = "${inputs.crunch64}/Cargo.lock";
                  };
                  nativeBuildInputs = [
                    pkgs.rustPlatform.cargoSetupHook
                    pkgs.rustPlatform.maturinBuildHook
                  ];
                };

                # The versions below are only the derivation labels; the built
                # packages take their real metadata from the sources. These
                # projects change very rarely.
                pygfxd = self.buildPythonPackage {
                  pname = "pygfxd";
                  version = "1.0.5";
                  pyproject = true;
                  src = inputs.pygfxd;
                  build-system = [ self.setuptools self.wheel ];
                };

                n64img = self.buildPythonPackage {
                  pname = "n64img";
                  version = "0.3.3";
                  pyproject = true;
                  src = inputs.n64img;
                  build-system = [ self.setuptools self.wheel ];
                  dependencies = [ self.pypng ];
                };

                pylibyaml = self.buildPythonPackage {
                  pname = "pylibyaml";
                  version = "0.1.0";
                  pyproject = true;
                  src = inputs.pylibyaml;
                  build-system = [ self.setuptools self.wheel ];
                };
              };
            };

            # The python application itself. Exposed as `splat-python` for
            # consumers that genuinely want the library on their PYTHONPATH.
            splat-python =
              let
                # splat's requirements.txt lists the core dependencies plus
                # the mips extras; pyproject.nix parses it at eval time and
                # resolves the names from the python package set, so
                # dependency changes upstream are picked up automatically.
                deps = pyproject-nix.lib.project.loadRequirementsTxt {
                  requirements = "${inputs.splat}/requirements.txt";
                };
              in
              python.pkgs.buildPythonApplication {
                pname = "splat64";
                version = projectVersion "${inputs.splat}/pyproject.toml";
                pyproject = true;
                src = inputs.splat;
                build-system = [ python.pkgs.hatchling ];
                dependencies =
                  (deps.renderers.withPackages { inherit python; }) python.pkgs;
                # splat pins its core dependencies exactly (==), which the
                # versions in nixpkgs won't always match; the splat-runs
                # check below catches real incompatibilities.
                pythonRelaxDeps = true;
                pythonImportsCheck = [ "splat" ];
              };

            # What consumers actually get: the executables, and nothing else.
            # Symlinking just $out/bin gives a derivation with no python setup
            # hooks and no propagated python deps, so nothing leaks onto
            # PYTHONPATH in devShells that include it (which would hijack
            # unrelated tools' vendored copies of these libraries). The
            # scripts are already wrapped with their own PYTHONPATH.
            splat =
              let
                # Also keep the old split.py entry point around; it is what
                # this overlay historically exposed.
                split-py = pkgs.writeShellScriptBin "split.py" ''
                  exec ${splat-python}/bin/splat split "$@"
                '';
              in
              pkgs.runCommandLocal "splat-${splat-python.version}" { } ''
                mkdir -p "$out/bin"
                for f in ${splat-python}/bin/* ${split-py}/bin/*; do
                  ln -s "$f" "$out/bin/$(basename "$f")"
                done
              '';

            # Update script for this repo.
            update-splat = pkgs.writeShellScriptBin "update-splat" ''
              ${pkgs.nix}/bin/nix flake update \
                  splat spimdisasm rabbitizer crunch64 pygfxd n64img pylibyaml \
                  --extra-experimental-features nix-command \
                  --extra-experimental-features flakes
            '';
          in
          rec
          {
            legacyPackages = { };

            packages = flake-utils.lib.flattenTree
              {
                inherit splat splat-python update-splat;
              };
            checks = {
              # Actually run splat so updates that break it (new dependencies,
              # python incompatibilities, ...) fail the check.
              splat-runs = pkgs.runCommand "splat-runs" { } ''
                ${packages.splat}/bin/splat --help > $out
              '';

              # The exposed package must not leak its library onto PYTHONPATH:
              # doing so hijacks other tools' vendored copies (see the note on
              # the `splat` derivation). A devShell that includes it must come
              # out with an empty PYTHONPATH.
              splat-does-not-leak-pythonpath =
                pkgs.runCommand "splat-does-not-leak-pythonpath"
                  { nativeBuildInputs = [ packages.splat ]; } ''
                  if [ -n "''${PYTHONPATH:-}" ]; then
                    echo "splat leaked PYTHONPATH=$PYTHONPATH" >&2
                    exit 1
                  fi
                  splat --help > /dev/null
                  touch "$out"
                '';
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

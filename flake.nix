{
  description = "TODO!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs@{ flake-parts, nixpkgs, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      systems =
        [ "x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin" ];

      perSystem = { self, config, self', inputs', pkgs, system, lib, ... }: {
        # define the packages provided by this flake
        packages = let
          fs = lib.fileset;
          # nix source files (*.nix)
          nixFs = fs.fileFilter (file: file.hasExt == "nix") ./.;
          # rust source files
          rustFs = fs.unions [
            # Cargo.*
            (fs.fileFilter (file: lib.hasPrefix "Cargo" file.name) ./.)
            # *.rs
            (fs.fileFilter (file: file.hasExt "rs") ./.)
            # additional files
            ./.cargo
          ];
          # nvim source files
          # all that are not nix, nor rust, nor other ignored files
          nvimFs = fs.difference ./. (fs.unions [ nixFs rustFs ]);
          version = "0.1.0";
        in {
          your-plugin-lib = pkgs.rustPlatform.buildRustPackage {
            pname = "your-plugin-lib";
            inherit version;
            src = fs.toSource {
              root = ./.;
              fileset = rustFs;
            };
            cargoLock = { lockFile = ./Cargo.lock; };
          };

          your-plugin = pkgs.vimUtils.buildVimPlugin {
            pname = "your-plugin";
            inherit version;
            src = fs.toSource {
              root = ./.;
              fileset = nvimFs;
            };
            preInstall = ''
              mkdir -p target/release
              ln -s ${self'.packages.your-plugin-lib}/lib/libyour_plugin.* target/release/
            '';
          };

          default = self'.packages.your-plugin;
        };

        # builds the native module of the plugin
        apps.build-plugin = {
          type = "app";
          program = let
            buildScript = pkgs.writeShellApplication {
              name = "build-plugin";
              runtimeInputs = with pkgs; [ cargo gcc ];
              text = ''
                export LIBRARY_PATH="${lib.makeLibraryPath [ pkgs.libiconv ]}";
                cargo build --release
              '';
            };
          in (lib.getExe buildScript);
        };

        # define the default dev environment
        devShells.default = pkgs.mkShell {
          name = "your-plugin";
          inputsFrom = [
            self'.packages.your-plugin-lib
            self'.packages.your-plugin
            self'.apps.build-plugin
          ];
          packages = with pkgs; [ rust-analyzer ];
        };

        formatter = pkgs.nixfmt-classic;
      };
    };

  nixConfig = {
    extra-substituters = [ "https://nix-community.cachix.org" ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs"
    ];
  };
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ nixpkgs, flake-parts, ... }:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = nixpkgs.lib.systems.flakeExposed;
      perSystem = {
        lib,
        pkgs,
        system,
        config,
        ...
      }: 
			let
				toolchain = pkgs.rust-bin.stable.latest.default.override {
          extensions = ["rust-src"];
          targets = ["x86_64-unknown-linux-gnu"];
        };
				manifest = (pkgs.lib.importTOML ./rustdesk/Cargo.toml).package;
			in
			{
        _module.args.pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (import inputs.rust-overlay)
          ];
        };

        devShells.default = pkgs.mkShell
        {
          nativeBuildInputs = with pkgs; [
            toolchain
						pkg-config
          ];
        };

				packages.default = (pkgs.makeRustPlatform {
            rustc = toolchain;
            cargo = toolchain;
          }).buildRustPackage {
						pname = manifest.name;
						version = manifest.version;
						
						src = ./.;

						useFetchCargoVendor = true;
						cargoLock = {
							lockFile = ./Cargo.lock;
						};
					};
				};
      };
}

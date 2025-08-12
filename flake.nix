{
  description = "Rust development environment";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs =
    {
      nixpkgs,
      rust-overlay,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        overlays = [ (import rust-overlay) ];
        pkgs = import nixpkgs {
          inherit system overlays;
        };
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            rust-bin.stable.latest.default
            rust-analyzer
            cargo-watch
            cargo-edit
          ];

          # shellHook
          shellHook = ''
            echo "🦀 Rust development environment activated!"
            echo "Rust version: $(rustc --version)"
            echo "Cargo version: $(cargo --version)"

            export RUST_BACKTRACE=1
            export PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
          '';
        };
      }
    );
}

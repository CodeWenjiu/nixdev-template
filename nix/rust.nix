{ pkgs }:

pkgs.mkShell {
  name = "rust-dev-shell";

  buildInputs = with pkgs; [
    rust-bin.stable.latest.default
    rust-analyzer
    cargo-watch
    cargo-edit
  ];

  shellHook = ''
    echo "🦀 Rust development environment activated!"
    echo "Rust version: $(rustc --version)"
    echo "Cargo version: $(cargo --version)"
    export RUST_BACKTRACE=1
  '';
}

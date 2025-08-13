{
  description = "A modular development environment flake";

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

        show-version = false;

        # --- 1. Configuration ---
        # Add the names of the shells you want to activate by default.
        # These names must correspond to the attributes in `shells` below.
        enabledEnvironments = [
          "rust"
          "c_cpp"
          # "nodejs"
        ];

        # --- 2. Import modular shell configurations ---
        # Each file should return a derivation from `pkgs.mkShell`.
        shells = {
          rust = import ./nix/rust.nix {
            inherit show-version;
            inherit pkgs;
          };
          c_cpp = import ./nix/c_cpp.nix {
            inherit show-version;
            inherit pkgs;
          };
          nodejs = import ./nix/nodejs.nix {
            inherit show-version;
            inherit pkgs;
          };
        };

        # --- 3. Logic to merge enabled environments ---
        # Get the shell configurations that are enabled
        enabledShells = pkgs.lib.attrsets.mapAttrsToList (name: value: value) (
          pkgs.lib.attrsets.filterAttrs (name: value: pkgs.lib.lists.elem name enabledEnvironments) shells
        );

        # Merge `buildInputs` from all enabled shells
        mergedBuildInputs = pkgs.lib.lists.flatten (map (shell: shell.buildInputs or [ ]) enabledShells);

        # Merge `shellHook` from all enabled shells
        mergedShellHook = pkgs.lib.strings.concatStringsSep "\n\n" (
          map (shell: shell.shellHook or "") enabledShells
        );

      in
      {
        # --- 4. Define the final development shells ---
        devShells =
          # The default shell combines all `enabledEnvironments`.
          {
            default = pkgs.mkShell {
              name = "combined-dev-shell";
              buildInputs = mergedBuildInputs;
              shellHook = ''
                echo "--- Basic Nix-DirEnv Development Environment ---"
                ${mergedShellHook}
                echo "----------------------------------------"
                export PROJECT_ROOT=$(git rev-parse --show-toplevel 2>/dev/null || pwd)
              '';
            };
          }
          # Expose each individual language shell as well.
          # You can access them with `nix develop .#rust`, `nix develop .#nodejs`, etc.
          // shells;
      }
    );
}

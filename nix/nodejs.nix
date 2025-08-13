{
  pkgs,
  show-version ? true,
}:

pkgs.mkShell {
  name = "nodejs-dev-shell";

  buildInputs = with pkgs; [
    nodejs_20 # Or specify another version like nodejs_18
    yarn
  ];

  shellHook = ''
    echo "👋 Node.js development environment activated!"
  ''
  + pkgs.lib.optionalString show-version ''
    echo "Node version: $(node --version)"
    echo "NPM version: $(npm --version)"
  '';
}

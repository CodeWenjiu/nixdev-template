{
  pkgs,
  show-version ? true,
}:

pkgs.mkShell {
  name = "c-cpp-dev-shell";

  buildInputs = with pkgs; [
    xmake

    clang
    clang-tools
    lldb
    pkg-config
  ];

  shellHook = ''
    echo "🔧 C/C++ (xmake) development environment activated!"
  ''
  + pkgs.lib.optionalString show-version ''
    echo "GCC version: $(gcc --version | head -n 1)"
    echo "xmake version: $(xmake --version | head -n 1)"
  '';
}

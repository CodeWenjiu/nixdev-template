{
  pkgs,
  show-version ? true,
}:

pkgs.mkShell {
  name = "c-cpp-dev-shell";

  buildInputs = with pkgs; [
    xmake

    llvmPackages_21.clang
    llvmPackages_21.clang-tools
    llvmPackages_21.lldb
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

{
  pkgs ? import <nixpkgs> { },
}:
pkgs.mkShell {
  packages = with pkgs; [
    lua5_1
    stylua
    lua-language-server
    luarocks
    haskellPackages.hoogle
  ];
}

{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };
  outputs = {nixpkgs, ...}: let
    inherit (nixpkgs) lib;
    withSystem = f:
      lib.foldr lib.recursiveUpdate {}
      (map f ["x86_64-linux" "x86_64-darwin" "aarch64-linux" "aarch64-darwin"]);
  in
    withSystem (
      system: let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in {
        devShells.${system}.default =
          pkgs.mkShell
          {
            packages = with pkgs; [
              typst
              tinymist
              texliveFull
              diff-pdf
              poppler-utils
              imagemagick
            ];
          };
      }
    );
}

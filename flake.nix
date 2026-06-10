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
        fonts = with pkgs; [
          tex-gyre.heros
          liberation_ttf
          # Sans-serif text fonts (used as the upright text family alongside
          # the sans math fonts below).
          fira # Fira Sans (Erik Spiekermann / Carrois Type Design)
          # Sans-serif math fonts with OpenType MATH table.
          fira-math
          noto-fonts # bundles Noto Sans Math (Google)
          # Serif math fonts with OpenType MATH table.
          tex-gyre-math.termes # Times-like (TeX Gyre Termes Math)
          tex-gyre-math.pagella # Palatino-like (TeX Gyre Pagella Math)
          newcomputermodern # New Computer Modern Math
        ];
        # texlivePackages put fonts under `${out.tex}/fonts/opentype/...`
        # rather than `${out}/share/fonts`, so they need their own path entry.
        texliveFonts = with pkgs.texlivePackages; [
          lete-sans-math # Lete Sans Math (Lato-based, v0.61)
          gfsneohellenicmath # GFS Neohellenic Math
          erewhon-math # Erewhon Math (Utopia-derived)
        ];
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
            TYPST_FONT_PATHS = lib.concatStringsSep ":" (
              map (f: "${f}/share/fonts") fonts
              ++ map (f: "${f.tex}/fonts") texliveFonts
            );
          };
      }
    );
}

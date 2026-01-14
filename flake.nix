{
  inputs.nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

  outputs = {
    self,
    nixpkgs,
  }: let
    allSystems = ["x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin"];
    forAllSystems = f:
      nixpkgs.lib.genAttrs allSystems (system:
        f {
          pkgs = nixpkgs.legacyPackages.${system};
        });
    font = pkgs: pkgs.liberation_ttf;
    mdToPDF = pkgs:
      pkgs.writeShellScriptBin "mdtopdf" ''
        if [[ -z "$1" || "''${1: -3}" != '.md' ]]; then
          echo "Markdown input file required!"
          exit 1
        fi

        pandoc "$1" -o "$(basename $1 .md).pdf" \
          --from markdown \
          --to pdf \
          --standalone \
          --pdf-engine=typst \
          --pdf-engine-opt="--ignore-system-fonts" \
          --pdf-engine-opt="--ignore-embedded-fonts" \
          --pdf-engine-opt="--font-path=${font pkgs}/share/fonts" \
          --pdf-engine-opt="--root=/" \
          -V template=${./template.typ} \
          -V mainfont='Liberation Serif' \
          --citeproc
      '';
  in {
    devShells = forAllSystems ({pkgs}: {
      default = pkgs.mkShell {
        packages = with pkgs; [
          d2
          pandoc
          pandoc-ext-diagram

          typst
          tinymist
          typstyle

          (font pkgs)
          (mdToPDF pkgs)
        ];
        DIAGRAM_LUA = pkgs.pandoc-ext-diagram;
      };
    });

    packages = forAllSystems ({pkgs}: {
      default = mdToPDF pkgs;
      # default = derivation {
      #   # inherit system;
      #   name = "mdtopdf";
      #   system = pkgs.system;
      #   builder = "${pkgs.pandoc}/bin/pandoc";
      #   args = [
      #   ];
      # };
    });
  };
}

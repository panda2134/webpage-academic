{
  description = "Jiangyi's Academic Webpage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    theme-papermod = {
      url = "github:adityatelange/hugo-PaperMod/9ea3bb0e1f3aa06ed7715e73b5fabb36323f7267"; 
      flake = false;
    };
  };

  outputs = { self, nixpkgs, theme-papermod, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      nativeBuildInputs = [ pkgs.hugo pkgs.git pkgs.go ];
    in
    {
      devShells.default = pkgs.mkShell {
        packages = nativeBuildInputs;
      };
        
      packages.default = pkgs.stdenv.mkDerivation {
        pname = "webpage-academic";
        version = "1.0.0";
        inherit nativeBuildInputs;
        src = ./.;

        buildPhase = ''
          mkdir -p $out/var/www/
          ${pkgs.rsync}/bin/rsync -rl ${theme-papermod} themes/PaperMod/
          hugo --destination $out/var/www/
        '';
      };
    }
    )
  ;
}

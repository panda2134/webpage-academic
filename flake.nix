{
  description = "Jiangyi's Academic Webpage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }: 
    flake-utils.lib.eachDefaultSystem (system:
    let
      pkgs = nixpkgs.legacyPackages.${system};
      papermod-refs = {
        owner = "adityatelange";
        repo = "hugo-PaperMod";
        rev = "9ea3bb0e1f3aa06ed7715e73b5fabb36323f7267";
        hash = "sha256-Ko0ZwQlYlPg6dq0L8LFdA2Mw9q/Gr9PfmpTmuLloh8E=";
      };
      theme-papermod = (pkgs.fetchFromGitHub papermod-refs);
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
          mkdir -p themes
          ${pkgs.rsync}/bin/rsync -rl ${theme-papermod + /.} themes/PaperMod/ 
          hugo --destination $out/var/www/
        ''; # + /. is crucial in converting the path

      };
    }
    )
  ;
}

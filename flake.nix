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
          hugo --destination $out/var/www/
        '';
      };
    }
    )
  ;
}

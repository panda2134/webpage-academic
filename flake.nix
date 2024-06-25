{
  description = "Jiangyi's Academic Webpage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
    src = {
      url = "git+file:.?submodules=1";
      flake = false;  # not including this results in infinite recursion
    };
  };

  outputs = { self, src, nixpkgs, flake-utils }: 
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
        inherit src nativeBuildInputs;

        buildPhase = ''
          mkdir -p $out/var/www/
          hugo --destination $out/var/www/
        '';
      };
    }
    )
  ;
}

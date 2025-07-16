{
  description = "Tony's Dissertation";
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
  outputs = { self, nixpkgs }:
    let
      system     = "x86_64-linux";
      pkgs       = nixpkgs.legacyPackages.${system};
      latex-pkgs = pkgs.texlive.combined.scheme-full; # AAAAAAALL OF IT
    in rec {
      # nix develop
      devShells.${system}.default =
        pkgs.mkShell {
          buildInputs = [ latex-pkgs ];
        };
    };
}

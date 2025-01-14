	{
	  inputs = {
      nixpkgs.url = "github:NixOS/nixpkgs";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlay = (self: super: {
            python = super.python311;
            poetry = super.poetry;
            pip = super.python311Packages.pip;
            cookiecutter = super.python311Packages.cookiecutter;
          });
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              python311
              poetry
              pyenv
              python311Packages.pip
              python311Packages.cookiecutter
            ];
          };
        }
      );
}
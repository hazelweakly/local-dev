	{
	  inputs = {
      # Moderately annoying that we have to do this as Python 3.12 is broken on main
      nixpkgs.url = "github:NixOS/nixpkgs/nixos-23.11";
      flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem
      (system:
        let
          overlay = (self: super: {
            python = super.python312;
            poetry = super.poetry;
          });
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              python312
              poetry
            ];
          };
        }
      );
}
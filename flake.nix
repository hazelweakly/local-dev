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
            just = super.just;
            xcode-install = super.xcode-install;
            direnv = super.direnv;
            docker = super.docker;
            ripgrep = super.ripgrep;
            python = super.python3;
            docker-credential-helpers = super.docker-credential-helpers;
            colima = super.colima;
            node = super.nodejs_20;
            pnpm = super.nodejs_20.pkgs.pnpm;
            devcontainers = super.nodejs_20.pkgs.''devcontainers/cli'';
          });
          pkgs = import nixpkgs {
            inherit system;
          };
        in
        with pkgs;
        {
          devShells.default = mkShell {
            buildInputs = [
              just
              xcode-install
              direnv
              ripgrep
              python3
              nodejs_20
              docker
              docker-compose
              nodejs_20.pkgs.pnpm
              nodejs_20.pkgs.''devcontainers/cli''
            ];
            shellHook = ''
            if [[ ! -e local-dev ]]; then
              git clone git@github.com:scorbettUM/local-dev.git
              echo 'eval "$(direnv hook zsh)"' | sudo tee -a $HOME/.zshrc > /dev/null
              cp local-dev/justfile $HOME/justfile
              rm -rf local-dev
            fi
            '';
          };
        }
      );
}
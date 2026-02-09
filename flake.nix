{
  description = "A good project for my arabic learning";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };
  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
      ...
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };
      in
      rec {
        devShells.default = import ./shell.nix { inherit pkgs; };
        packages.default = pkgs.python313Packages.buildPythonApplication {
          pname = "translate-arabic-on-screen";
          version = "1.0";
          src = ./.;
          pyproject = true;

          propagatedBuildInputs = devShells.default.buildInputs or [ ] ++ devShells.default.packages or [ ];
          nativeBuildInputs = [
            pkgs.python313Packages.setuptools
            pkgs.python313Packages.wheel
          ];

          # postInstall = ''
          #   mkdir -p $out/bin
          #   # This copies your main script and makes it the 'executable'
          #   cp main.py $out/bin/translate-arabic-on-screen
          #   chmod +x $out/bin/translate-arabic-on-screen
          # '';
          # dontUnpack = true;
        };
      }
    );
}

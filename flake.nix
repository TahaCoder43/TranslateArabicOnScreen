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
          src = "./";
          pyproject = false;
          dependencies = devShells.default.buildInputs or [ ] ++ devShells.default.packages or [ ];
          dontUnpack = true;
        };
      }
    );
}

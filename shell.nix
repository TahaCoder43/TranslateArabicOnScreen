{ pkgs, ... }:
with pkgs;
mkShell {
  venvDir = "./.venv";

  packages = [
    python313Packages.python
    python313Packages.nuitka
    python313Packages.pillow
    python313Packages.torch
    python313Packages.transformers
    python313Packages.levenshtein
    python313Packages.nltk
    grim
  ];

  shellHook = ''
    set -o vi
  '';
}

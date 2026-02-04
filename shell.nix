{ pkgs, ... }:
with pkgs;
mkShell {
  venvDir = "./.venv";
  buildInputs = [
    libGL
    glib
  ];

  LD_LIBRARY_PATH = "${libGL.out}/lib:${glib.out}/lib";

  packages = [
    # python313Packages.numpy
    # python313Packages.venvShellHook
    python313Packages.python
    python313Packages.pillow
    python313Packages.easyocr
    grim
  ];

  # postVenvCreation = ''
  #   pip install paddlepaddle==3.2.3 -i https://www.paddlepaddle.org.cn/packages/stable/cpu/
  #   pip install paddleocr
  # '';

  shellHook = ''
    set -o vi
  '';
}

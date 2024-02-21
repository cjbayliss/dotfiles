{pkgs, ...}: {
  home.packages = with pkgs; [
    # langs
    chicken
    gcc
    ghc
    nodejs_20
    php
    sbcl

    # langs-extras
    fnlfmt
    shellcheck
    stylua
  ];
}

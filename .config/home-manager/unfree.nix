{
  lib,
  pkgs,
  ...
}: {
  nixpkgs.config.allowUnfreePredicate = pkg:
    builtins.elem (lib.getName pkg) [
      "discord"
      "intelephense"
    ];

  home.packages = with pkgs; [
    nodePackages.intelephense
    discord
  ];
}

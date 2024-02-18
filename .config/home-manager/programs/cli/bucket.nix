{pkgs, ...}: {
  home.packages = with pkgs; [
    jq
    nixpkgs-review
    podman-compose
    procs # ps replacement
    xh # http request tool. has --download and --continue
  ];
}

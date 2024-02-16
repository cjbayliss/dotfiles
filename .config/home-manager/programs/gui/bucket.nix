{pkgs, ...}: {
  home.packages = with pkgs; [
    (ungoogled-chromium.override {commandLineArgs = ''--js-flags="--jitless --noexpose_wasm" --no-pings '';})
    krita
    lutris-free
  ];
}

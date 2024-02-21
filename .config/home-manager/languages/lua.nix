{pkgs, ...}: {
  home.packages = with pkgs; [
    (lua.withPackages (luaPackages:
      with luaPackages; [
        cjson
        fennel
        luasec
        luasocket
      ]))
  ];
}

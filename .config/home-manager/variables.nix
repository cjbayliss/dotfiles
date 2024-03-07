{config, ...}: {
  home.file."${config.xdg.configHome}/npm/config".text = ''
    prefix=''\${XDG_DATA_HOME}/npm
    init-module=''\${XDG_CONFIG_HOME}/npm/config/npm-init.js
  '';

  home.sessionVariables = {
    PAGER = "cat"; # NOTE: setting no pager breaks bad software
    MANPAGER = "less --mouse --wheel-lines 3";
    MANWIDTH = 72;

    EMAIL = "cjbdev@icloud.com";
    NAME = "Christopher Bayliss";

    CUDA_CACHE_PATH = "${config.xdg.cacheHome}/nv";
    MYPY_CACHE_DIR = "${config.xdg.cacheHome}/mypy";

    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/config";
    NPM_CONFIG_CACHE = "${config.xdg.cacheHome}/npm";
    NPM_CONFIG_TMP = "$XDG_RUNTIME_DIR/npm";

    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
  };
}

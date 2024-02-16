{pkgs, ...}: {
  programs.mpv = {
    enable = true;
    package = pkgs.mpv.override {scripts = [pkgs.mpvScripts.mpris];};

    bindings = {
      "q" = "stop";
      "Ctrl+w" = "ignore";
      "Ctrl+q" = "ignore";
    };

    config = {
      script-opts = "ytdl_hook-ytdl_path=yt-dlp";
      ytdl-format = "[format_id*=adaptive_hls-audio-jaJP][height<=?480]/bestvideo[height<=?480]+bestaudio/best";
      slang = "eng,en,enUS";
      cache = "auto";
      embeddedfonts = "no";
    };
  };
}

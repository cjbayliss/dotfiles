{...}: {
  programs.yt-dlp = {
    enable = true;
    extraConfig = ''
      # this means 'keep downloading the rest of the playlist even is one item on the
      # list fails'
      --ignore-errors

      # select the optimal format for my desktop
      -f [format_id*=adaptive_hls-audio-jaJP][height<=?1080]/bestvideo[ext=webm][height<=?1080]+bestaudio[ext=webm]/best
    '';
  };
}

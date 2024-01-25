Config
  { font =
      "Iosevka, IPAGothic Regular 11.5, Baekmuk Gulim Regular 11.5, Noto Color Emoji Regular 10, Regular 11.5"
  , dpi = 108
  , bgColor = "#000000"
  , fgColor = "#ffffff"
  , position = TopH 24
  , commands =
      [ Run
          ComX
          "nu"
          [ "-c"
          , "ip -j a | from json | where operstate == UP | get addr_info | first | get local | to text"
          ]
          "DOWN"
          "arp"
          10
      , Run
          Com
          "nu"
          ["-c", "pactl get-sink-volume @DEFAULT_SINK@ | split column -r '\\s+' | get column5 | to text"]
          "volume"
          10
      , Run
          Com
          "nu"
          [ "-c"
          , "if (pactl get-sink-mute @DEFAULT_SINK@ | split column -r '\\s+' | get column2 | to text) == yes { print 'AUDIO OFF' }"
          ]
          "audioStatus"
          10
      , Run
          Com
          "nu"
          [ "-c" -- r1r07e is the "geohash" for Bright
                 -- See https://github.com/bremor/bureau_of_meteorology/blob/9b20d1d/api%20doc/API.mdon
          , "(http get https://api.weather.bom.gov.au/v1/locations/r1r07e/observations | from json).data.temp | append °C | str join"
          ]
          "temperature"
          9000
      , Run Memory ["-t", "<used>M/<total>M (<usedratio>%)"] 10
      , Run Com "head" ["-c4", "/proc/loadavg"] "loadavg" 10
      , Run Date "%0e %^a %H:%M" "date" 10
      , Run StdinReader
      ]
  , sepChar = "%"
  , alignSep = "}{"
  , template =
      " %StdinReader% }{ <fc=#ff8059>%audioStatus%</fc> %volume% <fc=#a8a8a8><</fc> <fc=#b0d6f5>%memory%</fc> <fc=#a8a8a8><</fc> <fc=#6ae4b9>%arp%</fc> <fc=#a8a8a8><</fc> %loadavg% <fc=#a8a8a8><</fc> <fc=#f8dec0>%temperature% %date%</fc> "
  }

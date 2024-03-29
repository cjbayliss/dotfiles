{pkgs, ...}: {
  programs.firefox = {
    enable = true;
    policies = {
      DefaultDownloadDirectory = "\${home}/downloads";
      Cookies = {
        Allow = [
          "https://amazon.com.au"
          "https://apple.com"
          "https://codeberg.org"
          "https://ebay.com.au"
          "https://github.com"
          "https://gitlab.com"
          "https://icloud.com"
          "https://macquarie.com.au"
          "https://music.apple.com"
          "https://openai.com"
          "https://selfwealth.com.au"
          "https://youtube.com"
        ];
        Behavior = "reject-tracker-and-partition-foreign";
      };
      DisableFeedbackCommands = true;
      DisableFirefoxAccounts = true;
      DisableFirefoxStudies = true;
      DisablePocket = true;
      DisableTelemetry = true;
      DNSOverHTTPS = {
        Enabled = true;
        Locked = true;
        ProviderURL = "https://dns.quad9.net/dns-query";
      };
      EnableTrackingProtection = {
        Value = true;
        Locked = true;
        Cryptomining = true;
        Fingerprinting = true;
      };
      EncryptedMediaExtensions = true;
      ExtensionSettings = {
        "uBlock0@raymondhill.net" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
          "installation_mode" = "force_installed";
        };
        "{446900e4-71c2-419f-a6a7-df9c091e268b}" = {
          "install_url" = "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi";
          "installation_mode" = "force_installed";
        };
      };
      FirefoxHome = {
        Search = false;
        TopSites = false;
        SponsoredTopSites = false;
        Highlights = false;
        Pocket = false;
        SponsoredPocket = false;
        Snippets = false;
        Locked = true;
      };
      NetworkPrediction = false;
      NoDefaultBookmarks = true;
      OfferToSaveLogins = false;
      OverrideFirstRunPage = "";
      PasswordManagerEnabled = false;
    };
    profiles.default = {
      name = "default";
      search = {
        default = "DuckDuckGo";
        force = true;
        engines = {
          "Nix Packages" = {
            urls = [
              {
                template = "https://search.nixos.org/packages";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["!np"];
          };

          "Nix Options" = {
            urls = [
              {
                template = "https://search.nixos.org/options";
                params = [
                  {
                    name = "channel";
                    value = "unstable";
                  }
                  {
                    name = "query";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
            definedAliases = ["!no"];
          };

          "Python Docs" = {
            urls = [
              {
                template = "https://docs.python.org/3/search.html";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://docs.python.org/3/_static/py.svg";
            definedAliases = ["!py"];
          };

          "Python Packages (pypi)" = {
            urls = [
              {
                template = "https://pypi.org/search/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            # use the python icon since the pypi icon has a different url
            # depending on the site build
            iconUpdateURL = "https://docs.python.org/3/_static/py.svg";
            definedAliases = ["!pp"];
          };

          "GitHub" = {
            urls = [
              {
                template = "https://github.com/search";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://github.githubassets.com/favicons/favicon.svg";
            definedAliases = ["!gh"];
          };

          "Debian Packages" = {
            urls = [
              {
                template = "https://packages.debian.org/search";
                params = [
                  {
                    name = "keywords";
                    value = "{searchTerms}";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://www.debian.org/favicon.ico";
            definedAliases = ["!dp"];
          };

          "Firefox Addons" = {
            urls = [
              {
                template = "https://addons.mozilla.org/en-US/firefox/search/";
                params = [
                  {
                    name = "q";
                    value = "{searchTerms}";
                  }
                  {
                    name = "type";
                    value = "extension";
                  }
                ];
              }
            ];
            iconUpdateURL = "https://addons.mozilla.org/favicon.ico";
            definedAliases = ["!fa"];
          };

          "Bing".metaData.alias = "!b";
          "DuckDuckGo".metaData.alias = "!d";
          "Google".metaData.alias = "!g";
          "Wikipedia (en)".metaData.alias = "!w";
          "eBay".metaData.alias = "!eb";
        };
      };

      settings = {
        # prefs:
        "accessibility.force_disabled" = 1;
        "browser.aboutConfig.showWarning" = false;
        "browser.compactmode.show" = true;
        "browser.display.use_document_fonts" = 0;
        "browser.preferences.moreFromMozilla" = false;
        "browser.search.region" = "AU";
        "browser.search.suggest.enabled" = false;
        "browser.shell.checkDefaultBrowser" = false;
        "browser.tabs.inTitlebar" = 0;
        "browser.tabs.warnOnClose" = false;
        "dom.battery.enabled" = false;
        "dom.event.contextmenu.enabled" = false;
        "dom.security.https_only_mode" = true;
        "dom.vibrator.enabled" = false;
        "extensions.getAddons.cache.enabled" = false;
        "extensions.getAddons.showPane" = false;
        "extensions.htmlaboutaddons.discover.enabled" = false;
        "extensions.htmlaboutaddons.recommendations.enabled" = false;
        "extensions.webextensions.restrictedDomains" = "";
        "fission.autostart" = true;
        "font.minimum-size.ar" = 17;
        "font.minimum-size.el" = 17;
        "font.minimum-size.he" = 17;
        "font.minimum-size.ja" = 17;
        "font.minimum-size.ko" = 17;
        "font.minimum-size.th" = 17;
        "font.minimum-size.x-armn" = 17;
        "font.minimum-size.x-beng" = 17;
        "font.minimum-size.x-cans" = 17;
        "font.minimum-size.x-cyrillic" = 17;
        "font.minimum-size.x-devanagari" = 17;
        "font.minimum-size.x-ethi" = 17;
        "font.minimum-size.x-geor" = 17;
        "font.minimum-size.x-gujr" = 17;
        "font.minimum-size.x-guru" = 17;
        "font.minimum-size.x-khmr" = 17;
        "font.minimum-size.x-knda" = 17;
        "font.minimum-size.x-math" = 17;
        "font.minimum-size.x-mlym" = 17;
        "font.minimum-size.x-orya" = 17;
        "font.minimum-size.x-sinh" = 17;
        "font.minimum-size.x-tamil" = 17;
        "font.minimum-size.x-telu" = 17;
        "font.minimum-size.x-tibt" = 17;
        "font.minimum-size.x-unicode" = 17;
        "font.minimum-size.x-western" = 17;
        "font.minimum-size.zh-CN" = 17;
        "font.minimum-size.zh-HK" = 17;
        "font.minimum-size.zh-TW" = 17;
        "font.name-list.emoji" = "Noto Color Emoji";
        "font.name.monospace.x-western" = "Iosevka Fixed";
        "font.name.sans-serif.x-western" = "Liberation Sans";
        "font.name.serif.x-western" = "Liberation Sans";
        "font.size.monospace.x-western" = 17;
        "font.size.variable.x-western" = 18;
        "identity.fxaccounts.enabled" = false;
        "javascript.options.asmjs" = false; # NOTE: breaks wasm
        "javascript.options.wasm" = false; # NOTE: breaks wasm
        "layout.css.scrollbar-width-thin.disabled" = true;
        "marionette.prefs.recommended" = false;
        "media.peerconnection.enabled" = false;
        "network.IDN_show_punycode" = true;
        "network.captive-portal-service.enabled" = false;
        "network.dns.disablePrefetch" = true;
        "network.predictor.enabled" = false;
        "network.prefetch-next" = false;
        "permissions.default.camera" = 2;
        "permissions.default.desktop-notification" = 2;
        "permissions.default.geo" = 2;
        "permissions.default.microphone" = 2;
        "permissions.default.xr" = 2;
        "privacy.resistFingerprinting.block_mozAddonManager" = true;
        "privacy.trackingprotection.enabled" = true;
        "security.insecure_connection_text.enabled" = true;
        "security.mixed_content.block_display_content" = true;
        "security.mixed_content.block_object_subrequest" = true;
        "security.ssl.require_safe_negotiation" = true;
        "security.ssl.treat_unsafe_negotiation_as_broken" = true;
        "signon.management.page.breach-alerts.enabled" = false;
        "signon.rememberSignons" = false;
        "ui.key.menuAccessKeyFocuses" = false;
        "ui.useOverlayScrollbars" = 0;

        # disable telemetry
        "app.normandy.enabled" = false;
        "app.shield.optoutstudies.enabled" = false;
        "beacon.enabled" = false;
        "browser.newtabpage.activity-stream.feeds.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry" = false;
        "browser.newtabpage.activity-stream.telemetry.structuredIngestion.endpoint" = "";
        "browser.ping-centre.telemetry" = false;
        "extensions.pocket.enabled" = false;
        "network.trr.confirmation_telemetry_enabled" = false;
        "toolkit.telemetry.archive.enabled" = false;
        "toolkit.telemetry.bhrPing.enabled" = false;
        "toolkit.telemetry.cachedClientID" = "";
        "toolkit.telemetry.firstShutdownPing.enabled" = false;
        "toolkit.telemetry.newProfilePing.enabled" = false;
        "toolkit.telemetry.reportingpolicy.firstRun" = false;
        "toolkit.telemetry.server" = "";
        "toolkit.telemetry.server_owner" = "";
        "toolkit.telemetry.shutdownPingSender.enabled" = false;
        "toolkit.telemetry.unified" = false;
        "toolkit.telemetry.updatePing.enabled" = false;

        # remove potential data exfiltration URLs
        "app.feedback.baseURL" = "";
        "app.normandy.api_url" = "";
        "app.normandy.shieldLearnMoreUrl" = "";
        "app.releaseNotesURL" = "";
        "app.releaseNotesURL.aboutDialog" = "";
        "app.releaseNotesURL.prompt" = "";
        "app.support.baseURL" = "";
        "app.update.url.details" = "";
        "app.update.url.manual" = "";
        "breakpad.reportURL" = "";
        "browser.contentblocking.report.cookie.url" = "";
        "browser.contentblocking.report.cryptominer.url" = "";
        "browser.contentblocking.report.endpoint_url" = "";
        "browser.contentblocking.report.fingerprinter.url" = "";
        "browser.contentblocking.report.lockwise.how_it_works.url" = "";
        "browser.contentblocking.report.manage_devices.url" = "";
        "browser.contentblocking.report.mobile-android.url" = "";
        "browser.contentblocking.report.mobile-ios.url" = "";
        "browser.contentblocking.report.monitor.home_page_url" = "";
        "browser.contentblocking.report.monitor.how_it_works.url" = "";
        "browser.contentblocking.report.monitor.preferences_url" = "";
        "browser.contentblocking.report.monitor.sign_in_url" = "";
        "browser.contentblocking.report.monitor.url" = "";
        "browser.contentblocking.report.proxy_extension.url" = "";
        "browser.contentblocking.report.social.url" = "";
        "browser.contentblocking.report.tracker.url" = "";
        "browser.contentblocking.report.vpn-android.url" = "";
        "browser.contentblocking.report.vpn-ios.url" = "";
        "browser.contentblocking.report.vpn-promo.url" = "";
        "browser.contentblocking.report.vpn.url" = "";
        "browser.contentblocking.reportBreakage.url" = "";
        "browser.dictionaries.download.url" = "";
        "browser.geolocation.warning.infoURL" = "";
        "browser.partnerlink.attributionURL" = "";
        "browser.privatebrowsing.vpnpromourl" = "";
        "browser.region.network.url" = "";
        "browser.safebrowsing.downloads.remote.url" = "";
        "browser.safebrowsing.provider.google.advisoryURL" = "";
        "browser.safebrowsing.provider.google.gethashURL" = "";
        "browser.safebrowsing.provider.google.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google.reportURL" = "";
        "browser.safebrowsing.provider.google.updateURL" = "";
        "browser.safebrowsing.provider.google4.advisoryURL" = "";
        "browser.safebrowsing.provider.google4.dataSharingURL" = "";
        "browser.safebrowsing.provider.google4.gethashURL" = "";
        "browser.safebrowsing.provider.google4.reportMalwareMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportPhishMistakeURL" = "";
        "browser.safebrowsing.provider.google4.reportURL" = "";
        "browser.safebrowsing.provider.google4.updateURL" = "";
        "browser.safebrowsing.provider.mozilla.gethashURL" = "";
        "browser.safebrowsing.provider.mozilla.updateURL" = "";
        "browser.safebrowsing.reportPhishURL" = "";
        "browser.search.searchEnginesURL" = "";
        "browser.search.separatePrivateDefault.urlbarResult.enabled" = false;
        "browser.uitour.url" = "";
        "browser.urlbar.merino.endpointURL" = "";
        "browser.urlbar.quicksuggest.scenario" = "history";
        "browser.urlbar.shortcuts.bookmarks" = false;
        "browser.urlbar.shortcuts.history" = false;
        "browser.urlbar.shortcuts.quickactions" = false;
        "browser.urlbar.shortcuts.tabs" = false;
        "browser.urlbar.suggest.calculator" = true;
        "browser.urlbar.unitConversion.enabled" = true;
        "browser.xr.warning.infoURL" = "";
        "captivedetect.canonicalURL" = "";
        "datareporting.healthreport.infoURL" = "";
        "datareporting.policy.firstRunURL" = "";
        "devtools.performance.recording.ui-base-url" = "";
        "devtools.remote.adb.extensionURL" = "";
        "extensions.abuseReport.amoDetailsURL" = "";
        "extensions.abuseReport.amoFormURL" = "";
        "extensions.abuseReport.url" = "";
        "extensions.blocklist.addonItemURL" = "";
        "extensions.blocklist.detailsURL" = "";
        "extensions.blocklist.itemURL" = "";
        "extensions.getAddons.browserMappings.url" = "";
        "extensions.getAddons.discovery.api_url" = "";
        "extensions.getAddons.get.url" = ""; # NOTE: you might not want to disable this URL
        "extensions.getAddons.langpacks.url" = "";
        "extensions.getAddons.link.url" = ""; # NOTE: you might not want to disable this URL
        "extensions.getAddons.search.browseURL" = "";
        "extensions.recommendations.privacyPolicyUrl" = "";
        "extensions.recommendations.themeRecommendationUrl" = "";
        # "extensions.systemAddon.update.url" = ""; # NOTE: you probably don't want to disable this URL
        # "extensions.update.background.url" = ""; # NOTE: you probably don't want to disable this URL
        # "extensions.update.url" = ""; # NOTE: you probably don't want to disable this URL
        "geo.provider.network.url" = "";
        "identity.fxaccounts.service.monitorLoginUrl" = "";
        "identity.sendtabpromo.url" = "";
        "lightweightThemes.getMoreURL" = "";
        "media.gmp-manager.url" = "";
        "network.connectivity-service.IPv4.url" = "";
        "network.connectivity-service.IPv6.url" = "";
        "network.trr_ui.skip_reason_learn_more_url" = "";
        "signon.firefoxRelay.base_url" = "";
        "signon.firefoxRelay.learn_more_url" = "";
        "signon.firefoxRelay.manage_url" = "";
        "signon.firefoxRelay.privacy_policy_url" = "";
        "signon.firefoxRelay.terms_of_service_url" = "";
        "signon.management.page.breachAlertUrl" = "";
        "toolkit.crashreporter.infoURL" = "";
        "toolkit.datacollection.infoURL" = "";
        "toolkit.shopping.ohttpConfigURL" = "";
        "toolkit.shopping.ohttpRelayURL" = "";
        "webchannel.allowObject.urlWhitelist" = "";
        "webextensions.storage.sync.serverURL" = "";

        # for normal tabs
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      };

      userChrome = ''
        :root {
          --tab-min-height: 37px !important;
        }

        :root[uidensity="compact"] {
          --tab-min-height: 31px !important;
        }

        :root[uidensity="touch"] {
          --tab-min-height: 41px !important;
        }

        .tab-background {
          border-radius: 0px 0px !important;
          margin-bottom: 0px !important;
          margin-top: 0px !important;
        }

        .tabbrowser-tab[visuallyselected][usercontextid] .tab-background {
          box-shadow: inset 0 -2px 0 var(--platform-color-accent-active) !important;
        }

        .tabbrowser-tab[visuallyselected]:not([usercontextid]) .tab-background {
          box-shadow: inset 0 2px 0 var(--platform-color-accent-active) !important;
        }

        #tabbrowser-tabs:not([secondarytext-unsupported]) .tab-label-container {
          height: var(--tab-min-height) !important;
        }

        #unified-extensions-button {
          opacity: 0%;
        }

        #navigator-toolbox:hover #unified-extensions-button {
          opacity: 100%;
        }

        #alltabs-button {
          opacity: 0%;
        }

        #navigator-toolbox:hover #alltabs-button {
          opacity: 100%;
        }

        #TabsToolbar #firefox-view-button[open] > .toolbarbutton-icon,
        .tab-background:is([selected], [multiselected]) {
          background-color: var(--toolbar-bgcolor) !important;
        }

        #TabsToolbar #firefox-view-button:hover:not([open]) > .toolbarbutton-icon,
        .tabbrowser-tab:hover
          > .tab-stack
          > .tab-background:not([selected], [multiselected]) {
          background-color: color-mix(in srgb, var(--toolbar-bgcolor) 60%, transparent) !important;
        }

        #TabsToolbar
          #firefox-view-button[open]:not(:focus-visible)
          > .toolbarbutton-icon:-moz-lwtheme,
        .tab-background[selected]:not([multiselected]):-moz-lwtheme {
          outline: unset !important;
        }
      '';
    };
  };

  home.sessionVariables = {
    MOZ_GTK_TITLEBAR_DECORATION = "system"; # proper theming
    MOZ_USE_XINPUT2 = "1";
  };
}

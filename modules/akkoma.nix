{ config, pkgs, lib, ... }: 
let
  patchedFrontend = pkgs.akkoma-fe.overrideAttrs (old: {
    postInstall = (old.postInstall or "") + ''
      cp ${pkgs.writeText "config.json" (builtins.toJSON {
        background = "https://www.kluge.cafe/assets/akkoma-bg.jpg";
        collapseMessageWithSubject = false;
        conversationDisplay = "tree";
        greentext = false;
        hideFilteredStatuses = false;
        hideMutedPosts = false;
        hidePostStats = false;
        hideSitename = false;
        hideUserStats = false;
        loginMethod = "password";
        logo = "/static/logo.svg";
        logoMargin = ".1em";
        logoMask = true;
        logoLeft = false;
        nsfwCensorImage = "";
        postContentType = "text/plain";
        redirectRootLogin = "/main/friends";
        redirectRootNoLogin = "/main/all";
        showFeaturesPanel = true;
        showInstanceSpecificPanel = false;
        sidebarRight = false;
        subjectLineBehavior = "email";
        theme = "cenezo-winter";
        webPushNotifications = false;
      })} $out/static/config.json
    '';
  });
in {
  age.secrets = {
    akkoma-secret-key = {
      file = ../secrets/akkoma-secret-key.age;
      owner = "akkoma";
    };
    akkoma-signing-salt = {
      file = ../secrets/akkoma-signing-salt.age;
      owner = "akkoma";
    };
    akkoma-smtp-password = {
      file = ../secrets/akkoma-smtp-password.age;
      owner = "akkoma";
    };
    akkoma-cookie = {
      file = ../secrets/akkoma-cookie.age;
      owner = "akkoma";
    };
  };

  services.postgresql = {
    enable = true;
    ensureDatabases = [ "akkoma" ];
    ensureUsers = [{
      name = "akkoma";
      ensureDBOwnership = true;
    }];
    authentication = pkgs.lib.mkAfter ''
      local akkoma akkoma peer
    '';
  };

  systemd.tmpfiles.rules = [
    "d /var/lib/akkoma/uploads 0750 akkoma akkoma - -"
    "a+ /var/lib/akkoma/uploads - - - - g:caddy:rx,d:g:caddy:r"
  ];

  systemd.services.akkoma.serviceConfig = {
    EnvironmentFile = config.age.secrets.akkoma-cookie.path;
    BindReadOnlyPaths = lib.mkForce [];
    BindPaths = lib.mkForce [
      "/var/lib/akkoma/uploads:/var/lib/akkoma/uploads:norbind"
    ];
    UMask = lib.mkForce "0027";
    ExecStartPost = lib.mkForce "+${pkgs.coreutils}/bin/chmod 750 /var/lib/akkoma/uploads";
  };

  services.akkoma = {
    enable = true;
    initDb.enable = true;
    frontends = {
      primary = {
        name = "pleroma-fe";
        ref = "stable";
	package = patchedFrontend;
      };
      admin = {
        name = "admin-fe";
        ref = "stable";
	package = pkgs.akkoma-admin-fe;
      };
    };
    config = {
      ":pleroma" = {
        ":instance" = {
	  name = "Kluge Akkoma";
	  short_description = "A small, general-purpose Akkoma instance";
	  description = ''${config.services.akkoma.config.":pleroma".":instance".short_description}. See the full list of what other software we host <a href="https://www.kluge.cafe/" target="_blank">here :)</a>'';
	  email = "starhazze@proton.me";
	  notify_email = "noreply@kluge.cafe";
	  limit = 5000;
	  remote_limit = 15000;
	  registrations_open = true;
	  allow_relay = true;
	  healthcheck = true;
	};

	"Pleroma.Web.Endpoint" = {
	  url = {
	    host = "a.kluge.cafe";
	    scheme = "https";
	    port = 443;
	  };
	  http = {
	    ip = "127.0.0.1";
	    port = 4000;
	  };
          secret_key_base._secret = config.age.secrets.akkoma-secret-key.path;
          signing_salt._secret = config.age.secrets.akkoma-signing-salt.path;
	};

        "Pleroma.Emails.Mailer" = {
          enabled = true;
          adapter = "!Swoosh.Adapters.SMTP";
          relay = "smtp-relay.brevo.com";
          port = 587;
          username = "a2878c001@smtp-brevo.com";
          password._secret = config.age.secrets.akkoma-smtp-password.path;
          ssl = false;
          tls = ":always";
          auth = ":always";
        };

        "Pleroma.Repo" = {
          adapter  = "!Ecto.Adapters.Postgres";
          username = "akkoma";
          database = "akkoma";
          socket_dir = "/run/postgresql";
        };

	":frontend_configurations".pleroma_fe = {
	  background = "https://www.kluge.cafe/assets/akkoma-bg.jpg";
	  theme = "cenezo-winter";
	};

	":mrf" = {
	  transparency = true;
	  policies = [
            {
              _elixirType = "raw";
              value = "Pleroma.Web.ActivityPub.MRF.SimplePolicy";
            }
	  ];
	};

	"Pleroma.Upload" = {
	  base_url = "https://a-img.kluge.cafe/";
	};

        ":http_security" = {
          enabled = true;
        };

        ":media_proxy" = {
          enabled = false;
        };
      }; 
    };
    extraStatic = {
      "static/terms-of-service.html" = pkgs.writeText "terms-of-service.html" ''
        <img width="256" src="https://www.kluge.cafe/assets/logo.png" alt="Kluge Banner">
        
        <p>Hello there and welcome to Kluge Akkoma, a yet another general-purpose akkoma instance! Please read the rules before posting anything:</p>
        
        <ol>
            <li><b>No NSFW/NSFL:</b> This includes images or videos of gore, porn and everything like that. This also includes links to such materials in any form. Permanent ban without appeals if you're caught.</li>
            <li><b>No sexual content involving minors:</b> Grooming, creepy behavior towards minors or ageplaying. Permanent ban without appeals if you're caught.</li>
            <li><b>No toxicity, hate speech, bigotry or slurs:</b> Heavy toxicity, bullying, bigotry (transphobia, homophobia, racism), Nazi slogans, slurs, calls for violence are not allowed.</li>
            <li><b>No illegal content (as defined by german law):</b> CSAM, stolen data, selling drugs etc. is not allowed. Permanent ban without appeals if you're caught.</li>
            <li><b>No doxxing:</b> Doxxing, sharing private info, leaking DMs, phone numbers etc. is not allowed without explicit consent.</li>
            <li><b>Bots:</b> Bots are allowed as long as you mark the account as a bot and don't constantly hammer APIs.</li>
            <li><b>No spam:</b> Flooding timelines, mass following, posting scam links or advertising commercial products is not allowed.</li>
            <li><b>Common sense:</b> Please use common sense. There are no "loopholes" in the rules, even if something is not listed here you can still get banned for it.</li>
        </ol>
        
        <p>The ToS can be found <a href="https://www.kluge.cafe/tos.html">here</a>, have fun! :)</p>
        
        <p>We have a matrix space at <a href="https://matrix.to/#/#space:kluge.cafe">https://matrix.to/#/#space:kluge.cafe</a>, feel free to join for announcements and the lounge!</p>
        
        <h2>Terms Of Service</h2>
        
        <p>The ToS can be found here: <a href="https://www.kluge.cafe/tos.html">https://www.kluge.cafe/tos.html</a></p>
      '';

      "static/themes/styles.json" = pkgs.writeText "styles.json" ''
        {
          "pleroma-dark": [ "Pleroma Dark", "#121a24", "#182230", "#b9b9ba", "#d8a070", "#d31014", "#0fa00f", "#0095ff", "#ffa500" ],
          "pleroma-light": [ "Pleroma Light", "#f2f4f6", "#dbe0e8", "#304055", "#f86f0f", "#d31014", "#0fa00f", "#0095ff", "#ffa500" ],
          "classic-dark": [ "Classic Dark", "#161c20", "#282e32", "#b9b9b9", "#baaa9c", "#d31014", "#0fa00f", "#0095ff", "#ffa500" ],
          "bird": [ "Bird", "#f8fafd", "#e6ecf0", "#14171a", "#0084b8", "#e0245e", "#17bf63", "#1b95e0", "#fab81e"],
          "ir-black": [ "Ir Black", "#000000", "#242422", "#b5b3aa", "#ff6c60", "#FF6C60", "#A8FF60", "#96CBFE", "#FFFFB6" ],
          "monokai": [ "Monokai", "#272822", "#383830", "#f8f8f2", "#f92672", "#F92672", "#a6e22e", "#66d9ef", "#f4bf75" ],
        
          "redmond-xx": "/static/themes/redmond-xx.json",
          "redmond-xx-se": "/static/themes/redmond-xx-se.json",
          "redmond-xxi": "/static/themes/redmond-xxi.json",
          "breezy-dark": "/static/themes/breezy-dark.json",
          "breezy-light": "/static/themes/breezy-light.json",
          "cenezo-winter": "/static/themes/cenezo-winter.json"
        }
      '';

      "static/themes/cenezo-winter.json" = pkgs.writeText "cenezo-winter.json" ''
        {
          "_pleroma_theme_version": 2,
	  "name": "cenezo-winter",
          "theme": {
            "themeEngineVersion": 3,
            "shadows": {
              "panel": [
                {
                  "color": "#04415c",
                  "x": "0",
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "alpha": "1"
                }
              ],
              "topBar": [
                {
                  "color": "#04415c",
                  "x": 0,
                  "y": "1",
                  "blur": "0",
                  "spread": "1",
                  "alpha": "1"
                },
                {
                  "color": "#000000",
                  "x": 0,
                  "y": "2",
                  "blur": "7",
                  "spread": 0,
                  "inset": false,
                  "alpha": "0.3"
                }
              ],
              "popup": [
                {
                  "color": "#04415c",
                  "x": "0",
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "alpha": "1"
                }
              ],
              "avatar": [
                {
                  "x": 0,
                  "y": 1,
                  "blur": 8,
                  "spread": 0,
                  "color": "#000000",
                  "alpha": 0.7
                }
              ],
              "avatarStatus": [],
              "panelHeader": [
                {
                  "color": "#04415c",
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "inset": false,
                  "alpha": "1"
                },
                {
                  "color": "#ffffff",
                  "x": "0",
                  "y": "1",
                  "blur": "0",
                  "spread": 0,
                  "inset": true,
                  "alpha": "0.2"
                }
              ],
              "button": [
                {
                  "color": "#085670",
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "1",
                  "inset": false,
                  "alpha": 1
                },
                {
                  "color": "#0f3e59",
                  "x": 0,
                  "y": 0,
                  "blur": 2,
                  "spread": 0,
                  "alpha": 1
                }
              ],
              "buttonHover": [
                {
                  "color": "#0B405C",
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "35",
                  "alpha": "0.75",
                  "inset": true
                },
                {
                  "color": "#085670",
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "1",
                  "alpha": 1,
                  "inset": false
                }
              ],
              "buttonPressed": [
                {
                  "color": "#0B405C",
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "35",
                  "alpha": 1,
                  "inset": true
                },
                {
                  "color": "#000000",
                  "x": 0,
                  "y": "0",
                  "blur": 0,
                  "spread": "1",
                  "alpha": "1",
                  "inset": false
                }
              ],
              "input": [
                {
                  "color": "#04415c",
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "alpha": "1",
                  "inset": false
                }
              ]
            },
            "colors": {
              "underlay": "#090e14",
              "bg": "#1c1c1c",
              "fg": "#161616",
              "cRed": "#ff0000",
              "cGreen": "#1ae600",
              "cOrange": "#ffff00",
              "cBlue": "#81beea",
              "accent": "#124d5e",
              "link": "#cccccc",
              "text": "#cccccc",
              "badgeNotification": "#161616",
              "badgeNotificationText": "#cccccc",
              "alertNeutral": "#cccccc",
              "alertNeutralText": "#cccccc",
              "alertPopupNeutral": "#cccccc",
              "alertPopupNeutralText": "#333333",
              "alertSuccess": "#1ae600",
              "alertSuccessText": "#ffffff",
              "alertPopupSuccess": "#1ae600",
              "alertPopupSuccessText": "#000000",
              "alertWarning": "#ffff00",
              "alertWarningText": "#cccccc",
              "alertPopupWarning": "#ffff00",
              "alertPopupWarningText": "#333333",
              "alertError": "#7c3a3a",
              "alertErrorText": "#cccccc",
              "alertPopupError": "#7c3a3a",
              "alertPopupErrorText": "#cccccc",
              "panel": "#161616",
              "panelText": "#cccccc",
              "alertNeutralPanelText": "#ffffff",
              "alertSuccessPanelText": "#ffffff",
              "alertWarningPanelText": "#ffffff",
              "alertErrorPanelText": "#cccccc",
              "fgText": "#cccccc",
              "topBar": "#161616",
              "topBarText": "#cccccc",
              "input": "#161616",
              "inputTopbarText": "#cccccc",
              "inputPanelText": "#cccccc",
              "inputText": "#cccccc",
              "btn": "#0a3449",
              "btnText": "#cccccc",
              "btnTopBarText": "#cccccc",
              "btnDisabled": "#182228",
              "btnDisabledTopBarText": "#454d51",
              "btnPanelText": "#cccccc",
              "btnDisabledPanelText": "#454d51",
              "btnDisabledText": "#454d51",
              "btnToggled": "#000000",
              "btnToggledTopBarText": "#cccccc",
              "btnToggledPanelText": "#cccccc",
              "btnToggledText": "#cccccc",
              "btnPressed": "#0c3850",
              "btnPressedTopBarText": "#cccccc",
              "btnPressedTopBar": "#0c3850",
              "btnPressedPanelText": "#cccccc",
              "btnPressedPanel": "#0c3850",
              "btnPressedText": "#cccccc",
              "tabActiveText": "#cccccc",
              "tabText": "#cccccc",
              "tab": "#0a3449",
              "fgLink": "#cccccc",
              "topBarLink": "#cccccc",
              "panelLink": "#cccccc",
              "panelFaint": "#cccccc",
              "icon": "#077cae",
              "poll": "#276c80",
              "pollText": "#cccccc",
              "border": "#04415c",
              "postCyantext": "#81beea",
              "postGreentext": "#1ae600",
              "postLink": "#00ccff",
              "lightText": "#ffffff",
              "popover": "#1c1c1c",
              "selectedMenuPopover": "#292929",
              "highlight": "#077cae",
              "highlightText": "#cccccc",
              "selectedMenu": "#0a6890",
              "selectedMenuText": "#cccccc",
              "selectedMenuPopoverIcon": "#7b7b7b",
              "highlightLink": "#333333",
              "selectedMenuLink": "#124d5f",
              "selectedMenuPopoverLink": "#a0dbed",
              "selectedMenuPopoverText": "#cccccc",
              "faintLink": "#04415c",
              "highlightFaintLink": "#a4e0fb",
              "selectedMenuFaintLink": "#a4e0fb",
              "selectedMenuPopoverFaintLink": "#a4e0fb",
              "faint": "#696969",
              "highlightFaintText": "#ffffff",
              "selectedMenuFaintText": "#ffffff",
              "selectedMenuPopoverFaintText": "#ffffff",
              "highlightLightText": "#ffffff",
              "selectedMenuLightText": "#ffffff",
              "selectedMenuPopoverLightText": "#ffffff",
              "selectedMenuIcon": "#6b9aae",
              "selectedPost": "#0a6890",
              "selectedPostText": "#cccccc",
              "selectedPostIcon": "#6b9aae",
              "selectedPostLink": "#cccccc",
              "selectedPostFaintLink": "#05415d",
              "highlightPostLink": "#00cbff",
              "selectedPostPostLink": "#00caff",
              "selectedPostLightText": "#ffffff",
              "selectedPostFaintText": "#ffffff",
              "popoverText": "#cccccc",
              "popoverIcon": "#747474",
              "popoverLink": "#cccccc",
              "postFaintLink": "#00ccff",
              "popoverPostFaintLink": "#00ccff",
              "popoverFaintLink": "#a4e0fb",
              "popoverFaintText": "#969696",
              "popoverPostLink": "#00ccff",
              "popoverLightText": "#ffffff",
              "highlightIcon": "#6aa4bd",
              "highlightPostFaintLink": "#00cbff",
              "profileTint": "#1c1c1c",
              "profileBg": "#0e0f10",
              "wallpaper": "#171717"
            },
            "opacity": {
              "underlay": 0.6,
              "bg": 0.8,
              "alert": 0.5,
              "alertPopup": 0.95,
              "panel": 1,
              "input": 0.9,
              "btn": 1,
              "faint": 0.5,
              "border": 1,
              "popover": 1,
              "profileTint": 0.5
            },
            "radii": {
              "btn": "4",
              "input": "2",
              "checkbox": "4",
              "panel": "8",
              "avatar": "2",
              "avatarAlt": "0",
              "tooltip": 2,
              "attachment": 5
            },
            "fonts": {
              "interface": {
                "family": "sans-serif"
              },
              "input": {
                "family": "inherit"
              },
              "post": {
                "family": "inherit"
              },
              "postCode": {
                "family": "monospace"
              }
            }
          },
          "source": {
            "themeEngineVersion": 3,
            "fonts": {},
            "shadows": {
              "panelHeader": [
                {
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "inset": false,
                  "color": "#04415c",
                  "alpha": "1"
                },
                {
                  "x": "0",
                  "y": "1",
                  "blur": "0",
                  "spread": 0,
                  "inset": true,
                  "color": "#ffffff",
                  "alpha": "0.2"
                }
              ],
              "panel": [
                {
                  "x": "0",
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "color": "#04415c",
                  "alpha": "1"
                }
              ],
              "topBar": [
                {
                  "x": 0,
                  "y": "1",
                  "blur": "0",
                  "spread": "1",
                  "color": "#04415c",
                  "alpha": "1"
                },
                {
                  "x": 0,
                  "y": "2",
                  "blur": "7",
                  "spread": 0,
                  "inset": false,
                  "color": "#000000",
                  "alpha": "0.3"
                }
              ],
              "input": [
                {
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "color": "#04415c",
                  "alpha": "1",
                  "inset": false
                }
              ],
              "popup": [
                {
                  "x": "0",
                  "y": "0",
                  "blur": "0",
                  "spread": "1",
                  "color": "#04415c",
                  "alpha": "1"
                }
              ],
              "buttonHover": [
                {
                  "x": 0,
                  "y": "0",
                  "blur": "0",
                  "spread": "35",
                  "color": "#0B405C",
                  "alpha": "0.75",
                  "inset": true
                },
                {
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "1",
                  "color": "#085670",
                  "alpha": 1,
                  "inset": false
                }
              ],
              "button": [
                {
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "1",
                  "inset": false,
                  "color": "#085670",
                  "alpha": 1
                },
                {
                  "x": 0,
                  "y": 0,
                  "blur": 2,
                  "spread": 0,
                  "color": "#0f3e59",
                  "alpha": 1
                }
              ],
              "buttonPressed": [
                {
                  "x": 0,
                  "y": 0,
                  "blur": "0",
                  "spread": "35",
                  "color": "#0B405C",
                  "alpha": 1,
                  "inset": true
                },
                {
                  "x": 0,
                  "y": "0",
                  "blur": 0,
                  "spread": "1",
                  "color": "#000000",
                  "alpha": "1",
                  "inset": false
                }
              ]
            },
            "opacity": {
              "bg": "0.8",
              "underlay": "0.6",
              "panel": "1",
              "input": "0.9"
            },
            "colors": {
              "bg": "#1c1c1c",
              "fg": "#161616",
              "text": "#cccccc",
              "underlay": "#090e14",
              "link": "#cccccc",
              "accent": "#124d5e",
              "faint": "#696969",
              "faintLink": "#04415c",
              "cBlue": "#81beea",
              "cRed": "#ff0000",
              "cGreen": "#1ae600",
              "cOrange": "#FFFF00",
              "highlight": "#077cae",
              "highlightText": "#cccccc",
              "popover": "#1c1c1c",
              "popoverText": "#cccccc",
              "selectedPost": "#0a6890",
              "selectedPostText": "#cccccc",
              "selectedMenu": "#0a6890",
              "selectedMenuText": "#cccccc",
              "selectedMenuLink": "#124d5f",
              "postLink": "#00CCFF",
              "border": "#04415c",
              "poll": "#276C80",
              "pollText": "#cccccc",
              "icon": "#077cae",
              "fgText": "#cccccc",
              "fgLink": "#cccccc",
              "panel": "#161616",
              "topBar": "#161616",
              "topBarText": "#cccccc",
              "topBarLink": "#cccccc",
              "btn": "#0A3449",
              "btnPressed": "#0c3850",
              "btnToggled": "--accent,-24.2",
              "input": "#161616",
              "inputText": "#cccccc",
              "alertError": "#7C3A3A",
              "alertErrorText": "#cccccc",
              "alertWarning": "#FFFF00",
              "alertWarningText": "#cccccc",
              "alertNeutral": "#cccccc",
              "alertNeutralText": "#cccccc",
              "badgeNotification": "#16161600",
              "badgeNotificationText": "#cccccc"
            },
            "radii": {
              "btn": "4",
              "input": "2",
              "checkbox": "4",
              "panel": "8",
              "avatar": "2",
              "avatarAlt": "0",
              "tooltip": 2,
              "attachment": 5
            }
          }
        }
      '';
    };
  };
}

{ config, pkgs, lib, ... }: 
{
  age.secrets = {
    akkoma-secret-key = {
      file = ./secrets/akkoma-secret-key.age;
      owner = "akkoma";
    };
    akkoma-signing-salt = {
      file = ./secrets/akkoma-signing-salt.age;
      owner = "akkoma";
    };
    akkoma-smtp-password = {
      file = ./secrets/akkoma-smtp-password.age;
      owner = "akkoma";
    };
    akkoma-cookie = {
      file = ./secrets/akkoma-cookie.age;
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
    "d /var/lib/akkoma/mutable-static               0750 akkoma akkoma -"
    "d /var/lib/akkoma/mutable-static/emoji         0750 akkoma akkoma -"
    "d /var/lib/akkoma/mutable-static/frontends     0750 akkoma akkoma -"
    "d /var/lib/akkoma/mutable-static/frontends/tmp 0750 akkoma akkoma -"
  ];

  systemd.services.akkoma.serviceConfig = {
    EnvironmentFile = config.age.secrets.akkoma-cookie.path;
    BindPaths = lib.mkForce [
      "/var/lib/akkoma/uploads:/var/lib/akkoma/uploads:norbind"
      "/var/lib/akkoma/mutable-static:/var/lib/akkoma/mutable-static:norbind"
    ];
    BindReadOnlyPaths = lib.mkForce [];
  };

  services.akkoma = {
    enable = true;
    initDb.enable = true;
    frontends = {
      primary = {
        name = "pleroma-fe";
        ref = "stable";
      };
      admin = {
        name = "admin-fe";
        ref = "stable";
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
	  registrations_open = false;
	  allow_relay = true;
	  static_dir = "/var/lib/akkoma/mutable-static";
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
	  base_url = "https://a.kluge.cafe/media/";
	};

        ":http_security" = {
          enabled = true;
        };

        ":media_proxy" = {
          enabled = false;
        };
      }; 
    };
  };

  systemd.tmpfiles.settings."10-akkoma-tos" = {
    "/var/lib/akkoma/mutable-static/instance/terms-of-service.html" = {
      f = {
        argument = ''
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
        user = "akkoma";
        group = "akkoma";
        mode = "0644";
      };
    };
  };
}

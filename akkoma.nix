{ config, pkgs, lib, ... }: 
# this and akkoma-blocklist.nix is unused for now
let
  akkoma = { 
    description = ''
      [![](https://lm.kluge.cafe/pictrs/image/a031f2c9-046f-4612-a9bb-3207b94f4754.png)](https://www.kluge.cafe/)
      
      Hello there and welcome to Kluge Akkoma, a yet another general-purpose akkoma instance! Please read the rules before posting anything:
      
      **1.** No NSFW/NSFL: This includes images or videos of gore, porn and everything like that. This also includes links to such materials in any form. Permanent ban without appeals if you're caught.
      
      **2.** No sexual content involving minors: Grooming, creepy behavior towards minors or ageplaying. Permanent ban without appeals if you're caught.
      
      **3.** No toxicity, hate speech, bigotry or slurs: Heavy toxicity, bullying, bigotry (transphobia, homophobia, racism), Nazi slogans, slurs, calls for violence are not allowed.
      
      **4.** No illegal content (as defined by german law): CSAM, stolen data, selling drugs etc. is not allowed. Permanent ban without appeals if you're caught.
      
      **5.** No doxxing: Doxxing, sharing private info, leaking DMs, phone numbers etc. is not allowed without explicit consent.
      
      **6.** Bots: Bots are allowed as long as you mark the account as a bot and don't constantly hammer APIs.
      
      **7.** No spam: Flooding timelines, mass following, posting scam links or advertising commercial products is not allowed.
      
      **8.** Common sense: Please use common sense. There are no "loopholes" in the rules, even if something is not listed here you can still get banned for it.
      
      The ToS can be found [here](https://www.kluge.cafe/tos.html), have fun! :)
      
      We have a matrix space at [https://matrix.to/#/#space:kluge.cafe](https://matrix.to/#/#space:kluge.cafe), feel free to join for announcements and the lounge! 
    '';
  };
in
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
    config = {
      ":pleroma" = {
        ":configurable_from_database" = true;
        ":instance" = {
	  name = "Kluge Akkoma";
	  description = akkoma.description;
	  email = "starhazze@proton.me";
	  notify_email = "noreply@kluge.cafe";
	  limit = 5000;
	  registrations_open = true;
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
          signing_salt._secret    = config.age.secrets.akkoma-signing-salt.path;
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
          # password._secret = config.age.secrets.akkoma-db-password.path;
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
}

{ pkgs, config, lib, ... }: {
  age.secrets.glance-env = {
    file = ../secrets/glance-stats-token.age;
    owner = "glance";
  };

  users.users.glance = {
    isSystemUser = true;
    group = "glance";
  };
  users.groups.glance = {};

  services.glance = {
    enable = true;
    environmentFile = "${config.age.secrets.glance-env.path}";
    settings = {
      server = {
        port = 5678;
        host = "127.0.0.1";
      };
      pages = [
        {
          name = "wellcum";
          width = "slim";
          hide-desktop-navigation = true;
          center-vertically = true;
          theme = {
            background-color = "225 14 15";
            primary-color = "157 47 65";
            contrast-multiplier = 1.1;
          };
          columns = [
            {
              size = "full";
              widgets = [
                {
                  type = "search";
                  search-engine = "duckduckgo";
                  autofocus = true;
                  bangs = [
                    { title = "YouTube";    shortcut = "!yt"; url = "https://www.youtube.com/results?search_query={QUERY}"; }
                    { title = "GitHub";     shortcut = "!gh"; url = "https://github.com/search?q={QUERY}"; }
                    { title = "Kagi";       shortcut = "!k";  url = "https://kagi.com/search?q={QUERY}"; }
                    { title = "Reddit";     shortcut = "!r";  url = "https://www.reddit.com/search/?q={QUERY}"; }
                    { title = "NixOS Wiki"; shortcut = "!n";  url = "https://nixos.wiki/index.php?search={QUERY}"; }
                    { title = "Arch Wiki";  shortcut = "!a";  url = "https://wiki.archlinux.org/index.php?search={QUERY}"; }
                  ];
                }
                {
                  type = "monitor";
                  cache = "1m";
                  title = "Services";
                  sites = [
                    { title = "Navidrome"; url = "https://music.kluge.cafe/"; icon = "di:navidrome"; }
                    { title = "Chibisafe"; url = "https://safe.kluge.cafe/";  icon = "di:chibisafe"; }
                    { title = "Matrix";    url = "https://matrix.kluge.cafe/"; icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/svg/continuwuity.svg"; }
                    { title = "Lemmy";     url = "https://lm.kluge.cafe/";    icon = "di:lemmy"; }
                    { title = "Plausible";  url = "https://plausible.kluge.cafe/";     icon = "di:plausible"; }
                    { title = "Sharkey";   url = "https://kluge.cafe/";      icon = "https://cdn.jsdelivr.net/gh/selfhst/icons@main/png/sharkey.png"; }
                  ];
                }
                {
                  type = "bookmarks";
                  groups = [
                    {
                      title = "General";
                      links = [
                        { title = "ProtonMail";     url = "https://mail.proton.me/"; }
                        { title = "Cloudflare";     url = "https://dash.cloudflare.com/"; }
                        { title = "NixPkgs Search"; url = "https://search.nixos.org/packages?channel=unstable"; }
                      ];
                    }
                    {
                      title = "Entertainment";
                      links = [
                        { title = "YouTube";   url = "https://www.youtube.com/"; }
                        { title = "Rive";  url = "https://rivestream.app/"; }
                        { title = "Polytoria"; url = "https://polytoria.com/"; }
                      ];
                    }
                    {
                      title = "Social";
                      links = [
                        { title = "Lemmy";   url = "https://lm.kluge.cafe/"; }
                        { title = "Sharkey"; url = "https://kluge.cafe/"; }
                        { title = "Reddit";  url = "https://reddit.com/"; }
                      ];
                    }
                  ];
                }
                {
                  type = "rss";
                  title = "News";
                  style = "horizontal-cards";
                  feeds = [
                    { title = "KDE Announcements";   url = "https://kde.org/index.xml"; }
                    { title = "KDE Blogs";           url = "https://blogs.kde.org/index.xml"; }
                    { title = "NixOS Announcements"; url = "https://nixos.org/blog/announcements-rss.xml"; }
		    { title = "Debian News";         url = "https://www.debian.org/News/news"; }
		    { title = "LWN";                 url = "https://lwn.net/headlines/rss"; }
		    { title = "selfh.st";            url = "https://selfh.st/rss"; }
                  ];
                }
		{
		  type = "server-stats";
		  servers = [
		    { type = "local"; name = "DE"; }
		    { type = "remote"; name = "FI"; url = "\${STATS_URL}"; token = "\${STATS_TOKEN}"; }
		  ];
		}
              ];
            }
          ];
        }
      ];
    };
  };
}

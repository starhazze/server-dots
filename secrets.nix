let
  haze = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBKU5Apez86vNAvvkHKiAeyMOvzkC0qdabZyE1foEOqw starhaze@nixos";

  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIADgSeAX8FVkCVyd/18vtE63CQP/WxdzRu0bFXueHGu root@nixos-de";
in {
  "secrets/smtp-pass.age".publicKeys = [ haze server ];
  "secrets/cloudflare-dns-token.age".publicKeys = [ haze server];
  "secrets/lemmy-smtp.age".publicKeys = [ haze server ];
  "secrets/pictrs-api-key.age".publicKeys = [ haze server ];
  "secrets/lemmy-admin-pass.age".publicKeys = [ haze server ];
  "secrets/glance-stats-token.age".publicKeys = [ haze server ];
  "secrets/minecraft-env.age".publicKeys = [ haze server ];
}

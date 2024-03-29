{ config, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 443 ];
# Web Server ssl and non ssl
  security.acme.acceptTerms = true;
  security.acme.defaults.email = "adam@emtorp.se";
  # /var/lib/acme/.challenges must be writable by the ACME user
# and readable by the Nginx user. The easiest way to achieve
# this is to add the Nginx user to the ACME group.
  users.users.nginx.extraGroups = [ "acme" ];
#  environment.systemPackages = with pkgs; [ tcpdump openssl ];
  services.nginx = {
    enable = true;
    virtualHosts."imap01.emtorp.se" = {
        root = "/var/www/acme-challenge";
        listen = [
          { addr = "0.0.0.0"; port = 80; }
        ];
        addSSL = true;
        enableACME = true;
    };
  };
}

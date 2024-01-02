{ config, lib, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.unbound = {
    enable = true;
    settings = {
      access-control = [ "127.0.0.0/24 allow" "91.228.90.0/24 allow" "2001:67c:22fc::/48 allow" "10.5.1.0/24 allow"];
      interface = [ "0.0.0.0" "::0"];

    }
    #forward-zone = [{
    #  name
    #}];
  };
}

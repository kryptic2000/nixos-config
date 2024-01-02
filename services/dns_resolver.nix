{ config, lib, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.unbound = {
    enable = true;
    allowedAccess = [ "127.0.0.0/24" "91.228.90.0/24" "2001:67c:22fc::/48" "10.5.1.0/24"];
    interfaces = [ "0.0.0.0" "::0"];
    #forward-zone = [{
    #  name
    #}];
  };
}

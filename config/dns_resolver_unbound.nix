{ config, lib, pkgs, ... }:

{

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.unbound = {
    enable = true;
    allowedAccess = [ "127.0.0.0/24" "91.228.90.0/24" "2001:67c:22fc::/48"];
    forwardAddresses = [ "8.8.8.8" "8.8.4.4" ];
    interfaces = [ "0.0.0.0" "::0"];
  };
}

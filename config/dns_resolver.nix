{ config, lib, pkgs, ... }:

{

  environment.systemPackages = with pkgs; [
     bind
  ];

  networking.firewall.allowedTCPPorts = [ 53 ];

  services.bind = {
    enable = true;
    cacheNetworks = [ "127.0.0.1/32" "91.228.90.0/24" ];
  };
}

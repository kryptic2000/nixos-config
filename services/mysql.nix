{ config, lib, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3306 ];
  networking.firewall.allowedUDPPorts = [ 3306 ];

  services.mysql.enable = true;
  services.mysql.package = pkgs.mysql80;
  services.mysql.port = 3306;
  services.mysql.bind = "0.0.0.0";
}

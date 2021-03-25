{ config, lib, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3306 ];
  networking.firewall.allowedUDPPorts = [ 3306 ];
  users.users.mysql = { };

  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    dataDir = "/var/lib/mysql";
    initialScript = pkgs.writeText "initScript" ''
      CREATE USER 'admin'@'%' IDENTIFIED BY 'admin';
      GRANT ALL PRIVILEGES ON * . * TO 'admin'@'%';
    '';
  };
}

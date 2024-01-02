{ config, lib, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 3306 ];
  users.users.mysql = { };

  services.mysql = {
    enable = true;
    package = pkgs.mysql80;
    dataDir = "/var/lib/mysql";
    settings.mysqld.plugin-load-add = ["auth_socket.so"];
  };
}


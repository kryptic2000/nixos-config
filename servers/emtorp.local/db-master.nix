{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base20.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../services/mysql.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "10.5.20.22/24";
  netcfg.gw4 = "10.5.20.1";
  networking.enableIPv6 = true;
  netcfg.ip6 = "fd00::7/128";

  netcfg.iface = "ens32";
  netcfg.hostName = "be-db-02-master";

  environment = {
    systemPackages = with pkgs; [
      #openssl
    ];
  };
  services.mysql.replication.role = "master";
  services.mysql.replication.serverId = 1;
  services.mysql.replication.slaveHost = "%";
  services.mysql.replication.masterUser = "repl";
  services.mysql.replication.masterPassword = (builtins.readFile /etc/nixos/.repl.pwd);
  services.mysql.initialDatabases = [{ name = "magento"; }];
  services.mysql.ensureDatabases = [ "magento" ];

}



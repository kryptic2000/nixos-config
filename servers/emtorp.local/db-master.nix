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

  netcfg.ip4 = "10.5.20.5/24";
  netcfg.gw4 = "10.5.20.1";
  networking.enableIPv6 = true;
  netcfg.ip6 = "fd00::7/128";

  netcfg.iface = "ens32";
  netcfg.hostName = "db-master";

  environment = {
    systemPackages = with pkgs; [
      #openssl
    ];
  };

  services.mysql.initialDatabases = [{
    name = "magento";
  }];
  services.mysql.initialScript = ''
    CREATE USER 'magento'@'localhost' IDENTIFIED BY 'default';
    GRANT ALL PRIVILEGES ON magento.* TO 'magento'@'%';
  '';
  services.mysql.ensureUsers = [{
    name = "magento";
      ensurePermissions = {
        "magento.*" = "ALL PRIVILEGES";
      };
  }];

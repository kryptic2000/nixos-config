{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../services/influxdb.nix
      ../../services/grafana.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "192.168.1.7/24";
  netcfg.gw4 = "192.168.1.1";
  networking.enableIPv6 = true;
  netcfg.ip6 = "fd00::7/128";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "192.168.1.3";

  environment = {
    systemPackages = with pkgs; [
      #openssl
    ];
  };
}

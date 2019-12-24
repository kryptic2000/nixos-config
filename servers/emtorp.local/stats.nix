{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "192.168.1.7";
  netcfg.gw4 = "192.168.1.1";

#  netcfg.ip6 = "2001:67c:22fc:100::84";
#  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "192.168.1.3";

  environment = {
    systemPackages = with pkgs; [
      #openssl
    ];
  };
}

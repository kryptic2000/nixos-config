{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../config/emtorp.net/mx_relay.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only


  netcfg.ip4 = "91.228.90.88";
  netcfg.gw4 = "91.228.90.81";

  netcfg.ip6 = "2001:67c:22fc:100::88";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "mx01.emtorp.net";

}


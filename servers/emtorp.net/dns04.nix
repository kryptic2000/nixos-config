{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../config/dns_resolver_unbound.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.93/28";
  netcfg.gw4 = "91.228.90.81";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:1::93/64";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "dns04.emtorp.net";

  netcfg.ns = [ "8.8.4.4" "8.8.8.8" ];

}

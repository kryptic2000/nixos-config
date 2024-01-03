{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base23.nix
      ../../config/users.nix
      ../../services/networking23.nix
      ../../services/dns_slave.nix
      ../../config/emtorp.net/ns1_zones.nix
      ../../services/bgp_vip.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.87/28";
  netcfg.gw4 = "91.228.90.81";

  netcfg.addr4 = "91.228.90.87";
  netcfg.addr6 = "2001:67c:22fc:100::87";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:100::87/64";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.vip4 = "91.228.90.35";
  netcfg.vip6 = "2001:67c:22fc:5::1";

  netcfg.iface = "ens33";
  netcfg.hostName = "ns1";
  netcfg.domain = "emtorp.net";

  environment = {
    systemPackages = with pkgs; [
      openssl
    ];
  };
}

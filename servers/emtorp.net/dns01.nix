{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/networking.nix
      ../../services/dns_slave.nix
      ../../config/emtorp.net/ns1_zones.nix
      ../../services/bgp_vip.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.94/28";
  netcfg.gw4 = "91.228.90.81";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:100::84/64";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.vip4 = "91.228.90.35";
  netcfg.vip6 = "2001:67c:22fc:5::1";

  netcfg.iface = "enp0s3";
  netcfg.hostName = "dns01.emtorp.net";

  environment = {
    systemPackages = with pkgs; [
      openssl
    ];
  };
}

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

  netcfg.ip4 = "91.228.90.140/28";
  netcfg.gw4 = "91.228.90.129";

  netcfg.addr4 = "91.228.90.140";
  netcfg.addr6 = "2001:67c:22fc:100::140";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:1::140/64";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.vip4 = "91.228.90.35";
  netcfg.vip6 = "2001:67c:22fc:250::1";

  netcfg.iface = "ens32";
  netcfg.hostName = "dns02.emtorp.net";

  environment = {
    systemPackages = with pkgs; [
      openssl
    ];
  };
}

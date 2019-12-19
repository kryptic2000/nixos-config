{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../services/dns_slave.nix
      ../../config/emtorp.net/ns1_zones.nix
      ../../services/bgp_vip.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.94";
  netcfg.gw4 = "91.228.90.81";

  netcfg.ip6 = "2001:67c:22fc:100::84";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.vip4 = "91.228.90.35";
  netcfg.vip6 = "2001:67c:22fc:5::1";

  networking.hostName = "dns01.emtorp.net";
  networking.enableIPv6 = true;

  networking.interfaces.enp0s3.ipv4.addresses = [ {
    address = netcfg.ip4;
    prefixLength = 28;
  } ];
  networking.interfaces.enp0s3.ipv6.addresses = [ {
    address = netcfg.ip6;
    prefixLength = 64;
  } ];
  networking.interfaces.lo.ipv4.addresses = [ {
        address = netcfg.vip4;
        prefixLength = 32;
  } ];
  networking.interfaces.lo.ipv6.addresses = [ {
    address = netcfg.vip6;
    prefixLength = 128;
  } ];

  networking.defaultGateway = netcfg.gw4;
  networking.defaultGateway6 = netcfg.gw6;

  networking.nameservers = [ "8.8.4.4" "8.8.8.8" ];

  environment = {
    systemPackages = with pkgs; [
      openssl
    ];
  };
}

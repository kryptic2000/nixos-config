{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../config/base.nix
      ../../config/users.nix
      ../../modules/variables.nix
      ../../services/dns_slave.nix
      ../../config/emtorp.net/ns1_zones.nix
      ../../services/bgp_vip.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.136";
  netcfg.gw4 = "91.228.90.129";

  netcfg.ip6 = "2001:67c:22fc:1::136";
  netcfg.gw6 = "2001:67c:22fc:1::1";

  netcfg.vip4 = "91.228.90.35";
  netcfg.vip6 = "2001:67c:22fc:1::137";

  networking.hostName = "dns02.emtorp.net";
  networking.enableIPv6 = true;

  networking.interfaces.ens32.ipv4.addresses = [ {
    address = netcfg.ip4;
    prefixLength = 28;
  } ];
  networking.interfaces.ens32.ipv6.addresses = [ {
    address = "2001:67c:22fc:1::136";
    prefixLength = 64;
  } ];
  networking.interfaces.lo.ipv4.addresses = [ {
        address = "91.228.90.35";
        prefixLength = 32;
  } ];
  networking.interfaces.lo.ipv6.addresses = [ {
    address = "2001:67c:22fc:1::137";
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

{ config, lib, pkgs, netcfg, ... }:

{
  networking.interfaces.lo.ipv4.addresses = [{
    address = netcfg.vip4;
    prefixLength = 32;
  }];
  networking.interfaces.lo.ipv6.addresses = [{
    address = netcfg.vip6;
    prefixLength = 128;
  }];

  services.frr = {
    zebra.enable = true;
  };
}

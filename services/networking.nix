{ config, lib, pkgs, netcfg, ... }:

{
  networking.hostName = netcfg.hostName;
  networking.enableIPv6 = true;

  networking.interfaces.${netcfg.iface} = {
    ipv4.addresses = [ {
      address = netcfg.ip4;
      prefixLength = 28;
    } ];
    ipv6.addresses = [ {
      address = netcfg.ip6;
      prefixLength = 64;
    } ];
  };

  networking.defaultGateway = netcfg.gw4;
  networking.defaultGateway6 = netcfg.gw6;
  networking.nameservers = netcfg.ns;
}

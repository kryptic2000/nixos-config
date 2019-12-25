{ config, lib, pkgs, netcfg, ... }:
let
  pfx4 = lib.splitString "/" netcfg.ip4;
  addr4 = { address = lib.elemAt pfx4 0; prefixLength = lib.toInt (lib.elemAt pfx4 1); };

  pfx6 = lib.splitString "/" netcfg.ip6;
  addr6 = { address = lib.elemAt pfx6 0; prefixLength = lib.toInt (lib.elemAt pfx6 1); };
in
{
  networking.hostName = netcfg.hostName;
  networking.enableIPv6 = true;

  networking.interfaces.${netcfg.iface} = {
    ipv4.addresses = [ addr4 ];
    ipv6.addresses = [ addr6 ];
  };

  networking.defaultGateway = netcfg.gw4;
  networking.defaultGateway6 = netcfg.gw6;
  networking.nameservers = netcfg.ns;
}

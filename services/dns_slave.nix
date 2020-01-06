{ config, lib, pkgs, netcfg, ... }:

{

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.nsd = {
    enable = true;
    interfaces = [ "127.0.0.1" "::1" "${netcfg.addr4}" "${netcfg.vip4}" "${netcfg.addr6}" "${netcfg.vip6}" ];
    ipv4 = true;
    ipv6 = true;
    remoteControl.enable = true;
  };
}

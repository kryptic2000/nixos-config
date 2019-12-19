{ config, lib, pkgs, netcfg, ... }:

{

  networking.firewall.allowedTCPPorts = [ 53 ];
  networking.firewall.allowedUDPPorts = [ 53 ];

  services.nsd = {
    enable = true;
    interfaces = [ "127.0.0.1" "::1" "${netcfg.ip4}" "${netcfg.vip4}" "${netcfg.ip6}" "${netcfg.vip6}" ];
    ipv4 = true;
    ipv6 = true;
    remoteControl.enable = true;
    zones = {
      "ns1" = { 
	allowNotify = [ "91.228.90.85 NOKEY" ];
	requestXFR = [ "91.228.90.85 NOKEY" ];
        outgoingInterface = "${netcfg.ip4}";
        children = {
          "emtorp.net" = { data = ''
            @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';
          };
        };
      };
    };
  };
}

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
    zebra = {
      enable = true;
    };
    bgp = {
      enable = true;
      config = ''
        ip prefix-list ANYCAST seq 5 permit ${netcfg.vip4}/32
        ip prefix-list IMPORT seq 5 deny any
        ipv6 prefix-list ANYCAST6 seq 5 permit ${netcfg.vip6}/128
        ipv6 prefix-list IMPORT6 seq 5 deny any

        router bgp 65500
          bgp router-id ${netcfg.addr4}
          network ${netcfg.vip4}/32
          neighbor ${netcfg.gw4} remote-as 56848
          neighbor ${netcfg.gw4} next-hop-self
          neighbor ${netcfg.gw4} prefix-list IMPORT in
          neighbor ${netcfg.gw4} prefix-list ANYCAST out
           address-family ipv6
             network ${netcfg.vip6}/128
             neighbor ${netcfg.gw6} remote-as 56848
             neighbor ${netcfg.gw6} prefix-list IMPORT6 in
             neighbor ${netcfg.gw6} prefix-list ANYCAST6 out
           address-family ipv6 unicast
             neighbor ${netcfg.gw6} activate
      '';
    };
  };
}

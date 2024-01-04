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
          bgp router-id 91.228.90.87
          neighbor 91.228.90.81 remote-as 56848
          neighbor 2001:67c:22fc:100::1 remote-as 56848

          address-family ipv4 unicast
            network ${netcfg.vip4}/32
            neighbor 91.228.90.81 next-hop-self
            neighbor 91.228.90.81 prefix-list IMPORT in
            neighbor 91.228.90.81 prefix-list ANYCAST out
          exit-address-family

          address-family ipv6 unicast
            network ${netcfg.vip6}/128
            neighbor 2001:67c:22fc:100::1 activate
            neighbor 2001:67c:22fc:100::1 prefix-list IMPORT6 in
            neighbor 2001:67c:22fc:100::1 prefix-list ANYCAST6 out
 exit-address-family
      '';
    };
  };
}

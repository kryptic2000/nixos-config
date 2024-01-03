{ config, lib, pkgs, netcfg, ... }:

{
   networking.interfaces.lo.ipv4.addresses = [ {
        address = netcfg.vip4;
        prefixLength = 32;
    } ];
   networking.interfaces.lo.ipv6.addresses = [ {
      address = netcfg.vip6;
      prefixLength = 128;
   } ];



   services.frr = {
     services = [
       "static"
       "bgp"
       "mgmt"
     ];
     serviceOptions = {
       enable = true;
       vtyListenPort = 2605;
       config = ''
         router bgp 56848
         neighbor ${netcfg.gw4} remote-as 56848
       '';
     };
   };
}

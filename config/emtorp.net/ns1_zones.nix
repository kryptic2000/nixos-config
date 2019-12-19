{ config, lib, pkgs, netcfg, ... }:
{
    services.nsd.zones = {
      "EMTORP" = {
        outgoingInterface = "${netcfg.ip4}";
        allowNotify = [ "91.228.90.85 NOKEY" ];
        requestXFR = [ "91.228.90.85 NOKEY" ];
        children = {
          "emtorp.net" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "emtorp.se" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "90.228.91.in-addr.arpa" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "c.f.2.2.c.7.6.0.1.0.0.2.ip6.arpa" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "igormud.org" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "igormud.net" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};
          "igormud.com" = { data = ''
                @ SOA ns1.emtorp.net adam.emtorp.se 1 3600 3600 1209600 86400
          '';};

        };
      };
      "SLAYER" = {
        outgoingInterface = "${netcfg.ip4}";
        allowNotify = [ "213.21.95.204 NOKEY" ];
        requestXFR = [ "213.21.95.204 NOKEY" ];
        children = {
          "slayer.se" = { data = ''
                @ SOA postmortem.slayer.se conny.blackmetal.org 1 3600 3600 1209600 86400
          '';};
          "blackmetal.org" = { data = ''
                @ SOA postmortem.slayer.se conny.blackmetal.org 1 3600 3600 1209600 86400
          '';};
          "danzig.se" = { data = ''
                @ SOA postmortem.slayer.se conny.blackmetal.org 1 3600 3600 1209600 86400
          '';};
        };
      };
    };
}

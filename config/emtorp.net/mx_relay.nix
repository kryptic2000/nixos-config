{ config, lib, pkgs, ... }:

with lib;

let

  spfConfig = pkgs.writeTextFile {
    name = "policyd-spf.conf";
    text = ''
debugLevel = 2
HELO_reject = False
Mail_From_reject = Fail
PermError_reject = False
TempError_Defer = False
skip_addresses = 127.0.0.0/8,::ffff:127.0.0.0/104,::1
    '';
  };

in

{

  environment.systemPackages = with pkgs; [
     pypolicyd-spf
  ];

  networking.firewall.allowedTCPPorts = [ 25 ];

  services.postfix = {
    enable = true;
  services.postfix = {
    enable = true;
    #relayHost = "mta01.emtorp.net";
    relayDomains = [
                "emtorp.net"
                "emtorp.se"
                "devkit.se"
                ];
    dnsBlacklists = [
                "zen.spamhaus.org"
                "sbl.spamhaus.org"
                "bl.spamcop.net"
                "cbl.abuseat.org"
                ];
    transport = ''
                emtorp.se     smtp:[mta01.emtorp.net]:25
                emtorp.net    smtp:[mta01.emtorp.net]:25
                devkit.se     lmtp:[91.228.90.136]:2424
    '';
    config = {
      smtpd_helo_required = true;
      smtpd_helo_restrictions = [
       # "reject_invalid_helo_hostname"
	"reject_non_fqdn_helo_hostname"
       # "reject_unknown_helo_hostname"
      ];
      smtpd_sender_restrictions = [
        "reject_non_fqdn_sender"
	"reject_unknown_sender_domain"
	"check_policy_service unix:private/policyspf"
      ];
    };
    extraMasterConf = ''policyspf	unix  -       n       n       -       0       spawn
         user=nobody argv=${pkgs.pypolicyd-spf}/bin/policyd-spf ${spfConfig}'';
  };
}

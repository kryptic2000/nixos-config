{ config, lib, pkgs, netcfg, ... }:

{
  networking.firewall.allowedTCPPorts = [ 80 465 ];

  security.acme.acceptTerms = true;
  security.acme.defaults.email = "adam@emtorp.se";
  security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".reloadServices = [
    "postfix.service"
  ];

  services.nginx = {
    enable = true;
    virtualHosts."${netcfg.hostName + "." + netcfg.domain}" = {
      serverName = "${netcfg.hostName + "." + netcfg.domain}";
      forceSSL = false;
      enableACME = true;
      locations."/" = {
        extraConfig = ''
          deny all; 
          return 403;
	'';
      };
    };
  };
  services.opendkim = {
    enable = true;
    socket = "inet:8891@127.0.0.1";
    domains = "csl:emtorp.se,emtorp.net";
    selector = "smtp01";
  };

  users.users.postfix = {
    extraGroups = [ "nginx"];
  };

  services.postfix = {
    enable = true;
    networks = [
      "127.0.0.0/8"
      "[::ffff:127.0.0.0]/104"
      "[::1]/128 91.228.90.0/24"
    ];
    domain = config.networking.domain;
    origin = netcfg.hostName + "." + netcfg.domain;
    hostname = config.services.postfix.origin;

    config = {
      smtp_helo_name = config.services.postfix.origin;
      smtpd_client_restrictions =  "permit_mynetworks,permit_sasl_authenticated,reject_unknown_client_hostname";

      #SASL
      smtpd_sasl_auth_enable = "yes";
      broken_sasl_auth_clients = "yes";
      smtpd_sasl_security_options = "noanonymous";

      #DKIM
      milter_default_action = "accept";
      milter_protocol = "6";
      smtpd_milters = "inet:localhost:8891";
      non_smtpd_milters = "inet:localhost:8891";
    };
    submissionsOptions = {
      smtpd_sasl_auth_enable = "yes";
      smtp_sasl_mechanism_filter = "plain,login";
      smtpd_client_restrictions = "permit_sasl_authenticated,reject";
      smtpd_sasl_type = "dovecot";
      smtpd_sasl_path = "inet:91.228.90.94:14650";

    };
    enableSmtp = true;
    enableSubmissions = true;
    sslCert = "${config.security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".directory}/fullchain.pem";
    sslKey = "${config.security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".directory}/key.pem";
  };
}

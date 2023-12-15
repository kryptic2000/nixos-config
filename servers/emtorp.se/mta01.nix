{ config, pkgs, netcfg, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ../../../hardware-configuration.nix
      ../../../maildb.nix
      ../../config/base23.nix
      ../../config/users.nix
      ../../config/mail-users.nix
      ../../services/networking23.nix
      ../../services/nfs-client.nix
      #../../config/emtorp.net/smtp.nix
    ];

  # Use the GRUB 2 boot loader.
  boot.loader.grub.device = "/dev/sda"; # or "nodev" for efi only

  netcfg.ip4 = "91.228.90.92/28";
  netcfg.gw4 = "91.228.90.81";

  netcfg.addr4 = "91.228.90.92";
  netcfg.addr6 = "2001:67c:22fc:100::92";

  networking.enableIPv6 = true;
  netcfg.ip6 = "2001:67c:22fc:100::92/64";
  netcfg.gw6 = "2001:67c:22fc:100::1";

  netcfg.iface = "ens33";
  netcfg.hostName = "mta01";
  netcfg.domain = "emtorp.se";

  networking.firewall.extraCommands = ''
        iptables -A nixos-fw -p tcp -m state --state NEW --source 91.228.90.0/24 --destination ${netcfg.ip4} --dport 2500 -j ACCEPT
        iptables -A nixos-fw -p tcp -m state --state NEW --source 16.170.22.162/32 --destination ${netcfg.ip4} --dport 2500 -j ACCEPT
        '';

#  services.spamassassin = {
#    enable = true;
 #   config = ''
 #     rewrite_header Subject [SPAM]
 #     required_score 5.0
#      use_bayes 1
#      bayes_auto_learn 1
#      add_header all Status _YESNO_, score=_SCORE_ required=_REQD_ tests=_TESTS_ autolearn=_AUTOLEARN_ version=_VERSION_
#    '';
#  };

  services.rspamd = {
    enable = true;
    postfix.enable = true;
    locals."milter_headers.conf".text = ''
      use = ["x-spamd-result", "x-spam-status"];
    '';
    extraConfig = ''
      actions {
        reject = null; # Disable rejects, default is 15
        add_header = 6; # Add header when reaching this score
        greylist = 4; # Apply greylisting when reaching this score
      }
    '';
  };

  users.users.postfix = {
    extraGroups = [ "mailer"];
  };

  nixpkgs.config.packageOverrides = pkgs: { postfix = pkgs.postfix.override { withMySQL = true; }; };

  services.postfix = {
    enable = true;
    networks = [
      "127.0.0.0/8"
      "[::ffff:127.0.0.0]/104"
      "[::1]/128 91.228.90.0/24"
      "16.170.22.162/32"
    ];
    domain = config.networking.domain;
    origin = netcfg.hostName + "." + netcfg.domain;
    hostname = config.services.postfix.origin;

    mapFiles.virtual-domains = pkgs.writeText "postfix-virtual-domains" ''
      user = ${config.maildb.user}
      password = ${config.maildb.password}
      hosts = ${config.maildb.host}
      dbname = ${config.maildb.db}
      table = domains
      select_field = name
      where_field = name
    '';
    mapFiles.virtual-mailbox = pkgs.writeText "postfix-virtual-mailbox" ''
      user = ${config.maildb.user}
      password = ${config.maildb.password}
      hosts = ${config.maildb.host}
      dbname = ${config.maildb.db}
      table = users
      select_field = maildir
      where_field = email
    '';
    mapFiles.virtual-alias = pkgs.writeText "postfix-virtual-alias" ''
      user = ${config.maildb.user}
      password = ${config.maildb.password}
      hosts = ${config.maildb.host}
      dbname = ${config.maildb.db}
      table = aliases
      select_field = destination
      where_field = source
    '';


    config = {
      smtp_helo_name = config.services.postfix.origin;

      #smtp_sender_restrictions = "permit_mynetworks,permit_sasl_authenticated,reject";

      smtpd_client_restrictions =  "permit_mynetworks,permit_sasl_authenticated,reject_unknown_client_hostname";
      smtpd_recipient_restrictions = "permit_mynetworks,reject_unauth_destination,reject_invalid_hostname,reject_unauth_pipelining,reject_non_fqdn_sender,reject_unknown_sender_domain,reject_non_fqdn_recipient,reject_unknown_recipient_domain,permit";
      smtpd_sender_restrictions = "permit_mynetworks,reject_unknown_sender_domain,reject_non_fqdn_sender,permit";

      # Virtual
      virtual_uid_maps = "static:1005";
      virtual_gid_maps = "static:994";
      virtual_transport = "virtual";
      virtual_mailbox_base = "/mnt/maildir";
      virtual_mailbox_domains = "mysql:/etc/postfix/virtual-domains";
      virtual_mailbox_maps = "mysql:/etc/postfix/virtual-mailbox";
      virtual_alias_maps = "mysql:/etc/postfix/virtual-alias";

#      #RSPAMD
#      milter_default_action = "accept";
#      milter_protocol = "6";
#      smtpd_milters = "inet:localhost:11332";

      
    };
    masterConfig."2500" = {
      type = "inet";
      private = false;
      command = "smtpd";
#      args = [ "-o content_filter=spamassassin" ];
    };

#    extraMasterConf = ''
#      spamassassin unix -     n       n       -       -       pipe
#        user=mailer argv=${pkgs.spamassassin}/bin/spamc -f -e ${pkgs.postfix}/bin/sendmail -oi -f ''${sender} ''${recipient}
#    '';
    enableSmtp = false;
  };
}


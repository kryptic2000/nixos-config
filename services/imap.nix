{ config, pkgs, netcfg, ... }:

let
  sqlConfig = pkgs.writeTextFile {
    name = "dovecot-sql.conf.ext";
    text = ''
      driver = mysql
      connect = host=${config.maildb.host} dbname=${config.maildb.db} user=${config.maildb.user} password=${config.maildb.password}
      default_pass_scheme = SHA512
      password_query = SELECT email AS user, sha512 AS password FROM users WHERE email='%u'
    '';
  };
in
{

  imports = [
      ../services/acme.nix
  ];

  security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".reloadServices = [
    "dovecot.service"
  ];

  networking.firewall.allowedTCPPorts = [ 143 993 ];

  nixpkgs.config.packageOverrides = super: {
    dovecot = super.dovecot.override { withMySQL = true; };
  };
  services.dovecot2 =  {
    enable = true;
    enablePAM = false;

    #User management
    mailUser = "mailer";
    mailGroup = "mailer";
    createMailUser = false;

    #Virtual
    mailLocation = "maildir:/mnt/maildir/%d/%n";

    #SSL
    sslServerCert = "${config.security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".directory}/fullchain.pem";
    sslServerKey = "${config.security.acme.certs."${netcfg.hostName + "." + netcfg.domain}".directory}/key.pem";


    extraConfig = ''
      passdb {
        driver = sql
        args = ${sqlConfig}
      }
      userdb {
        driver = static
        args = uid=mailer gid=mailer home=/mnt/maildir/%d/%n/
      }
    '';
  };
}


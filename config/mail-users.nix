{ config, lib, pkgs, ... }:

{
  users.groups.mailer = {};
  users.users.mailer = {
    isSystemUser = true;
    uid=1005;
    description = "Mail user with NFS access";
    group = "mailer";
  };
}


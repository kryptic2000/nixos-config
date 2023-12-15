{ config, lib, pkgs, ... }:

{
  users.groups.mailer = {
    gid=994;
  };
  users.users.mailer = {
    isSystemUser = true;
    uid=1005;
    description = "Mail user with NFS access";
    group = "mailer";
  };
}


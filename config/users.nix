{ config, lib, pkgs, ... }:

{
  users.users.adam = {
    isNormalUser = true;
    uid=1000;
    home = "/home/adam";
    extraGroups = [ "wheel"];
    description = "Adam Emtorp";
    openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCwEE2LXnxgKixMVuWptJFDKd4vNnSKE5egc5lb494MUWckvvsjxadG3g9g8F7XamHWmFOHFPdSGuF19atigDOW/dP+tQm+SFQvx2g7c5aPOwow3o5/7jMNU9m7UYk6ZL1QZebADyDdt8pZjQBoxVI55aHKZIR9/Ri/DEthfBbMh8eq8oZAjwCyjvqxPoodMF/ta9Q1767tOBlPZcMuA+tuW+0ffk4o7IiZ2cOlpMCKrE+J/LvRVHkLXHRHWx0oLVZs/ivn9c1W+G8o1HJnQkHdx1NPszMRoFGv5/yMtRm3n8aE6K+M6KLctsi5+67wxrsGqq05FRRC5Q8Tvhlwrnoz adam@persbrandt" ];
  };
}

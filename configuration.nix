{ config, lib, pkgs, ... }:

{
  environment.systemPackages = [ pkgs.git ];

  services.openssh = {
    enable = true;
    settings.PasswordAuthentication = false;
    settings.KbdInteractiveAuthentication = false;
  };

  services.minecraft-server = {
    enable = true;
    eula = true;
    dataDir = "/var/lib/minecraft";
    package = pkgs.papermcServers.papermc-1_21_10;
    declarative = true;
    whitelist = {
      Mr_J420 = "4efaa620-7b3b-41a7-97bd-b57d06dcf2ac";
      Danish_Croissant = "69ee5f49-33b3-4995-b631-4e591bab2787";
    };
  };
  services.minecraft-server.openFirewall = true;
  nixpkgs.config.allowUnfree = true;

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  time.timeZone = "Europe/Oslo";
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = lib.mkForce "no";
    useXkbConfig = true;
  };

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  system.autoUpgrade = {
    enable = true;
    flake = "github:MrProgrammerMan/mc-server";
    dates = "05:00";
  };

  users.users.local = {
    isNormalUser = true;
    extraGroups = [];
    packages = [];
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIILS0uD0BBiO9uS5URL+veW67uvhxQwNAlaLDlKL2w35 cepheus@nixos-laptop"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIA14kI5Eg1fDera5JmCpo2zAnKtvq+dISvZxvyCVdO1z cepheus@desktop"
    ];
    hashedPassword = "!";
  };

  system.stateVersion = "25.05";
}
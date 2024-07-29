{pkgs, ... }:
{
  sops.defaultSopsFile = ../secrets/secrets.yaml;
  sops.defaultSopsFormat = "yaml";

  sops.age.sshKeyPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

  environment.systemPackages = with pkgs; [
    sops
    git
    emacs
    wget
    curl
    htop
    zip
    unzip
    xz
    (ripgrep.override { withPCRE2 = true; })
    fd
    jq
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };

  services.openssh.enable = true;
}

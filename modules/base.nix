{pkgs, ... } @args:
{
  environment.systemPackages = with pkgs; [
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
}

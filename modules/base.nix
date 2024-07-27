{pkgs, ... } @args:
{
  environment.systemPackages = with pkgs; [
    git
    emacs
    wget
    curl
    htop
  ];

  nixpkgs.config.allowUnfree = true;

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
}

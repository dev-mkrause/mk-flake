{} @args:
{
  environment.systemPackages = with pkgs; [
    git
    emacs
    wget
    curl
  ];

  nix.settings = {
    experimental-features = ["nix-command" "flakes"];
  };
}

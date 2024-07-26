{ config, pkgs, ... }:

{
  # Home Manager needs a bit of information about you and the paths it should
  # manage.
  home.username = "mkrause";
  home.homeDirectory = "/home/mkrause";

  # This value determines the Home Manager release that your configuration is
  # compatible with. This helps avoid breakage when a new Home Manager release
  # introduces backwards incompatible changes.
  #
  # You should not change this value, even if you update Home Manager. If you do
  # want to update the value, then make sure to first check the Home Manager
  # release notes.
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = with pkgs; [
    htop
    git
    git-crypt
    inkscape
    gimp
    anki
    signal-desktop
    ardour
    hugo
    nil

    pciutils
    usbutils
    zip
    xz
    unzip
    (ripgrep.override { withPCRE2 = true; })
    jq
    tree
    which
    gnused
    gnutar
    gawk
    zstd
    gnupg

    iosevka-comfy.comfy
  ];
  
  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      ls = "ls --color";
      la = "ls -alh";
    };
  };

  programs.gpg.enable = true;
  programs.emacs.enable = true;
  
  programs.foot = {
    enable = true;
    settings.main = {
      font = "Iosevka Comfy:size=9";
      dpi-aware = "yes";
    };
  };

  programs.firefox = {
    enable = true;
    languagePacks = ["en-US" "de-DE"];
  };

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  home.sessionVariables = {
    EDITOR = "emacsclient -tca emacs";
    VISUAL = "emacsclient -ca emacs";
  };

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;
}

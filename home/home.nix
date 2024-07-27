{ config, lib, pkgs, ... }:

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
    portfolio
    
    nil # Nix language server

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
  
  stylix.enable = true;
  stylix.autoEnable = true;

  stylix.base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
  stylix.image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/de03e887f03037e7e781a678b57fdae603c9ca20/wallpapers/nix-wallpaper-binary-black_8k.png";
    sha256 = "1dkw7vn3m412bx1q7qwbk1vv4bkjyfhj77li4cga6xm66nzj049k";
  };

  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings =  {
      mainBar = {
        layer = "top";
        position = "top";
        modules-left = [
          "sway/workspaces"
          "custom/spacer"
          "sway/window"
        ];
        modules-center = [
          "clock"
        ];
        modules-right = [
          "pulseaudio"
          "memory"
          "cpu"
          "battery"
          "disk"
          "tray"
        ];
        "custom/spacer" = {
          format = "|";
          tooltip = false;
        };
        "sway/workspaces" = {
          disable-scroll = true;
          format = "{name}";
        };
        "sway/window" = {
          max-length = 50;
          icon = true;
        };
        clock = {
          format = "{:%a   %d-%m-%Y  %R}";
          tooltip = false;
        };
        pulseaudio = {
          format = " {volume:2}%";
          format-bluetooth = " {volume}%";
          format-muted = "MUTE";
          format-icons = {
            headphones = "";
          };
          scroll-step = 5;
          on-click = "pamixer -t";
          on-click-right = "pavucontrol";
        };
        memory = {
          interval = 5;
          format = " {}%";
        };
        cpu = {
          interval = 5;
          format = " {usage:2}%";
        };
        battery = {
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
          ];
        };
        disk = {
          interval = 5;
          format = " {percentage_used:2}%";
          path = "/";
        };
        tray = {
          icon-size = 20;
        };
      };
    };
  };

  wayland.windowManager.sway = {
    enable = true;
    config = rec {
      bars = [];
      modifier = "Mod4";
      terminal = "foot";

      input = {
        "type:keyboard" = {
          xkb_layout = "de";
          xkb_variant = "nodeadkeys";
          xkb_options = "ctrl:nocaps";
        };

        "type:touchpad" = {
          dwt = "enabled";
          tap = "enabled";
          natural_scroll = "enabled";
          middle_emulation = "enabled";
        };
      };

      keybindings = lib.mkOptionDefault {
        "${modifier}+d" = "exec ${pkgs.rofi-wayland}/bin/rofi -show run";
      };
    };
  };

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
  
  programs.foot.enable = true;

  programs.firefox = {
    enable = true;
    # languagePacks = ["en-US" "de-DE"];
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

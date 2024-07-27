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
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 35;
        margin = "7 7 3 7";
        spacing = 2;

        modules-left = [ "custom/os" "battery" "backlight" "pulseaudio" "cpu" "memory" ];
        modules-center = [ "sway/workspaces" ];
        modules-right = [ "idle_inhibitor" "tray" "clock" ];

        "custom/os" = {
          "format" = " {} ";
          "exec" = ''echo "" '';
          "interval" = "once";
        };
        "sway/workspaces" = {
          "format" = "{icon}";
          "format-icons" = {
            "1" = "󱚌";
            "2" = "󰖟";
            "3" = "";
            "4" = "󰎄";
            "5" = "󰋩";
            "6" = "";
            "7" = "󰄖";
            "8" = "󰑴";
            "9" = "󱎓";
          };
        };

        "idle_inhibitor" = {
          format = "{icon}";
          format-icons = {
            activated = "󰅶";
            deactivated = "󰾪";
          };
        };
        tray = {
          #"icon-size" = 21;
          "spacing" = 10;
        };
        clock = {
          "interval" = 1;
          "format" = "{:%a %d.%m.%Y %I:%M:%S %p}";
          "timezone" = "Europe/Berlin";
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        cpu = {
          "format" = "{usage}% ";
        };
        memory = { "format" = "{}% "; };
        backlight = {
          "format" = "{percent}% {icon}";
          "format-icons" = [ "" "" "" "" "" "" "" "" "" ];
        };
        battery = {
          "states" = {
            "good" = 95;
            "warning" = 30;
            "critical" = 15;
          };
          "format" = "{capacity}% {icon}";
          "format-charging" = "{capacity}% ";
          "format-plugged" = "{capacity}% ";
          #"format-good" = ""; # An empty format will hide the module
          #"format-full" = "";
          "format-icons" = [ "" "" "" "" "" ];
        };
        pulseaudio = {
          "scroll-step" = 1;
          "format" = "{volume}% {icon}  {format_source}";
          "format-bluetooth" = "{volume}% {icon}  {format_source}";
          "format-bluetooth-muted" = "󰸈 {icon}  {format_source}";
          "format-muted" = "󰸈 {format_source}";
          "format-source" = "{volume}% ";
          "format-source-muted" = " ";
          "format-icons" = {
            "headphone" = "";
            "hands-free" = "";
            "headset" = "";
            "phone" = "";
            "portable" = "";
            "car" = "";
            "default" = [ "" "" "" ];
          };
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
          "${modifier}+p" = "exec $VISUAL";
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

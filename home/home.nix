{
  config,
  lib,
  pkgs,
  ...
}: {
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
    sops
    age
    inkscape
    gimp
    anki
    signal-desktop
    ardour
    hugo
    portfolio
    discord
    onlyoffice-bin
    iosevka-comfy.comfy
    nil # Nix language server

    pciutils
    usbutils
    zip
    xz
    unzip
    (ripgrep.override {withPCRE2 = true;})
    fd
    jq
    tree
    which
    gnused
    gnutar
    gawk
    zstd
    gnupg
  ];

  stylix = {
    enable = true;
    autoEnable = true;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-hard.yaml";
    polarity = "dark";
    image = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/lunik1/nixos-logo-gruvbox-wallpaper/master/png/gruvbox-dark-blue.png";
      sha256 = "1jrmdhlcnmqkrdzylpq6kv9m3qsl317af3g66wf9lm3mz6xd6dzs";
    };

    fonts = {
      serif = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };

      sansSerif = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };

      monospace = {
        package = pkgs.iosevka-comfy.comfy;
        name = "Iosevka Comfy";
      };
    };
  };

  stylix.targets.emacs.enable = false;
  stylix.targets.fuzzel.enable = false;

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

        modules-left = ["custom/os" "battery" "backlight" "pulseaudio" "cpu" "memory"];
        modules-center = ["sway/workspaces"];
        modules-right = ["idle_inhibitor" "tray" "clock"];

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
          "format" = "{:%a %d.%m.%Y %H:%M:%S}";
          "timezone" = "Europe/Berlin";
          "tooltip-format" = ''
            <big>{:%Y %B}</big>
            <tt><small>{calendar}</small></tt>'';
        };
        cpu = {
          "format" = "{usage}% ";
        };
        memory = {"format" = "{}% ";};
        backlight = {
          "format" = "{percent}% {icon}";
          "format-icons" = ["" "" "" "" "" "" "" "" ""];
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
          "format-icons" = ["" "" "" "" ""];
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
            "default" = ["" "" ""];
          };
        };
      };
    };
  };

  programs.swaylock.enable = true;
  services.swayidle = {
    enable = true;
    timeouts = [
      {
        timeout = 300;
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock";
      }
    ];
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
        "${modifier}+d" = "exec fuzzel";
        "${modifier}+p" = "exec $VISUAL";
        "${modifier}+o" = "exec firefox";
        "${modifier}+Print" = "exec flameshot gui";
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

  services.gnome-keyring.enable = true;

  services.udiskie.enable = true;
  services.udiskie.tray = "always";
  programs.fuzzel.enable = true;

  programs.fuzzel.settings = {
    main = {
      font = config.stylix.fonts.serif.name + ":size=20";
      dpi-aware = "no";
      show-actions = "yes";
      terminal = "${pkgs.foot}/bin/foot";
    };
    colors = {
      background = config.lib.stylix.colors.base00 + "bf";
      text = config.lib.stylix.colors.base07 + "ff";
      match = config.lib.stylix.colors.base05 + "ff";
      selection = config.lib.stylix.colors.base08 + "ff";
      selection-text = config.lib.stylix.colors.base00 + "ff";
      selection-match = config.lib.stylix.colors.base05 + "ff";
      border = config.lib.stylix.colors.base08 + "ff";
    };
    border = {
      width = 3;
      radius = 7;
    };
  };

  programs.gpg.enable = true;
  programs.emacs.enable = true;
  services.emacs.enable = true; # Emacs daemon

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

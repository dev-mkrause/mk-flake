{pkgs, config, ...}:
{
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

    # Select internationalisation properties.
  i18n.defaultLocale = "de_DE.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
  };

  # Configure console keymap
  console.keyMap = "de-latin1-nodeadkeys";

  # Enable sound with pipewire.
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mkrause = {
    isNormalUser = true;
    description = "Marvin Krause";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
      emacs
      git
      flameshot
      foot
      rofi
      dunst
      libnotify
      nh
      waybar
    ];
  };

  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ]; 

  stylix.enable = true;
  stylix.autoEnable = true;
  stylix.image = pkgs.fetchurl {
    url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/de03e887f03037e7e781a678b57fdae603c9ca20/wallpapers/nix-wallpaper-binary-black_8k.png";
    sha256 = "1dkw7vn3m412bx1q7qwbk1vv4bkjyfhj77li4cga6xm66nzj049k";
  };

  fonts.packages = with pkgs; [iosevka-comfy.comfy];

  environment.systemPackages = with pkgs;
    [ wayland waydroid
      (sddm-chili-theme.override {
        themeConfig = {
          background = config.stylix.image;
          ScreenWidth = 1920;
          ScreenHeight = 1080;
          blur = true;
          recursiveBlurLoops = 3;
          recursiveBlurRadius = 5;
        };})
    ];

  services.xserver = {
    enable = true;
    xkb = {
      layout = "de";
      variant = "nodeadkeys";
      options = "ctrl:nocaps";
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      enableHidpi = true;
      theme = "chili";
    };
  };

  security = {
    pam.services.login.enableGnomeKeyring = true;
  };

  services.gnome.gnome-keyring.enable = true;
  
  programs.sway.enable = true;

  programs.firefox.enable = true;
  programs.steam.enable = true;
  
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };
}

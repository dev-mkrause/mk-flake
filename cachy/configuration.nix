{ ... }@inputs:

{
  imports =
    [ ./hardware-configuration.nix
      ../modules/base.nix
      ../modules/desktop.nix
    ];

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "cachy"; # Define your hostname.

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.avahi = {
    enable = true;
    nssmdns = true;

    publish = {
      enable = true;
      addresses = true;
      userServices = true;
    };
  };

  # Tika and Gotenberg are not yet in nixpkgs stable
  services.paperless = {
    enable = true;
    consumptionDirIsPublic = true;
    address = "0.0.0.0";
    settings = {
      PAPERLESS_OCR_LANGUAGE = "deu";
      PAPERLESS_CONSUMER_ENABLE_BARCODES = "true";
      PAPERLESS_CONSUMER_ENABLE_ASN_BARCODE = "true";
      PAPERLESS_CONSUMER_BARCODE_SCANNER = "ZXING";
      
      PAPERLESS_FILENAME_FORMAT = "{owner_username}/{created_year}/{correspondent}/{title}";
    };
  };
    
  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.05"; # Did you read the comment?

}

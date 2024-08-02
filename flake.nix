{
  description = "Marvin's personal Nix flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.05";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "github:danth/stylix";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = {
    self,
    nixpkgs,
    stylix,
    home-manager,
    sops-nix,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    pkgs = nixpkgs.legacyPackages.${system};
  in {
    checks = {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          alejandra.enable = true;
          typos.enable = true;
        };
      };
    };

    devShells.${system}.default = pkgs.mkShell {
      inherit (self.checks.pre-commit-check) shellHook;
      buildInputs = self.checks.pre-commit-check.enabledPackages;
      packages = with pkgs; [alejandra];
    };

    nixosConfigurations.cachy = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./cachy/configuration.nix
        ./cachy/hardware-configuration.nix
        stylix.nixosModules.stylix
        sops-nix.nixosModules.sops
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
          home-manager.users.mkrause = import home/home.nix;
        }
      ];
    };

    homeConfigurations."mkrause" = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;
      modules = [./home/home.nix stylix.homeManagerModules.stylix];

      # Optionally use extraSpecialArgs
      # to pass through arguments to home.nix
    };
  };
}

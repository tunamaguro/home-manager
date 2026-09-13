{
  description = "Home Manager configuration of tunamaguro";

  inputs = {
    # Specify the source of Home Manager and Nixpkgs.
    nixpkgs.url = "github:nixos/nixpkgs/26.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/release-26.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      nixpkgs-unstable,
      home-manager,
      ...
    }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
      pkgsUnstable = nixpkgs-unstable.legacyPackages.${system};

    in
    {
      formatter.${system} = pkgs.treefmt.withConfig {
        runtimeInputs = with pkgs; [
          nixfmt
          stylua
          (mdformat.withPlugins (ps: [ ps.mdformat-gfm ]))
        ];

        settings = {
          tree-root-file = "flake.nix";

          formatter = {
            nixfmt = {
              command = "nixfmt";
              includes = [ "*.nix" ];
            };

            stylua = {
              command = "stylua";
              includes = [ "*.lua" ];
            };

            mdformat = {
              command = "mdformat";
              includes = [ "*.md" ];
            };
          };
        };
      };
      homeConfigurations."tunamaguro" = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        # Specify your home configuration modules here, for example,
        # the path to your home.nix.
        modules = [ ./home.nix ];

        # Optionally use extraSpecialArgs
        # to pass through arguments to home.nix
        extraSpecialArgs = {
          inherit pkgsUnstable;
        };
      };
    };
}

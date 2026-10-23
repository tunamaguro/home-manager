{
  config,
  lib,
  pkgs,
  ...
}:
let
  dsh-src = pkgs.fetchFromGitHub {
    owner = "shiguredo";
    repo = "deepseek-harness";
    rev = "4a768fde9e1712e76c4f6a8f51b474233be2136b";
    hash = "sha256-FdUmwoGa7nkearB3WC2Jf96ujO6OFM/QgXMo/7tShw0=";
  };
  dsh = pkgs.callPackage ./package.nix {
    harness-src = dsh-src;
    pnpmDepsHash = "sha256-6yjxQj/+/Din/UJWjQy6DcgZJs7ldf+XO2zhDRZFm0s=";
  };
  dshWrapper =
    pkgs.runCommand "dsh"
      {
        nativeBuildInputs = [ pkgs.makeWrapper ];
        inherit (dsh) meta;
      }
      ''
        makeWrapper ${lib.getExe dsh} "$out/bin/dsh" \
          --set DSH_HOME ${lib.escapeShellArg "${config.xdg.dataHome}/dsh"} \
          --prefix PATH : ${lib.makeBinPath [ dsh.pnpm ]}
      '';

  # Fetch the private repository using the current user's Git credentials.
  chatgpt-src = builtins.fetchGit {
    url = "https://github.com/tunamaguro/dsh-chatgpt-subscription.git";
    ref = "main";
    rev = "c118bb35b1e605638020301f2a7f90268ca6ccac";
  };
  dshChatgptPlan = pkgs.callPackage "${chatgpt-src}/package.nix" { };
in
{
  home.packages = [ dshWrapper ];

  home.activation.installDshChatgptPlan =
    lib.hm.dag.entryAfter
      [
        "writeBoundary"
        "installPackages"
      ]
      ''
        for profile in web headless; do
          run ${lib.getExe dshWrapper} plugin --profile "$profile" add \
            --offline --ignore-scripts ${lib.escapeShellArg dshChatgptPlan.tarball}
        done
      '';
}

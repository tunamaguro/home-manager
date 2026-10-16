{
  lib,
  stdenv,
  nodejs_24,
  pnpm_11,
  fetchPnpmDeps,
  pnpmConfigHook,
  makeWrapper,
  bashInteractive,
  harness-src,
  pnpmDepsHash ? lib.fakeHash,
}:
let
pnpm = pnpm_11.override {
    version = "11.28.5";
    hash = "sha256-HvTkR6aHE2VgZPPxdMD0RxmWCgQ6P+IpkWnQjPHb+O4=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "dsh";
  version = (lib.importJSON "${harness-src}/package.json").version;
  src = harness-src;

  pnpmDeps = fetchPnpmDeps {
    inherit (finalAttrs) pname version src;
    pnpm = pnpm;
    fetcherVersion = 4;
    hash = pnpmDepsHash;
  };

  nativeBuildInputs = [
    nodejs_24
    pnpm
    pnpmConfigHook
    makeWrapper
  ];

  # Let node-gyp use Nix's headers without downloading another Node release.
  npm_config_nodedir = "${nodejs_24}";

  # GitHub archives have no .git directory. Pin harness-src.rev to a commit SHA.
  DSH_CLIENT_COMMIT_HASH = harness-src.rev;

  postPatch = ''
    substituteInPlace packages/terminal/terminal-bash/src/config.ts \
      --replace-fail "'/bin/bash'" "'${lib.getExe bashInteractive}'"

    # Nix's Node build is incompatible with the addon's V8 machine-code lookup.
    # This source is bundled into both app-boot and its resolution worker.
    substituteInPlace packages/boot/app-boot/src/profile-resolution/resolver.ts \
      --replace-fail "require('node-addon-require-builtin')" \
        "{ requireBuiltin: require }"
  '';

  buildPhase = ''
    runHook preBuild

    # pnpmConfigHook installs dependencies with --ignore-scripts.
    pnpm rebuild esbuild
    pnpm run build

    runHook postBuild
  '';

  installPhase = ''
    runHook preInstall

    # Copy the built CLI and its runtime closure, including workspace packages.
    # Lifecycle scripts remain enabled here so native dependencies are prepared.
    pnpm --filter @deepseek-ai/dsh --prod deploy --offline --legacy "$out/lib/dsh"

    makeWrapper ${lib.getExe nodejs_24} "$out/bin/dsh" \
      --argv0 dsh \
      --add-flags "--expose-internals" \
      --add-flags "$out/lib/dsh/lib/bin.js"

    runHook postInstall
  '';

  doInstallCheck = true;
  installCheckPhase = ''
    runHook preInstallCheck
    "$out/bin/dsh" --version
    "$out/bin/dsh" --help > /dev/null
    runHook postInstallCheck
  '';

  meta = {
    description = "Open-source agent harness developed by DeepSeek AI";
    homepage = "https://github.com/deepseek-ai/deepseek-harness";
    license = lib.licenses.mit;
    mainProgram = "dsh";
    platforms = lib.platforms.linux ++ lib.platforms.darwin;
  };
})

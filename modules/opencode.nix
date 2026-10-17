{ pkgsUnstable, ... }:
{
  programs.opencode = {
    enable = true;
    package = pkgsUnstable.opencode;

    # Configure providers, models, permissions, MCP servers, and plugins here.
    settings = {
      # Update OpenCode through the pinned nixpkgs input.
      autoupdate = false;
      lsp = true;
    };

    # TUI settings use a separate tui.json file.
    tui = {
      theme = "system";
    };
  };
}

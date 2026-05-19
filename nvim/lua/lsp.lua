vim.diagnostic.config({
  virtual_text = true,
})

vim.lsp.config("lua_ls", {
  on_init = function(client)
    local root = client.workspace_folders and client.workspace_folders[1] and client.workspace_folders[1].name
    if root == nil then
      return
    end

    local name = vim.fs.basename(root)
    local parent = vim.fs.basename(vim.fs.dirname(root))
    if parent ~= "home-manager" or (name ~= "nvim" and name ~= "neovim") then
      return
    end

    client.config.settings = client.config.settings or {}
    client.config.settings.Lua = vim.tbl_deep_extend("force", client.config.settings.Lua or {}, {
      runtime = {
        version = "LuaJIT",
      },
      workspace = {
        checkThirdParty = "Disable",
        library = vim.list_extend(vim.api.nvim_get_runtime_file("lua", true), {
          "${3rd}/luv/library",
        }),
      },
    })
  end,
})

vim.lsp.enable({
  "rust_analyzer",
  "lua_ls",
  "nixd",
})

local lsp_group = vim.api.nvim_create_augroup("user-lsp", { clear = true })
local format_group = vim.api.nvim_create_augroup("user-lsp-format", { clear = true })

vim.api.nvim_create_autocmd("LspAttach", {
  group = lsp_group,
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client == nil then
      return
    end

    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, {
        buffer = event.buf,
        silent = true,
        desc = desc,
      })
    end

    -- Do not duplicate Nvim's built-in LSP/diagnostic keymaps.
    -- Nvim 0.12 provides gra/gri/grn/grr/grt/grx/gO, K, [d, ]d, [D, ]D, and <C-w>d.
    map("n", "gd", vim.lsp.buf.definition, "LSP go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP go to declaration")

    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = event.buf, async = false, timeout_ms = 1000 })
    end, "LSP format buffer")
    map("n", "<leader>lq", vim.diagnostic.setqflist, "LSP diagnostics to quickfix")

    if client:supports_method("textDocument/inlayHint") then
      vim.lsp.inlay_hint.enable(true, { bufnr = event.buf })
    end

    if client:supports_method("textDocument/formatting") then
      vim.api.nvim_clear_autocmds({ group = format_group, buffer = event.buf })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = format_group,
        buffer = event.buf,
        callback = function()
          vim.lsp.buf.format({ bufnr = event.buf, async = false, timeout_ms = 1000 })
        end,
      })
    end
  end,
})

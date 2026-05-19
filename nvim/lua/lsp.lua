vim.diagnostic.config({
  virtual_text = true,
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

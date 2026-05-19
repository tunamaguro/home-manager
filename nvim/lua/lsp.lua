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

    map("n", "gd", vim.lsp.buf.definition, "LSP go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "LSP go to declaration")
    map("n", "K", vim.lsp.buf.hover, "LSP hover documentation")

    map("n", "<leader>la", vim.lsp.buf.code_action, "LSP code action")
    map("n", "<leader>lf", function()
      vim.lsp.buf.format({ bufnr = event.buf, async = false, timeout_ms = 1000 })
    end, "LSP format buffer")
    map("n", "<leader>li", vim.lsp.buf.implementation, "LSP implementation")
    map("n", "<leader>lq", vim.diagnostic.setqflist, "LSP diagnostics to quickfix")
    map("n", "<leader>lr", vim.lsp.buf.rename, "LSP rename")
    map("n", "<leader>lR", vim.lsp.buf.references, "LSP references")
    map("n", "<leader>lt", vim.lsp.buf.type_definition, "LSP type definition")

    map("n", "[d", function()
      vim.diagnostic.jump({ count = -1, float = true })
    end, "Previous diagnostic")
    map("n", "]d", function()
      vim.diagnostic.jump({ count = 1, float = true })
    end, "Next diagnostic")

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

vim.diagnostic.config({
  virtual_text = true,
})

local function normalize_path(path)
  return vim.fs.normalize(path):gsub("/$", "")
end

local function is_subpath(path, root)
  local normalized_path = normalize_path(path)
  local normalized_root = normalize_path(root)

  return normalized_path == normalized_root or vim.startswith(normalized_path, normalized_root .. "/")
end

local function is_home_manager_neovim_root(root_dir)
  if root_dir == nil or root_dir == "" then
    return false
  end

  local root = normalize_path(root_dir)
  local dirname = vim.fn.fnamemodify(root, ":t")
  local parent = vim.fs.dirname(root)

  return (dirname == "nvim" or dirname == "neovim") and vim.fn.fnamemodify(parent, ":t") == "home-manager"
end

local function lua_root_dir(bufnr, on_dir)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == "" then
    on_dir(vim.fn.getcwd())
    return
  end

  local file = normalize_path(filename)
  local file_dir = vim.fs.dirname(file)
  local git_dir = vim.fs.find(".git", {
    path = file_dir,
    upward = true,
    type = "directory",
  })[1]
  local root = git_dir and vim.fs.dirname(git_dir) or file_dir

  if vim.fn.fnamemodify(root, ":t") == "home-manager" then
    for _, dirname in ipairs({ "neovim", "nvim" }) do
      local neovim_root = normalize_path(root .. "/" .. dirname)
      if is_subpath(file, neovim_root) then
        on_dir(neovim_root)
        return
      end
    end
  end

  on_dir(root)
end

vim.lsp.config("lua_ls", {
  root_dir = lua_root_dir,
  before_init = function(_, config)
    if not is_home_manager_neovim_root(config.root_dir) then
      return
    end

    config.settings = vim.tbl_deep_extend("force", config.settings or {}, {
      Lua = {
        runtime = {
          version = "LuaJIT",
        },
        diagnostics = {
          globals = { "vim" },
        },
        workspace = {
          checkThirdParty = "Disable",
          library = vim.api.nvim_get_runtime_file("", true),
        },
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

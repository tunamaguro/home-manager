vim.keymap.set("i", "jk", "<Esc>", { silent = true })

local function is_normal_listed_buffer(bufnr)
  if not vim.api.nvim_buf_is_valid(bufnr) or not vim.api.nvim_buf_is_loaded(bufnr) then
    return false
  end

  if not vim.bo[bufnr].buflisted then
    return false
  end

  if vim.bo[bufnr].filetype == "NvimTree" then
    return false
  end

  return true
end

local function replacement_buffer(excluded_bufnr)
  local alternate = vim.fn.bufnr("#")
  if alternate ~= excluded_bufnr and is_normal_listed_buffer(alternate) then
    return alternate
  end

  for _, buffer in ipairs(vim.fn.getbufinfo({ buflisted = 1 })) do
    if buffer.bufnr ~= excluded_bufnr and is_normal_listed_buffer(buffer.bufnr) then
      return buffer.bufnr
    end
  end

  return nil
end

local function safe_bdelete(opts)
  local target = tonumber(opts.args)
  if target == nil then
    target = vim.api.nvim_get_current_buf()
  end

  if not vim.api.nvim_buf_is_valid(target) then
    return
  end

  if vim.bo[target].filetype == "NvimTree" then
    vim.cmd("NvimTreeClose")
    return
  end

  if target == vim.api.nvim_get_current_buf() then
    local replacement = replacement_buffer(target)
    if replacement ~= nil then
      vim.cmd("buffer " .. replacement)
    else
      vim.cmd("enew")
    end
  end

  local command = opts.bang and "bdelete!" or "confirm bdelete"
  local ok, err = pcall(vim.cmd, command .. " " .. target)
  if not ok then
    vim.notify(err, vim.log.levels.WARN)
  end
end

vim.api.nvim_create_user_command("Bdelete", safe_bdelete, {
  bang = true,
  nargs = "?",
  complete = "buffer",
})

vim.cmd([[
cnoreabbrev <expr> bd getcmdtype() ==# ':' && getcmdline() ==# 'bd' ? 'Bdelete' : 'bd'
cnoreabbrev <expr> bdelete getcmdtype() ==# ':' && getcmdline() ==# 'bdelete' ? 'Bdelete' : 'bdelete'
]])

vim.keymap.set("n", "<leader>bd", "<cmd>Bdelete<CR>", {
  desc = "Delete current buffer",
  silent = true,
})

vim.keymap.set("n", "<leader>bD", "<cmd>Bdelete!<CR>", {
  desc = "Force delete current buffer",
  silent = true,
})

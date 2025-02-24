local M = {} -- Plugin module

-- Default options
M.opts = {
  enable_autocmd = true, -- Enable autocommand-based autosave
  enable_timer = false, -- Enable periodic autosave
  interval = 5000, -- Autosave interval in milliseconds (default: 5s)
  excluded_filetypes = { markdown = true, gitcommit = true }, -- Filetypes to exclude
}

-- Autosave function
local function autosave()
  -- Check if buffer is modified, not read-only, and not excluded
  if vim.bo.readonly or M.opts.excluded_filetypes[vim.bo.filetype] then
    return
  end

  if vim.bo.modified then
    vim.cmd("silent! write")
  end
end

-- Function to start periodic autosave
function M.start_timer()
  if not M.opts.enable_timer then
    return
  end

  local function timer_callback()
    autosave()
    vim.defer_fn(timer_callback, M.opts.interval) -- Reschedule
  end

  vim.defer_fn(timer_callback, M.opts.interval) -- Start loop
end

-- Function to enable autocommand-based autosave
function M.setup_autocmd()
  if not M.opts.enable_autocmd then
    return
  end

  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = autosave,
  })
end

-- Plugin setup function (called by the user)
function M.setup(user_opts)
  M.opts = vim.tbl_extend("force", M.opts, user_opts or {}) -- Merge user options

  -- Setup autosave based on user's choice
  M.setup_autocmd()
  M.start_timer()
end

return M

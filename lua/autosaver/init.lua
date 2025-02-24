local M = {} -- Plugin module

-- Default options
M.opts = {
  enabled = true,
  excluded_filetypes = { markdown = true, gitcommit = true }, -- Filetypes to exclude
}

M.enabled = true -- Autosave is enabled by default

-- Autosave function
local function autosave()
  if not M.enabled then
    return -- Do nothing if autosave is disabled
  end

  -- Check if buffer is modified, not read-only, and not excluded
  if vim.bo.readonly or M.opts.excluded_filetypes[vim.bo.filetype] then
    return
  end

  if vim.bo.modified then
    vim.cmd("silent! write")
  end
end

-- Function to enable autocommand-based autosave
function M.setup_autosaver()
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged" }, {
    pattern = "*",
    callback = autosave,
  })
end

-- Function to toggle autosave
function M.toggle()
  M.enabled = not M.enabled
  local status = M.enabled and "enabled" or "disabled"
  vim.notify("Autosave " .. status, vim.log.levels.INFO, { title = "Autosaver", timeout = 1000 })
end

function M.setup_command()
  vim.api.nvim_create_user_command("AutosaveToggle", function()
    M.toggle()
  end, { desc = "Toggle autosave on/off" })
end

-- Plugin setup function (called by the user)
function M.setup(user_opts)
  M.opts = vim.tbl_extend("force", M.opts, user_opts or {}) -- Merge user options
  M.enabled = user_opts.enabled
  -- Setup autosave
  M.setup_autosaver()
  M.setup_command()
end

return M

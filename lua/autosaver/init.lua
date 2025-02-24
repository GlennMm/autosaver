local M = {}

M.opts = {
  excluded_filetypes = { markdown = true, gitcommit = true }, -- Filetypes to exclude
}

M.enabled = true -- Autosave is enabled by default

local autosave_state_file = vim.fn.stdpath("data") .. "/autosave_state.txt" -- Path to store state

-- Function to save state
local function save_state()
  local state = M.enabled and "1" or "0"
  vim.fn.writefile({ state }, autosave_state_file)
end

-- Function to load state
local function load_state()
  if vim.fn.filereadable(autosave_state_file) == 1 then
    local state = vim.fn.readfile(autosave_state_file)[1]
    M.enabled = state == "1"
  else
    M.enabled = true -- default if no state file exists
  end
end

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
  save_state() -- Persist the new state
  local status = M.enabled and "enabled" or "disabled"
  vim.notify("Autosave " .. status, vim.log.levels.INFO, { title = "Autosaver", timeout = 1000 })
end

-- Register the :AutosaveToggle command
function M.setup_command()
  vim.api.nvim_create_user_command("AutosaveToggle", function()
    M.toggle()
  end, { desc = "Toggle autosave on/off" })
end

-- Plugin setup function (called by the user)
function M.setup(user_opts)
  M.opts = vim.tbl_extend("force", M.opts, user_opts or {}) -- Merge user options (without enabled)
  load_state() -- Load persisted state
  M.setup_autosaver()
  M.setup_command()
end

return M

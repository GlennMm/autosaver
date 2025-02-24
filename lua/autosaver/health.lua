local function check_setup()
  local err_count = 0
  -- Check for a minimum Neovim version (0.5 or newer)
  if vim.fn.has("nvim-0.5") == 0 then
    vim.health.error("Neovim 0.5 or newer is required for autosaver")
    err_count = err_count + 1
  else
    vim.health.ok("Neovim version is sufficient")
  end

  -- Verify that the autosaver module can be loaded
  local k, err = pcall(require, "autosaver")
  if not k then
    err_count = err_count + 1
    vim.health.error("Failed to load autosaver module: " .. (err or "unknown error"))
  else
    vim.health.ok("autosaver module loaded successfully")
  end
 
  if err_count == 0 then
    return true
  else
    return false
  end

end

local M = {}
M.check = function()
  vim.health.start("foo report")
  -- make sure setup function parameters are ok
  if check_setup() then
    vim.health.ok("Setup is correct")
  else
    vim.health.error("Setup is incorrect")
  end
  -- do some more checking
  -- ...
end
return M

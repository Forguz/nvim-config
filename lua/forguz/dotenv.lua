local M = {}

function M.setup(file_path)
  -- Default to .env in the current working directory if no path provided
  local default_path = vim.fn.stdpath("config") .. "/.env"
  local path = file_path or default_path

  local f = io.open(path, "r")
  if not f then
    -- Optional: Notify if .env is missing, or just return silently
    -- vim.notify(".env file not found at: " .. path, vim.log.levels.WARN)
    return
  end

  for line in f:lines() do
    -- Ignore comments (#) and empty lines
    if not line:match("^#") and line:match("=") then
      -- Capture KEY and VALUE
      local key, value = line:match("^([%w_]+)=[\"']?(.-)[\"']?$")

      if key and value then
        -- VITAL CHANGE: Use vim.env instead of _G
        -- This allows os.getenv() to read it later!
        vim.env[key] = value
      end
    end
  end
  f:close()
end

return M

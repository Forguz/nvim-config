local dotenv = {}
-- Function to load .env file
function dotenv.load_env(file)
  local f = io.open(file or ".env", "r")
  if not f then return end

  for line in f:lines() do
    -- Ignore comments and empty lines
    if not line:match("^#") and line:match("=") then
      -- Capture KEY and VALUE (handling quotes optionally)
      local key, value = line:match("^([%w_]+)=[\"']?(.-)[\"']?$")
      if key and value then
        -- Method A: Set it in the Lua environment (only visible to Lua)
        _G[key] = value

        -- Method B: Only if you are on Linux/Mac and want os.getenv to see it:
        -- Lua 5.1/JIT doesn't support writing to env natively easily without C libs,
        -- so usually we just store it in a table or _G.
      end
    end
  end
  f:close()
end

return dotenv

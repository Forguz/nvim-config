--godot.lua
local ok, godot = pcall(require, "godot")
if not ok then
  return
end


-- default config
local config = {
  bin = "godot",
  -- 	gui = {
  -- 		console_config = @config for vim.api.nvim_open_win
  -- 	},
}

godot.setup(config)

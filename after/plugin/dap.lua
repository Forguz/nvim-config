local dap = require('dap');

dap.adapters.godot = {
  type = "server",
  host = '127.0.0.1',
  port = 6006,
}

dap.configurations.gdscript = {
  {
    type = "godot",
    request = "launch",
    name = "Launch scene",
    project = "${workspaceFolder}",
    editor_path = "<path>",
    fixed_fps = 60,
    launch_scene = true,
    disabled_vsync = false,
  }
}

dap.adapters.codelldb = {
  type = 'server',
  command = '$HOME/.local/share/nvim/mason/bin/codelldb',
  executable = {
    -- CHANGE THIS to your path!
    command = '/absolute/path/to/codelldb/extension/adapter/codelldb',
    args = { "--port", "${port}" },

    -- On windows you may have to uncomment this:
    -- detached = false,
  }
}

dap.configurations.cpp = {
  {
    name = "Launch file",
    type = "codelldb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    cwd = '${workspaceFolder}',
    stopOnEntry = false,
  },
}
dap.configurations.c = dap.configurations.cpp

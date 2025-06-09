return {
    'mfussenegger/nvim-lint',
    ft = {
        'javascript',
        'javascriptreact',
        'typescript',
        'typescriptreact',
    },
    opts = {
        linters = {
            eslint = {
                args = {
                    '--no-warn-ignored', -- <-- this is the key argument
                    '--format',
                    'json',
                    '--stdin',
                    '--stdin-filename',
                    function()
                        return vim.api.nvim_buf_get_name(0)
                    end,
                }
            }
        }
    },
    config = function(_, opts)
        local lint = require("lint")
        local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true });

        local function has_eslint_config()
            local configs = { '.eslintrc.js', '.eslintrc.json', '.eslintrc.yml', 'eslint.config.js' }
            for _, config in ipairs(configs) do
                if vim.fn.filereadable(config) == 1 then
                    return true
                end
            end
            return false
        end

        local function find_nearest_node_modules_dir()
            -- current buffer dir
            local current_dir = vim.fn.expand('%:p:h')
            while current_dir ~= "/" do
                if vim.fn.isdirectory(current_dir .. "/node_modules") == 1 then
                    return current_dir
                end
                current_dir = vim.fn.fnamemodify(current_dir, ":h")
            end
            return nil
        end

        if has_eslint_config() then
            lint.linters_by_ft = {
                javascript = { 'eslint_d' },
                javascriptreact = { 'eslint_d' },
                typescript = { 'eslint_d' },
                typescriptreact = { 'eslint_d' },
            }
        end

        vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
            group = lint_augroup,
            callback = function()
                local ft = vim.bo.filetype
                local js_types = { "javascript", "typescript", "javascriptreact", "typescriptreact" }
                if not vim.tbl_contains(js_types, ft) then
                    lint.try_lint()
                    return
                end
                local original_cwd = vim.fn.getcwd()
                local node_modules_dir = find_nearest_node_modules_dir()
                if node_modules_dir then
                    vim.cmd("cd " .. node_modules_dir)
                end
                lint.try_lint()
                vim.cmd("cd " .. original_cwd)
            end,
        })
    end
}

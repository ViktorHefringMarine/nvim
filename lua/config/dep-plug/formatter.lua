-- Utilities for creating configurations
local util = require "formatter.util"


-- Provides the Format, FormatWrite, FormatLock, and FormatWriteLock commands
require("formatter").setup {
    -- Enable or disable logging
    logging = true,
    -- Set the log level
    log_level = vim.log.levels.WARN,
    -- All formatter configurations are opt-in
    filetype = {
        -- Formatter configurations for filetype "lua" go here
        -- and will be executed in order
        lua = {
            -- "formatter.filetypes.lua" defines default configurations for the
            -- "lua" filetype
            require("formatter.filetypes.lua").stylua,

            -- You can also define your own configuration
            function()
                -- Supports conditional formatting
                if util.get_current_buffer_file_name() == "special.lua" then
                    return nil
                end

                -- Full specification of configurations is down below and in Vim help
                -- files
                return {
                    exe = "stylua",
                    args = {
                        "--search-parent-directories",
                        "--stdin-filepath",
                        util.escape_path(util.get_current_buffer_file_path()),
                        "--",
                        "-",
                    },
                    stdin = true,
                }
            end
        },
        cpp = {
            require('formatter.filetypes.cpp').clangformat
            -- require('formatter.filetypes.cpp').astyle
            --
            -- require('formatter.filetypes.cpp').uncrustify,
            -- function()
            --     return {
            --         exe = "uncrustify",
            --         args = {
            --             "-c ~/.config/uncrustify1.cfg",
            --             "-f",
            --             -- "--no-backup",
            --             -- "--replace",
            --             -- "--mtime",
            --             util.escape_path(util.get_current_buffer_file_path()),
            --         },
            --         stdin = true,
            --     }
            -- end
        },
        python = {
            require('formatter.filetypes.python').black
        },
        sql = function() return { exe = "sql-formatter --config ~/.config/nvim/configs/sql-formatter.json", stdin = true } end,
        -- sql = function() return { exe = "pg_format --config ~/.config/nvim/configs/pg_format.conf", stdin = true } end,
        -- sql = require('formatter.filetypes.sql').pgformat,

        -- Use the special "*" filetype for defining formatter configurations on
        -- any filetype
        -- ["*"] = {
        --     -- "formatter.filetypes.any" defines default configurations for any
        --     -- filetype
        --     require("formatter.filetypes.any").remove_trailing_whitespace
        -- }
    }
}

-- ignore files that are larger than a certain size
local previewers = require('telescope.previewers')
-- local new_maker = function(filepath, bufnr, opts)
-- 	opts = opts or {}
--
-- 	filepath = vim.fn.expand(filepath)
-- 	vim.loop.fs_stat(filepath, function(_, stat)
-- 		if not stat then
-- 			return
-- 		end
-- 		if stat.size > 100000 then
-- 			return
-- 		else
-- 			previewers.buffer_previewer_maker(filepath, bufnr, opts)
-- 		end
-- 	end)
-- end


local actions = require('telescope.actions')
require('telescope').setup({
    defaults = {
        file_ignore_patterns = {
            "%.png", "%.jpeg", "%.svg", "%.md"
        },
        preview = {
            filesize_limit = 1;
        },
        -- buffer_previewer_maker = new_maker,
        prompt_prefix = '=> ',
        selection_caret = ' > ',
        entry_prefix = '   ',
        -- borderchars = { '═', '│', '═', '│', '╒', '╕', '╛', '╘' },
        sorting_strategy = "ascending",
        mappings = {
            n = {
                ["<C-b>"] = actions.cycle_previewers_next,
                ["<C-l>"] = actions.cycle_previewers_prev,
                ["<C-n"] = actions.move_selection_next,
                ["<C-p"] = actions.move_selection_previous,
                ["q"] = actions.send_selected_to_qflist
            },
            i = {
                ["<C-n"] = actions.move_selection_next,
                ["<C-p"] = actions.move_selection_previous,
                ["<C-c>"] = actions.send_selected_to_qflist
            },
        },
        layout_strategy = 'horizontal',
        layout_config = {
            prompt_position = 'top',
            height = 35,
            width = 0.6,
            -- preview_width = 88,
            horizontal = {
                height = 45,
                width = 160
            }
        },


        borderchars = {
            -- Default: { "─", "│", "─", "│", "╭", "╮", "╯", "╰" }
            prompt = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            results = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            preview = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
            -- results = { '─', '', '─', '│', '╭', '─', '─', '╰' },
            -- preview = { '─', '│', '─', '│', '╭', '╮', '╯', '┴' },
        },
    },
    extensions = {
        -- fzf = {
        -- 	fuzzy = true,
        -- 	override_genearic_sorter = true,
        -- 	override_file_sorter = true,
        -- 	case_mode = 'smart_case',
        -- },
        file_browser = {
            -- disables netrw and use telescope-file-browser in its place
            hijack_netrw = false,
            mappings = {
                ["i"] = {
                    ["<C-n"] = actions.move_selection_next,
                    ["<C-p"] = actions.move_selection_previous,
                    -- your custom insert mode mappings
                },
                ["n"] = {

                    ["<C-n"] = actions.move_selection_next,
                    ["<C-p"] = actions.move_selection_previous,
                    -- your custom normal mode mappings
                },
            },
        },
    },
})


require('telescope').load_extension('changed_files')

require('telescope').load_extension('fzf')
-- You don't need to set any of these options.
-- IMPORTANT!: this is only a showcase of how you can set default options!
-- require("telescope").setup {
-- }
-- To get telescope-file-browser loaded and working with telescope,
-- you need to call load_extension, somewhere after setup function:
require("telescope").load_extension "file_browser"
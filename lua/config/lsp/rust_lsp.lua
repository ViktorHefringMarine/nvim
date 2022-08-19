
local lsp_signature_configs = {
  debug = false, -- set to true to enable debug logging
  log_path = vim.fn.stdpath("cache") .. "/lsp_signature.log", -- log dir when debug is on
  -- default is  ~/.cache/nvim/lsp_signature.log
  verbose = false, -- show debug line number

  bind = true, -- This is mandatory, otherwise border config won't get registered.
               -- If you want to hook lspsaga or other signature handler, pls set to false
  doc_lines = 0 , -- will show two lines of comment/doc(if there are more than two lines in doc, will be truncated);
                 -- set to 0 if you DO NOT want any API comments be shown
                 -- This setting only take effect in insert mode, it does not affect signature help in normal
                 -- mode, 10 by default

  floating_window = false, -- show hint in a floating window, set to false for virtual text only mode

  floating_window_above_cur_line = true, -- try to place the floating above the current line when possible Note:
  -- will set to true when fully tested, set to false will use whichever side has more space
  -- this setting will be helpful if you do not want the PUM and floating win overlap

  --floating_window_off_x = 26, -- adjust float windows x position.
  floating_window_off_x = 0, -- adjust float windows x position.
  floating_window_off_y = 2, -- adjust float windows y position.


  fix_pos = false,  -- set to true, the floating window will not auto-close until finish all parameters
  hint_enable = true, -- virtual hint enable
  hint_prefix = "🐼 ",  -- Panda for parameter
  hint_scheme = "String",
  hi_parameter = "LspSignatureActiveParameter", -- how your parameter will be highlight
  max_height = 15, -- max height of signature floating_window, if content is more than max_height, you can scroll down
                   -- to view the hiding contents
  max_width = 76, -- max_width of signature floating_window, line will be wrapped if exceed max_width
  handler_opts = {
    border = "rounded"   -- double, rounded, single, shadow, none
    -- border = none
  },

  always_trigger = true, -- sometime show signature on new line or in middle of parameter can be confusing, set it to false for #58

  auto_close_after = nil, -- autoclose signature float win after x sec, disabled if nil.
  extra_trigger_chars = {"(", ","}, -- Array of extra characters that will trigger signature completion, e.g., {"(", ","}
  zindex = 200000, -- by default it will be on top of all floating windows, set to <= 50 send it to bottom

  padding = '', -- character to pad on left and right of signature can be ' ', or '|'  etc

  transparency = nil, -- disabled by default, allow floating win transparent value 1~100
  --transparency = 20,
  shadow_blend = 36, -- if you using shadow as border use this set the opacity
  shadow_guibg = 'Black', -- if you using shadow as border use this set the color e.g. 'Green' or '#121315'
  timer_interval = 2, -- default timer check interval set to lower value if you want to reduce latency
  toggle_key = '<C-s>' -- toggle signature on and off in insert mode,  e.g. toggle_key = '<M-x>'
}

-- -- -- recommended:

local opts = { noremap=true, silent=false }
local opt_sn = { noremap=true, silent=true }

local my_on_attach = function(client, bufnr)
    vim.cmd("set colorcolumn=80")
    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------

    require('lsp_signature').on_attach(lsp_signature_configs, bufnr) -- no need to specify bufnr if you don't use toggle_key
    require("aerial").on_attach(client, bufnr)



    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- vim.api.nvim_buf_set_option(bufnr, 'nowrap', 'true')
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>[', '<cmd>lua vim.diagnostic.goto_prev()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>]', '<cmd>lua vim.diagnostic.goto_next()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gef', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'geq', '<cmd>lua vim.diagnostic.setloclist()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gd',       '<cmd>lua vim.lsp.buf.definition()<CR>zt', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gk',       '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-s>',       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-p>',    '<cmd>winc l<CR><cmd>icargo', opts)
	vim.api.nvim_buf_set_keymap(bufnr,'n', '<leader>p', ':lua require("harpoon.term").sendCommand(1, "cargo run " .. vim.fn.expand(\'%\') .. "\\r") <CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<space>o', '<cmd>AerialToggle<CR>', opts)

	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-g>',    ':lua require(\'telescope.builtin\').lsp_definitions()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gt',       ':lua require(\'telescope.builtin\').lsp_type_definitions()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', '<C-t>',    ':lua require(\'telescope.builtin\').lsp_type_definitions()<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gI',    	':lua require(\'telescope.builtin\').lsp_implementations({ignore_filenames=false, path_display=hidden})<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gc',       ':lua require(\'telescope.builtin\').lsp_workspace_symbols({query="def"})<CR>', opts)
	vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gC',       ':lua require(\'telescope.builtin\').lsp_document_symbols({query="def"})<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gi',       '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD',       '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gr',       '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gs',       '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)



    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------


	local prefix = '\\s*'
	local suffix = '\\s\\zs\\w*'

	local array_all = { 'impl', 'struct', 'fn', 'trait', 'enum', 'impl<T>' }
	local array_impl = { 'impl', 'impl<T>' }
	local array_struct = { 'struct', 'struct<T>' }
	local array_fn = { 'fn', 'fn<T>' }
	local array_trait = { 'trait', 'trait<T>' }
	local array_enum = { 'enum', 'enum<T>' }
	local array_mod_use = { 'mod', 'use' }

	for i = 1,#array_all    do table.insert(array_all,    'pub ' .. array_all[i]) end
	for i = 1,#array_impl   do table.insert(array_impl,   'pub ' .. array_impl[i]) end
	for i = 1,#array_struct do table.insert(array_struct, 'pub ' .. array_struct[i]) end
	for i = 1,#array_fn     do table.insert(array_fn,     'pub ' .. array_fn[i]) end
	for i = 1,#array_trait  do table.insert(array_trait,  'pub ' .. array_trait[i]) end
	for i = 1,#array_enum   do table.insert(array_enum,   'pub ' .. array_enum[i]) end
	for i = 1,#array_mod_use   do table.insert(array_mod_use,   'pub ' .. array_mod_use[i]) end

    local array_mod_pub = 'pub'

	local sep = suffix .. '|^' .. prefix
	local string_all    =  '/\\v^'..prefix..table.concat(array_all    , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_impl   =  '/\\v^'..prefix..table.concat(array_impl   , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_struct =  '/\\v^'..prefix..table.concat(array_struct , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_fn     =  '/\\v^'..prefix..table.concat(array_fn     , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_trait  =  '/\\v^'..prefix..table.concat(array_trait  , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_enum   =  '/\\v^'..prefix..table.concat(array_enum   , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_mod_use   =  '/\\v^'..prefix..table.concat(array_mod_use   , sep)..suffix..'<CR>'.. ':set nohlsearch<CR>'
	local string_pub   =  '/\\v^'..prefix..array_mod_pub..suffix..'<CR>'.. ':set nohlsearch<CR>'


	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>na',    string_all    , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>ni',    string_impl   , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>ns',    string_struct , opt_sn)

	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>nf',    string_fn     , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>nn',    string_fn     , opt_sn)

	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>nt',    string_trait  , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>ne',    string_enum   , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>nm',    string_mod_use   , opt_sn)
	vim.api.nvim_buf_set_keymap(bufnr, '', '<leader>np',    string_pub   , opt_sn)



    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', ':lua require("harpoon.term").sendCommand(1, "cargo test \\r") <CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ra', ':lua require("harpoon.term").sendCommand(1, "cargo test \\r") <CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', ':lua require("harpoon.term").sendCommand(1, "cargo test \\r") <CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rp', ':lua require("harpoon.term").sendCommand(1, "cargo run \\r") <CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>r1', ':lua require("harpoon.term").sendCommand(1, "cargo run To poem.txt\\r") <CR>', opts)

    -- Rust
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rc', ':RustCodeAction<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rd', ':RustDebuggables<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rD', ':RustDisableInlayHints<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>re', ':RustEmitAsm<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rei', ':RustEmitIr<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>ree', ':RustExpand<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>reE', ':RustExpandMacro<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rf',  ':RustFmt<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rF',  ':RustFmtRange<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rHs', ':RustSetInlayHints<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rHt', ':RustToggleInlayHints<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rha', ':RustHoverActions<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', ':AerialPrev<CR>W:RustHoverActions<CR>:RustHoverActions<CR>', opts)


    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rhr', ':RustHoverRange<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rj', ':RustJoinLines<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rmu', ':RustMoveItemUp<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rmd', ':RustMoveItemDown<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rm', ':lua require("harpoon.term").sendCommand(1, "pipenv run maturin develop --release \\r") <CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>roC', ':RustOpenCargo<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>roc', ':e Cargo.toml<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>roe', ':RustOpenExternalDocs<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rP', ':RustPlay<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rrr', ':RustRun<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rrR', ':RustRunnables<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rrw', ':RustReloadWorkspace<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rs', ':RustSSR<CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rS', ':RustStartStandaloneServerForBuffer<CR>', opts)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rC', ':RustViewCrateGraph<CR>', opts)

    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rp', ':RustParentModule<CR>', opts)


    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    

    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rt', ':lua require("harpoon.term").sendCommand(1, "pytest --no-header -v -rP " .. vim.fn.expand(\'%\') .. "\\r") <CR>', opts)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rp', ':lua require("harpoon.term").sendCommand(1, "python " .. vim.fn.expand(\'%\') .. "\\r")<CR>', opts)


    if vim.loop.os_uname().sysname=="Linux" then
        local python_exe = '/usr/bin/python3.8'
	    vim.g.python3_host_prog = python_exe
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rp', ':lua require("harpoon.term").sendCommand(1, "cargo run " .. vim.fn.expand(\'%\') .. "\\r")<CR>', opts)

        local fd_exe = '/usr/bin/fdfind'
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tt', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '", "test_",     "--type", "f",  "--extension", "rs"                         }})<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tn', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '",             "--type", "f",  "--extension", "rs",    "--exclude", "tests"}})<CR>', opts)

    else
        local python_exe = 'C:/Users/Lenovo/miniconda3/envs/LSPenv/python'
	    vim.g.python3_host_prog = python_exe
        -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rp', ':lua require("harpoon.term").sendCommand(1, "'..python_exe..' " .. vim.fn.expand(\'%\') .. "\\r")<CR>', opts)

        local fd_exe = "C:/Users/Lenovo/scoop/shims/fd.exe"
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tt', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '", "test_",     "--type", "f",  "--extension", "rs"                         }})<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tn', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '",             "--type", "f",  "--extension", "rs",    "--exclude", "tests"}})<CR>', opts)

        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tit', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '", "--full-path", "tests", "--extension", ".rs"}})<CR>', opts)
        vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>tis', ':lua require(\'telescope.builtin\').find_files({find_command={"' .. fd_exe .. '", "--full-path", "src", "--extension", ".rs"}})<CR>', opts)
    end

    local send_r = ':lua require("harpoon.term").sendCommand(1, "\\r")<CR>'
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rn', '<cmd>TestNearest<CR>' .. send_r, opt_sn)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rl', '<cmd>TestLast<CR>' .. send_r, opt_sn)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rN', '<cmd>lua require("harpoon.term").sendCommand(1, "cargo test " .. split( vim.fn.expand(\'%\'):match(\'[^\\\\]*.rs$\'), \'.rs\')[1] .. "\\r") <CR>', opt_sn)
    vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>M', ':lua vim.fn.expand(\'%\'):match(\'[\\^\\]*.rs$\')', opt_sn)
    -- vim.api.nvim_buf_set_keymap(bufnr, 'n', '<leader>rs', '<cmd>TestSuite<CR>' .. send_r, opt_sn)


    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    require('which-key').register({
        n = {
            name = "Jump",
            a = "All",
            i = "Implementation",
            s = "Struct",
            f = "Function",
            t = "Trait",
            e = "Enum",
            m = "mod/use"
        },
        r = {
            name = 'Rust',
            c = "RustCodeAction",
            d = "Debuggables",
            D = "DisableInlayHints",
            e = {
                name = "E",
                a = "EmitAsm",
                i = "EmitIr",
                e = "Expand",
                E = "ExpandMacro"
            },
            -- f = "Fmt",
            f = "cargo test file",
            F = "FmtRange",
            H = {
                name = "Hints",
                s = "RustSetInlayHints",
                t = "RustToggleInlayHints"
            },
            h = {
                name = "Hover",
                a = "HoverActions",
                r = "HoverRange"
            },
            j = "JoinLines",
            l = "cargo test <last>",
            n = "cargo test <nearest>",
            m = {
                name = "MoveItem",
                u = "MoveItemUp",
                d = "MoveItemDown",
            },
            o = {
                name = "Open",
                c = "OpenCargo",
                e = "OpenExternalDocs",
            },
            p = "ParentModule",
            P = "RustPlay",
            r = {
                name = "R",
                r = "RustRun",
                R = "RustRunnables",
                w = "RustReloadWorkspace"
            },
            s = "cargo test <suite>",
            -- s = "RustSSR",
            -- S = "StartServer",
            C = "RustViewCrateGraph"
        }, 
    }, {
        prefix = '<leader>',
    })

    ---------------------------------------------------------------------------------
    ---------------------------------------------------------------------------------
    if client.server_capabilities.document_highlight then
        vim.cmd [[ hi! LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow ]]
        vim.cmd [[ hi! LspReferenceText cterm=bold ctermbg=red guibg=LightYellow]]
        vim.cmd [[ hi! LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow]]
        vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = false
        })
        vim.api.nvim_clear_autocmds({
            buffer = bufnr,
            group = 'lsp_document_highlight',
        })
        vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = 'lsp_document_highlight',
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end







    -- vim.cmd("setlocal indentexpr=")
    -- vim.cmd("setlocal nowrap")



    -- local cmp = require'cmp'
--
--     require('lspkind').init({
--         -- defines how annotations are shown
--         -- default: symbol
--         -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
--         mode = 'symbol_text',
--
--         -- default symbol map
--         -- can be either 'default' (requires nerd-fonts font) or
--         -- 'codicons' for codicon preset (requires vscode-codicons font)
--         --
--         -- default: 'default'
--         preset = 'codicons',
--
--         -- override preset symbols
--         --
--         -- default: {}
--         symbol_map = {
--           Text = "",
--           Method = "",
--           Function = "",
--           Constructor = "",
--           Field = "ﰠ",
--           Variable = "",
--           Class = "ﴯ",
--           Interface = "",
--           Module = "",
--           Property = "ﰠ",
--           Unit = "塞",
--           Value = "",
--           Enum = "",
--           Keyword = "",
--           Snippet = "",
--           Color = "",
--           File = "",
--           Reference = "",
--           Folder = "",
--           EnumMember = "",
--           Constant = "",
--           Struct = "פּ",
--           Event = "",
--           Operator = "",
--           TypeParameter = ""
--         },
--     })
--
--
    -- cmp.setup({
    --     -- snippet = { 
    --     --     -- REQUIRED - you must specify a snippet engine 
    --     --     expand = function(args) 
    --     --         -- vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
    --     --         require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
    --     --         -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
    --     --         -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users. 
    --     --     end,
    --     -- },
    --     window = {
    --         -- completion = cmp.config.window.bordered(),
    --         -- documentation = cmp.config.window.bordered(),
    --     },
    --     mapping = cmp.mapping.preset.insert({
    --         ['<C-y>'] = cmp.mapping.scroll_docs(-4),
    --         ['<C-e>'] = cmp.mapping.scroll_docs(4),
    --         ['<C-Space>'] = cmp.mapping.complete(),
    --         -- ['<C-q'] = cmp.mapping.abort(),
    --         ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    --     }),
    --     sources = cmp.config.sources({
    --         { name = 'nvim_lsp' },
    --         -- { name = 'vsnip' }, -- For vsnip users.
    --         -- { name = 'luasnip' }, -- For luasnip users.
    --         -- { name = 'ultisnips' }, -- For ultisnips users.
    --         -- { name = 'snippy' }, -- For snippy users.
    --     }, {
    --         { name = 'buffer' },
    --     }),
    --     formatting = {
    --       format = function(entry, vim_item)
    --         -- fancy icons and a name of kind
    --         vim_item.kind = require("lspkind").presets.default[vim_item.kind] .. " " .. vim_item.kind
    --
    --         -- set a name for each source
    --         vim_item.menu = ({
    --           buffer = "「Buffer」",
    --           text = "「Text」",
    --           nvim_lsp = "「Lsp」",
    --           ultisnips = "「UltiSnips」",
    --           nvim_lua = "「Lua」",
    --         })[entry.source.name]
    --         return vim_item
    --       end,
    --     }
    -- })
--         ---------------------------------------------------------------------------------
--         ---------------------------------------------------------------------------------
--        
end
--
--


local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)
capabilities.textDocument.completion.completionItem.snippetSupport = false

-- require("rust-tools").setup({
--     capabilities = capabilities,
--     filetypes = {"rs"},
--     tools = { -- rust-tools options
--         autoSetHints = true,
--         hover_with_actions = true,
--         inlay_hints = {
--             show_parameter_hints = true,
--             parameter_hints_prefix = " ",
--             other_hints_prefix = "  ",
--             highlight = "VirtualTextHint"
--             --📜💡
--             --, , , , , ,  
--         },
--     }
-- })
local rust_analyzer_config = {
    capabilities=capabilities,
    on_attach = my_on_attach,
	filetypes = {'rust', 'rs'},
    checkOnSave = {
        enable = true,
    },
    server = {
        path = "C:/Users/Lenovo/AppData/Roaming/nvim-data/lsp_servers/rust/rust-analyzer.exe"
    }
}
-- local lspconfig = require('lspconfig')
--
--
-- lspconfig.rust_analyzer.setup(rust_analyzer_config)


-- M.options = {
--   tools = {},
--   server = {},
--   dap = {},
-- }
-- local codelldb_path = 'C:/Users/Lenovo/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/adapter/codelldb.exe'
-- local liblldb_path  = 'C:/Users/Lenovo/.vscode/extensions/vadimcn.vscode-lldb-1.7.0/lldb/lib/liblldb.so'
-- local dap = {
--     -- adapter = require('rust-tools.dap').get_codelldb_adapter(
--         -- codelldb_path, liblldb_path
--     -- )
--     adapter = {
--         type = "executable",
--         command = "C:/Program Files/LLVM/bin/lldb-vscode",
--         name = "rt_lldb",
--     },
-- }
require("rust-tools").setup({
    server = rust_analyzer_config,
    -- dap = dap
})

-- require('rust-tools.inlay_hints').set_inlay_hints()
-- require('rust-tools.inlay_hints').disable_inlay_hints()
-- require('rust-tools.inlay_hints').toggle_inlay_hints()


-- require'cmp'.setup {
--   sources = {
--     { name = 'nvim_lsp' }
--   }
-- }

-- The nvim-cmp almost supports LSP's capabilities so You should advertise it to LSP servers..
-- local capabilities = vim.lsp.protocol.make_client_capabilities()

-- Setup lspconfig.
-- local capabilities = require('cmp_nvim_lsp').update_capabilities(vim.lsp.protocol.make_client_capabilities())


--
--     -- all the opts to send to nvim-lspconfig
--     -- these override the defaults set by rust-tools.nvim
--     -- see https://github.com/neovim/nvim-lspconfig/blob/master/doc/server_configurations.md#rust_analyzer
--     server = {
--         -- on_attach is a callback called when the language server attachs to the buffer
--         on_attach = my_on_attach,
--         settings = {
--             -- to enable rust-analyzer settings visit:
--             -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
--             ["rust-analyzer"] = {
--                 -- enable clippy on save
--                 checkOnSave = {
--                     command = "clippy"
--                 },
--             }
--         }
--     },
-- })
--
--







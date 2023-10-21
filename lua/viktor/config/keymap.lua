local rust = {
	build_settings = '--release --features dev',
}

local function _cmd(command)
	if type(command) == 'string' then
		return '<CMD>' .. command .. '<CR>'
	elseif type(command) == 'table' then
		local out = ''
		for _, v in ipairs(command) do
			out = out .. '<CMD>' .. v .. '<CR>'
		end
		return out
	end
end

-- NORMAL - NOT with LEADER
require('which-key').register({
	['<C-h>'] = { _cmd('wincmd h'), 'left window' },
	['<C-l>'] = { _cmd('wincmd l'), 'left window' },
	['<C-k>'] = { _cmd('wincmd k'), 'left window' },
	['<C-j>'] = { _cmd('wincmd j'), 'left window' },

	["'"] = {
		name = 'Navigate to',
        -- stylua: ignore start
		h = {     function() require('harpoon.ui').nav_file(1) end, '1st' },
		t = {     function() require('harpoon.ui').nav_file(2) end, '2nd' },
		n = {     function() require('harpoon.ui').nav_file(3) end, '3rd' },
		s = {     function() require('harpoon.ui').nav_file(4) end, '4th' },
		['-'] = { function() require('harpoon.ui').nav_file(5) end, '5th' },
		m = { function() require('harpoon.term').gotoTerminal(1) end, '1st-term', },
		w = { function() require('harpoon.term').gotoTerminal(2) end, '2nd-term', },
		c = { function() vim.cmd('ClangdSwitchSourceHeader') end, 'clang-switch', },
		q = { function() vim.cmd('Fcarbon %:p:h')            end, 'fcarbon', },
		b = {     _cmd('b#'), 'b#' },
		['/'] = { _cmd('A'),  'src-test' },
		-- stylua: ignore end

		d = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').output_panel.toggle()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'neotest-open-down',
		},
		o = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').output.open({ enter = true, last_run = true, auto_close = false })
				else
					vim.cmd('keymap set for filetype ' .. vim.bo.filetype)
				end
			end,
			'neotest-open',
		},
		l = {
			function()
				if 'rust' == vim.bo.filetype then
					local open_win = function()
						vim.cmd('split')
						return vim.api.nvim_get_current_win()
					end
                    -- stylua: ignore
                    require('neotest').output.open({ enter = true, last_run = true, auto_close = false, open_win = open_win })
				else
					vim.cmd('keymap set for filetype ' .. vim.bo.filetype)
				end
			end,
			'neotest-open-left',
		},

		L = {
			function()
				local ft = vim.bo.filetype
				local dir = '~/.config/nvim/lua/viktor/lsp'
				if 'rust' == ft then
					vim.cmd('e ' .. dir .. '/rust.lua')
				elseif 'lua' == ft then
					vim.cmd('e ' .. dir .. '/lua_ls.lua')
				elseif 'python' == ft then
					vim.cmd('e ' .. dir .. '/python.lua')
				elseif 'typescriptreact' == ft then
					vim.cmd('e ' .. dir .. '/tsserver.lua')
				elseif 'cpp' == ft then
					vim.cmd('e ' .. dir .. '/clangd.lua')
				elseif 'toml' == ft then
					vim.cmd('e ' .. dir .. '/toml.lua')
				end
			end,
			'got to config',
		},
		C = {
			function()
				local ft = vim.bo.filetype
				local dir = '~/.config/nvim/after/plugin/cmp'
				if 'rust' == ft then
					vim.cmd('e ' .. dir .. '/rust.lua')
				elseif 'lua' == ft then
					vim.cmd('e ' .. dir .. '/lua_ls.lua')
				elseif 'python' == ft then
					vim.cmd('e ' .. dir .. '/python.lua')
				elseif 'go' == ft then
					vim.cmd('e ' .. dir .. '/rust.lua')
				elseif 'typescriptreact' == ft then
					vim.cmd('e ' .. dir .. '/tsserver.lua')
				elseif 'cpp' == ft then
					vim.cmd('e ' .. dir .. '/clangd.lua')
				elseif 'toml' == ft then
					vim.cmd('e ' .. dir .. '/toml.lua')
				end
			end,
			'goto cmp',
		},
	},

	[']'] = {
		name = 'Goto Next',
		d = { vim.diagnostic.goto_next, 'diagnostic' },
		g = { _cmd('Gitsigns next_hunk'), 'next hunk' },
		h = { require('harpoon.ui').nav_next, 'harpoon' },
		l = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').jump.next({ status = 'failed' })
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft',
		},
		t = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').jump.next({ status = 'failed' })
				else
					vim.cmd('TSTextobjectRepeatLastMoveNext')
				end
			end,
			'ft',
		},
	},

	['['] = {
		name = 'Goto Prev',
		d = { vim.diagnostic.goto_prev, 'diagnostic' },
		g = { _cmd('Gitsigns prev_hunk'), 'prev hunk' },
		h = { require('harpoon.ui').nav_prev, 'harpoon' },
		-- ["l"] = { require("harpoon.ui").nav_prev, "goto prev mark" },
		l = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').jump.prev({ status = 'failed' })
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft',
		},
		t = {
			function()
				if 'rust' == vim.bo.filetype then
					require('neotest').jump.next({ status = 'failed' })
				else
					vim.cmd('TSTextobjectRepeatLastMovePrevious')
				end
			end,
			'ft',
		},
	},

	c = {
		name = 'lists/cargo',
		['<leader>'] = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').run.command('cargo run --release --features dev --bin http-server')
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo run --release --features dev --bin http-server',
		},
		['*'] = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('Task start cargo clippy ' .. rust.build_settings)
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo clippy',
		},
		['!'] = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('Task start cargo check ' .. rust.build_settings)
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo check',
		},
		['|'] = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('Task start cargo bench ' .. rust.build_settings)
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo bench',
		},
		b = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('Task start cargo build ' .. rust.build_settings)
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo build',
		},
		d = { vim.diagnostic.setqflist, 'setqflist' },
		l = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').run.last_cmd()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: run last command',
		},
		g = {
			name = 'git',
			a = {
				function()
					require('keys').register_jump_mappings('qf')
					vim.cmd('Git difftool')
				end,
				'all hunks',
			},
			f = {
				function()
					require('keys').register_jump_mappings('qf')
					vim.cmd('Gitsigns setqflist')
				end,
				'all hunks in file',
			},
			s = {
				function()
					vim.cmd('Telescope git_status')
				end,
				'status',
			},
		},
		q = { _cmd('cclose'), 'close' },
		r = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').run.with_arguments()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo run -- <Prompt>',
		},
		R = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').run.selected_binary()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: A: cargo run --bin <?>',
		},
		s = { vim.lsp.buf.signature_help, 'signature_help' },
	},

	d = {
		name = 'diagnostics / diff',
		o = { vim.diagnostic.open_float, 'open-float' },
        -- stylua: ignore
		h = { function() vim.cmd('DiffviewOpen') end, 'Diff Head', },
		s = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').explain_error.open_popup_here()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: explain error',
		},
		J = {
			function()
				if 'rust' == vim.bo.filetype then
					require('rust_funcs').explain_error.print_error_as_json()
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft: print error as json',
		},
	},

	g = {
		name = '+goto',
		c = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('RustOpenCargo')
				else
					vim.cmd('e Cargo.toml')
				end
			end,
			'Cargo.toml',
		},
		d = {
			function()
				vim.lsp.buf.definition({
					-- on_list = function(options)
					--                    if 1 < #options.items then
					--                        vim.print(options)
					--                        vim.fn.setqflist({}, " ", options)
					--                    end
					--                    vim.api.nvim_command("cfirst")
					-- end,
				})
			end,
			'definition',
		},
		D = { vim.lsp.buf.declaration, 'declaration' },
		h = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('RustHoverActions')
				else
					vim.lsp.buf.hover()
				end
			end,
			'hover/actions',
		},
		p = {
			function()
				if 'rust' == vim.bo.filetype then
					vim.cmd('RustParentModule')
				else
					vim.cmd('keymap not set for filetype ' .. vim.bo.filetype)
				end
			end,
			'ft',
		},
		i = { vim.lsp.buf.implementation, 'impl' },
		k = { _cmd('TSTextobjectPeekDefinitionCode @function.inner'), 'peek definition' },
		-- t = { require('telescope.builtin').lsp_type_deftnitions, "type-definition" }
		t = { vim.lsp.buf.type_definition, 'type-definition' },
		r = { vim.lsp.buf.references, 'references' },
		s = {
			name = 'stage',
			f = { '<CMD> w <CR><CMD> Gitsigns stage_buffer <CR>', 'file' },
			h = { '<CMD> Gitsigns stage_hunk <CR>', 'hunk' },
		},
	},

	y = {
		name = 'yank',
		s = { 'viw"ly' },
	},
})

-- NORMAL - LEADER -----------------------------------
require('which-key').register({
	['<leader>'] = {
		[','] = { _cmd('Telescope file_browser path=%:p:h theme=dropdown'), 'File Browser' },
		['|'] = { _cmd('messages'), 'messages' },
		['~'] = {
			function()
				vim.print('REMEMBER: use <leader>| now')
			end,
			'messages',
		},
		['-'] = { _cmd('b#'), 'b#' },
		q = { _cmd('q'), 'quit' },
		Q = { _cmd('confirm qa'), 'quit-all' },
		G = { _cmd('Git'), 'Git' },
		s = { _cmd('w'), 'save' },
		z = { _cmd('ZenMode'), 'Zen mode' },

		b = {
			name = 'buffer',
			n = { '<cmd>bn<cr>' },
			p = { '<cmd>bp<cr>' },
		},

		c = {
			name = 'lists',
			P = { vim.cmd.colder, 'older' },
			N = { vim.cmd.cnewer, 'Newer' },
			c = {
				function() -- '<cmd>ccl<cr><cmd>TroubleClose<cr>'
					vim.cmd('ccl')
					vim.cmd('TroubleClose')
				end,
				'close',
			},
			g = { '<CMD>Gitsigns setqflist<CR>', 'Git changes' },
			d = { vim.diagnostic.setqflist, 'diags to qflist' },
			q = {
				function()
					vim.cmd('cclose')
					vim.cmd('lclose')
				end,
				'close',
			},
			i = {
				function()
					for _, opts in ipairs(vim.fn.getwininfo()) do
						local ft = vim.api.nvim_buf_get_option(opts['bufnr'], 'filetype')
						local status, result = pcall(require('keys').register_jump_mappings, ft)
						if status then
							print('keymap registered for ' .. ft)
							return
						else
							print('error: ' .. result)
						end
					end
				end,
				'set-keymaps',
			},
			o = {
				function()
					vim.cmd('copen')
					require('keys').register_jump_mappings('qf')
				end,
				'open qf-list',
			},
			l = {
				function()
					vim.cmd('lopen')
					require('keys').register_jump_mappings('loclist')
				end,
				'open loc-list',
			},
			n = { '<cmd>cn<cr>', 'next' },
			p = { '<cmd>cp<cr>', 'prev' },
			s = {
				function() -- ':vimgrep /\\.<C-r>l/g %<CR>:Trouble quickfix<CR>',
					vim.cmd(':vimgrep /\\.<C-r>l/g %')
					vim.cmd('copen')
					-- vim.cmd('Trouble quickfix')
				end,
				'/\\.<C-r>l/g %',
			},
		},

		d = {
			name = 'diagnostic',
			t = { require('diagnostic_funcs').toggle, 'toggle' },
			s = { vim.diagnostic.open_float, 'open-float' },
			l = {
				name = 'location list',
				a = {
					function()
						require('diagnostic_funcs').loclist()
					end,
					'All',
				},
				e = {
					function()
						require('diagnostic_funcs').loclist(vim.diagnostic.severity.ERROR)
					end,
					'ERROR',
				},
				h = {
					function()
						require('diagnostic_funcs').loclist(vim.diagnostic.severity.HINT)
					end,
					'HINT',
				},
				w = {
					function()
						require('diagnostic_funcs').loclist(vim.diagnostic.severity.WARN)
					end,
					'WARN',
				},
				i = {
					function()
						require('diagnostic_funcs').loclist(vim.diagnostic.severity.INFO)
					end,
					'INFO',
				},
			},
			c = {
				name = 'qflist',
				a = {
					function()
						require('diagnostic_funcs').qflist()
					end,
					'All',
				},
				e = {
					function()
						require('diagnostic_funcs').qflist(vim.diagnostic.severity.ERROR)
					end,
					'ERROR',
				},
				h = {
					function()
						require('diagnostic_funcs').qflist(vim.diagnostic.severity.HINT)
					end,
					'HINT',
				},
				w = {
					function()
						require('diagnostic_funcs').qflist(vim.diagnostic.severity.WARN)
					end,
					'WARN',
				},
				i = {
					function()
						require('diagnostic_funcs').qflist(vim.diagnostic.severity.INFO)
					end,
					'INFO',
				},
			},
		},

		e = {
			name = 'extras',
			['|'] = {
				function()
					require('viktor.vim.libs').conf(vim.fn.expand('%'))
				end,
				'dont know',
			},
			a = { _cmd('AerialToggle'), 'Aerial Toggle' },
			b = {
				s = {
					function()
						vim.cmd('set scrollbind')
						vim.cmd('set cursorbind')
					end,
					'window bind',
				},
				x = {
					function()
						vim.cmd('set noscrollbind')
						vim.cmd('set nocursorbind')
					end,
					'window bind off',
				},
			},
			c = { _cmd('cd %:p:h'), 'cd %:p:h' },
			f = {
				name = 'fold',
				i = {
					function()
						vim.cmd('set foldmethod=indent')
					end,
					'indent',
				},
				s = {
					function()
						vim.cmd('set foldmethod=syntax')
					end,
					'syntax',
				},
				m = {
					function()
						vim.cmd('set foldmethod=manual')
					end,
					'manual',
				},
			},
			h = {
				function()
					vim.cmd('set hlsearch!')
				end,
				'set hlsearch!',
			},
			l = {
				function()
					vim.cmd('LineNumberIntervalToggle')
				end,
				'LineNumberIntervalEnable',
			},
			p = { '"+p', 'paste' },
			s = { _cmd('so %'), 'source %' },
			t = {
				name = 'terminal',
				v = { _cmd('vs | terminal') .. 'i', 'split vertical' },
				s = { _cmd('sp | terminal') .. 'i', 'split horizontal' },
			},
			['-'] = { _cmd('cd ..'), 'cd ..' },
		},

		g = {
			name = 'Git',
			o = { _cmd('Git'), ':Git' },
			c = { _cmd('Git commit'), 'commit' },
			q = {
				name = 'setqflist',
				a = {
					function()
						require('keys').register_jump_mappings('qf')
						vim.cmd('Git difftool')
					end,
					'all hunks',
				},
				f = {
					function()
						require('keys').register_jump_mappings('qf')
						vim.cmd('Gitsigns setqflist')
					end,
					'current file',
				},
			},
			D = {
				function()
					vim.ui.input({ prompt = 'git diff ' }, function(input)
						vim.cmd('DiffviewOpen ' .. input)
					end)
				end,
				'Git-Diff',
			},
			d = {
				name = 'git-diff',
				b = {
					function()
						vim.ui.input({ prompt = 'Number of HEADS Back: ' }, function(count)
							vim.cmd('DiffviewOpen HEAD' .. string.rep('^', count))
						end)
					end,
					'SELECT',
				},
				h = {
					function()
						vim.cmd('DiffviewOpen')
					end,
					'HEAD',
				},
				s = {
					function()
						vim.ui.select({ 'HEAD^', 'HEAD^^..HEAD^' }, { prompt = 'Select' }, function(choice)
							vim.cmd('DiffviewOpen ' .. choice)
						end)
					end,
					'SELECT',
				},
				f = {
					function()
						vim.cmd('Gitsigns diffthis')
					end,
					'file',
				},
				q = { _cmd('DiffviewClose'), 'quit' },
			},
			P = { _cmd('Gitsigns preview_hunk_inline'), 'preview hunk' },
			t = {
				name = 'toggle',
				s = { '<CMD> Gitsigns toggle_signs                           <CR> ', 'signs' },
				n = { '<CMD> Gitsigns toggle_numhl                           <CR> ', 'num-highlight' },
				l = { '<CMD> Gitsigns toggle_linehl                          <CR> ', 'line-highlight' },
				h = {
					function()
						vim.cmd('Gitsigns toggle_linehl')
						vim.cmd('Gitsigns toggle_numhl')
						vim.cmd('Gitsigns toggle_word_diff')
					end,
					'highlight',
				},
				d = { '<CMD> Gitsigns toggle_deleted                         <CR> ', 'deleted' },
				w = { '<CMD> Gitsigns toggle_word_diff                       <CR> ', 'word-diff' },
				b = { '<CMD> Gitsigns toggle_current_line_blame              <CR> ', 'current-line-blame' },
			},
			S = { '<CMD> Gitsigns show <CR>', 'Show Head' },
			s = {
				name = 'stage',
				f = { '<CMD> w <CR><CMD> Gitsigns stage_buffer <CR>', 'file' },
				h = { '<CMD> Gitsigns stage_hunk <CR>', 'hunk' },
			},
			r = {
				name = 'reset',
				f = { '<CMD> w <CR><CMD> Gitsigns reset_buffer_index <CR>', 'file' },
				h = { '<CMD> Gitsigns undo_stage_hunk <CR>', 'hunk' },
			},
			R = {
				name = 'restore',
				f = { '<CMD> w <CR><CMD> Gitsigns reset_buffer <CR>', 'file' },
				h = { '<CMD> Gitsigns reset_hunk <CR>', 'hunk' },
			},
		},

		h = {
			name = 'harpoon/git',
			["'"] = { require('harpoon.mark').add_file, 'mark file' },
			t = { require('harpoon.ui').toggle_quick_menu, 'toggle menu' },
			-- n = { require("harpoon.ui").nav_next, "goto next mark" },
			-- p = { require("harpoon.ui").nav_prev, "goto prev mark" },
			u = { require('gitsigns.actions').undo_stage_hunk, 'undo stage hunk' },
			p = { require('gitsigns.actions').preview_hunk_inline, 'preview_hunk' },
			b = { require('gitsigns.actions').blame_line, 'blame line' },
			s = { ':Gitsigns stage_hunk<CR>', 'stage hunk' },
			r = {
				function()
					require('harpoon.tmux').sendCommand('!', '^p')
					require('harpoon.tmux').sendCommand('!', '\r')
				end,
				'tmux: prev-cmd',
			},
		},

		l = {
			name = 'LSP',
			-- a = { vim.lsp.buf.code_action, "code action" },
			a = { require('code_action_menu').open_code_action_menu, 'code action' },
			d = {
				name = 'Document',
				-- ['c'] = '[cmd] lua vim.lsp.buf.declaration()',
				-- ['f'] = '[cmd] lua vim.lsp.buf.definition()',
				h = { vim.lsp.buf.document_highlight, 'highlight' },
				s = { vim.lsp.buf.document_symbol, 'symbol' },
			},
			-- ['f'] = { ['1'] = '[cmd] lua vim.lsp.buf.format()', ['2'] = '[cmd] lua vim.lsp.buf.formatting()', ['3'] = '[cmd] lua vim.lsp.buf.formatting_seq_sync()', ['4'] = '[cmd] lua vim.lsp.buf.formatting_sync()', },
			e = { vim.lsp.buf.execute_command, 'execute command' },
			-- f = { vim.lsp.buf.format, "format" },
			f = {
				function()
					vim.cmd('Format')
				end,
				'format',
			},
			h = { vim.lsp.buf.hover, 'hover' },
			i = { vim.lsp.buf.implementation, 'implementation' },
			I = { vim.lsp.buf.incoming_calls, 'incoming calls' },
			o = { vim.lsp.buf.outgoing_calls, 'outgoing calls' },
			r = { vim.lsp.buf.rename, 'rename' },
			-- r = {
			--     c = { vim.lsp.buf.range_code_action, "range code action" },
			--     f = { vim.lsp.buf.range_formatting, "range formatting" },
			--     e = { vim.lsp.buf.references, "references" },
			--     n = { vim.lsp.buf.rename, "rename" },
			-- },
			R = { vim.lsp.buf.rename, 'rename' },
			s = {
				r = { vim.lsp.buf.server_ready, 'server ready' },
				h = { vim.lsp.buf.signature_help, 'signature help' },
			},
			t = { vim.lsp.buf.type_definition, 'type definition' },
			w = {
				name = 'workspace',
				a = { vim.lsp.buf.add_workspace_folder, 'add workspace folder' },
				r = { vim.lsp.buf.remove_workspace_folder, 'remove_workspace_folder' },
				l = { vim.lsp.buf.list_workspace_folders, 'list_workspace_folders' },
			},
		},

		L = {
			i = { _cmd('LspInfo'), 'LSPInfo' },
			m = { _cmd('Mason'), 'Mason' },
		},

		n = {
			name = 'Neorg',
			c = {
				function()
					if _G._neorg_concealed then
						vim.cmd('setlocal concealcursor=')
						_G._neorg_concealed = false
					else
						vim.cmd('setlocal concealcursor=inv')
						_G._neorg_concealed = true
					end
				end,
				'toggle-concealer',
			},
			C = { _cmd('Neorg toggle-concealer'), 'toggle-concealer' },
			o = {
				name = 'Open',
				r = { _cmd('Neorg workspace rust'), 'rust' },
				n = { _cmd('Neorg workspace research'), 'research' },
				d = { _cmd('Neorg workspace general'), 'default' },
			},
			j = {
				t = { _cmd('Neorg journal today'), 'today' },
				c = { _cmd('Neorg journal custom'), 'custom' },
				T = { _cmd('Neorg journal template'), 'template' },
				n = { _cmd('Neorg journal tomorrow'), 'tomorrow' },
				y = { _cmd('Neorg journal yesterday'), 'yesterday' },
			},
			t = {
				name = 'TOC',
				l = { _cmd('Neorg toc left'), 'left' },
				r = { _cmd('Neorg toc right'), 'right' },
				q = { _cmd('Neorg toc qflist'), 'qflist' },
			},
			T = { _cmd('Neorg tangle'), 'Tangle' },
			m = {
				name = 'mode',
				n = { _cmd('Neorg mode norg'), 'norg' },
				t = { _cmd('Neorg mode traverse-heading'), 'traverse-heading' },
				l = { _cmd('Neorg module list'), 'list' },
				L = { _cmd('Neorg module load'), 'load' },
			},
			i = { _cmd('Neorg index'), 'index' },
			I = { _cmd('Neorg inject-metadata'), 'inject-metadata' },
			U = { _cmd('Neorg update-metadata'), 'update-metadata' },
			r = { _cmd('Neorg return'), 'return' },
			-- t = { _cmd("Neorg tangle"), ""},
			-- k = { _cmd("Neorg keybind"), ""},
			-- u = { _cmd("Neorg upgrade"), ""},
			-- w = { _cmd("Neorg workspace"), ""},
			-- s = { _cmd("Neorg sync-parsers"), ""},
			-- i = { _cmd("Neorg inject-metadata"), ""},
			-- u = { _cmd("Neorg update-metadata"), ""},
			-- t = { _cmd("Neorg toggle-concealer"), ""},
		},

		m = {
			name = 'Mini',
			o = {
				require('mini.files').open,
				'Files Open',
			},
			[','] = {
				function()
					require('mini.files').open(vim.fn.expand('%'))
				end,
				'Files Open (file)',
			},
			t = {
				require('mini.map').toggle,
				'Map toggle',
			},
			l = {
				require('mini.map').toggle_focus,
				'Map focus',
			},
		},

		r = {
			w = {
				function()
					local current_word
					local new_word
					vim.ui.input({ prompt = 'current word: ' }, function(input)
						current_word = input
					end)
					vim.ui.input({ prompt = 'new word: ' }, function(input)
						new_word = input
					end)
					vim.cmd('%s/' .. current_word .. '/' .. new_word .. '/g')
				end,
				'replace word',
			},
		},

		P = {
			name = 'Packer',
			r = { _cmd('PackerClean'), 'PackerClean' },
			c = { _cmd('PackerCompile'), 'PackerCompile' },
			i = { _cmd('PackerInstall'), 'PackerInstall' },
			l = { _cmd('PackerLoad'), 'PackerLoad' },
			p = { _cmd('PackerProfile'), 'PackerProfile' },
			s = { _cmd('PackerStatus'), 'PackerStatus' },
			u = { _cmd('PackerUpdate'), 'PackerUpdate' },
			S = {
				name = 'Snapshot',
				c = { _cmd('PackerSnapshot'), 'PackerSnapshot' },
				d = { _cmd('PackerSnapshotDelete'), 'PackerSnapshotDelete' },
				r = { _cmd('PackerSnapshotRollback'), 'PackerSnapshotRollback' },
			},
			['-'] = { _cmd('PackerSync'), 'PackerSync' },
		},

		T = { _cmd('Telescope'), 'Telescope' },

		t = {
			name = 'Telescope',
			a = { _cmd('Telescope aerial'), 'aerial' },
			c = { _cmd('Telescope colorscheme path=%:p:h theme=dropdown'), 'colorscheme' },
			e = {
				function()
					require('telescope.builtin').find_files({ cwd = require('telescope.utils').buffer_dir() })
				end,
				'files in %:p:h',
			},
			o = { require('telescope.builtin').buffers, 'buffers' },
			-- k = { require("telescope.builtin").live_grep, "live grep" },
			k = { require('telescope').extensions.live_grep_args.live_grep_args, 'live grep' },
			j = {
				function()
					require('telescope.builtin').live_grep({ cwd = require('telescope.utils').buffer_dir() })
				end,
				'live grep in %:p:h',
			},
			g = {
				name = 'git',
				s = {
					function()
						vim.cmd('Telescope git_status')
					end,
					'status',
				},
				b = {
					function()
						vim.cmd('Telescope git_branches')
					end,
					'branches',
				},
				c = {
					function()
						vim.cmd('Telescope git_commits')
					end,
					'commits',
				},
			},
			["'"] = { require('telescope.builtin').marks, 'marks' },
			[','] = { _cmd('Telescope file_browser path=%:p:h'), 'File Browser' },
			b = { _cmd('Telescope file_browser theme=dropdown'), 'File Browser (cwd)' },
			m = { require('telescope.builtin').keymaps, 'keymaps' },
			-- n = { function() require("trouble").next({ skip_groups = true, jump = true }) end, "Trouble next" },
			-- p = { function() require("trouble").previous({ skip_groups = true, jump = true }) end, "Trouble prev" },
			-- c = { _cmd('TroubleClose'), "TroubleClose" },
			-- C = { require('telescope.builtin').colorscheme({theme='dropdown'}), "Colorscheme"},
			C = { _cmd('Telescope colorscheme theme=dropdown'), 'Colorscheme' },
			-- r = { _cmd('TroubleRefresh'), "TroubleRefresh" },
			r = { require('telescope.builtin').resume, 'resume' },
			u = { require('telescope.builtin').find_files, 'files' },
			w = { require('telescope.builtin').lsp_workspace_symbols, 'ws symbols' },
		},

		w = {
			name = 'Window',
			m = { _cmd('WindowsMaximize'), 'maximize' },
			e = { _cmd('WindowsEqualize'), 'equalize' },
		},
	},
})

-- VISUAL MODE
require('which-key').register({
	['<leader>'] = {
		h = {
			s = { ':Gitsigns stage_hunk<CR>', 'stage hunk' },
		},
	},
}, {
	mode = 'v',
})

require('viktor.lib.funcs').cmd_mappings('v', {
	['<leader>'] = {
		e = {
			y = '"+y',
		},
	},
})

-- INSERT MODE
require('viktor.lib.funcs').cmd_mappings('i', {
	-- ['<C-space>'] = '<C-x><C-o>',
	-- ['<C-o>'] = '<C-x><C-o>',
	['<C-f>'] = '<C-x><C-f>',
})

-- TERMINAL MODE
require('viktor.lib.funcs').cmd_mappings('t', {
	['<esc>'] = '<C-\\><C-n>',
	['<C-q>'] = '<C-\\><C-n>',
	['<C-j>'] = '<Down>',
	['<C-k>'] = '<Up>',
})

-- COMMAND MODE
require('viktor.lib.funcs').cmd_mappings('c', {
	['<C-j>'] = '<Down>',
	['<C-k>'] = '<Up>',
})

-- require('neorg.modules.core.esupports.hop.module').

return {
	setup = function()
		require("neorg").setup({
			load = {
				["core.keybinds"] = {
					config = {
						neorg_leader = "<Leader>",
					},
				},
				["core.defaults"] = {
					-- journal_folder = "~/neovim/neorg/journal",
					-- config = {
					-- 	workspace = "~/neovim/neorg/default/",
					-- },
				}, -- Loads default behaviour
				["core.concealer"] = {}, -- Adds pretty icons to your documents
				["core.esupports.hop"] = {}, -- "Hop" between Neorg links, following them with a single keypress.
				["core.dirman"] = { -- Manages Neorg workspaces
					config = {
						-- default_workspace = "default",
						open_last_workspace = false,
						workspaces = {
							default = "~/neovim/neorg/default",
							["rust-main"] = "~/hm/rust-main/notes",
						},
					},
				},
				["core.completion"] = {
					config = {
						engine = "nvim-cmp",
					},
				},
			},
		})
	end,
}

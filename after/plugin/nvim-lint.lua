require("lint").linters_by_ft = {
	-- python = { "ruff" },
	-- python = { "mypy" },
	-- python = { "pylint" },
	cpp = { "cpplint" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
	callback = function()
		require("lint").try_lint()
	end,
})

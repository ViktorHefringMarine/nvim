-- local config = {
--    name = 'pylsp',
--    cmd = {'pylsp'},
--    root_dir = vim.fs.dirname(vim.fs.find({'setup.py', 'pyproject.toml'}, { upward = true })[1]),
-- }
-- vim.lsp.start(config, {
--   reuse_client = function(client, conf)
--     return (client.name == conf.name
--       and (
--         client.config.root_dir == conf.root_dir
--         or (conf.root_dir == nil and vim.startswith(vim.api.nvim_buf_get_name(0), "/usr/lib/python"))
--       )
--     )
--   end
-- })
--

-- vim.keymap.set("n", "<leader>9", function()
--     local root_dir = vim.fn.fnamemodify("/home/viktor/hm/research/route-guidance-analysis/bathymetry/src/main.rs", ":~:.")
--     while true do
--         root_dir = vim.fn.fnamemodify(root_dir, ":h")
--         if root_dir:find("/") == nil then
--             break
--         end
--     end
--
--     if root_dir == "src" then
--         print("root-dir is source")
--     else
--         print("you're in a workspace")
--     end
--
-- end, {})
--
--
--

vim.keymap.set("n", "<leader>es", "<CMD>so ~/.config/nvim/tmp.lua<CR>", {})
--
-- ---@class Location
-- ---@field character number
-- ---@field line number
--
-- ---@class Range
-- ---@field start Location
-- ---@field end Location
--
-- ---@class ImplItem
-- ---@field originSelectionRange Range
-- ---@field targetRange Range
-- ---@field targetSelectionRange Range
--
-- -- local function get_values
--
--
-- local function letsgo()
--     -- local val = "textDocument/typeDefinition"
-- 	local res = vim.lsp.buf_request_sync(0, "textDocument/implementation", vim.lsp.util.make_position_params())
-- 	if res == nil then
-- 		print("error in func")
-- 		return nil
-- 	end
--
-- 	---@type ImplItem[]|nil
-- 	local values = table.remove(res, 1)["result"]
-- 	if values == nil then
-- 		print("invalid respond")
-- 		return nil
-- 	end
--
--     vim.pretty_print(values)
--     -- return
--
-- 	-- print("-----------------------------------------------------------------")
-- 	-- for _, item in ipairs(values) do
-- 	-- 	print()
-- 	-- 	local osr_txt = vim.api.nvim_buf_get_text(
-- 	-- 		0,
-- 	-- 		item.originSelectionRange.start.line,
-- 	-- 		item.originSelectionRange.start.character,
-- 	-- 		item.originSelectionRange["end"].line,
-- 	-- 		item.originSelectionRange["end"].character,
-- 	-- 		{}
-- 	-- 	)
-- 	-- 	local tsr_txt = vim.api.nvim_buf_get_text(
-- 	-- 		0,
-- 	-- 		item.targetSelectionRange.start.line,
-- 	-- 		item.targetSelectionRange.start.character,
-- 	-- 		item.targetSelectionRange["end"].line,
-- 	-- 		item.targetSelectionRange["end"].character,
-- 	-- 		{}
-- 	-- 	)
-- 	-- 	local tr_txt = vim.api.nvim_buf_get_text(
-- 	-- 		0,
-- 	-- 		item.targetRange.start.line,
-- 	-- 		item.targetRange.start.character,
-- 	-- 		item.targetRange["end"].line,
-- 	-- 		item.targetRange["end"].character,
-- 	-- 		{}
-- 	-- 	)
-- 	-- 	print("origin-selection-range")
-- 	-- 	vim.pretty_print(osr_txt)
-- 	-- 	print("target-selection-range")
-- 	-- 	vim.pretty_print(tsr_txt)
-- 	-- 	print("target-range")
-- 	-- 	vim.pretty_print(tr_txt)
--  --        print("--")
-- 	--
-- 	-- 	-- local target_range = vim.api.nvim_buf_get_text(item.targetRange)
-- 	-- 	-- local target_selection_range = vim.api.nvim_buf_get_text(item.targetSelectionRange)
-- 	-- end
-- end
--
-- -- local function letsgo(options)
-- -- 	local name = "textDocument/implementation"
-- -- 	local params = vim.lsp.util.make_position_params()
-- --
-- -- 	local req_handler
-- -- 	-- if options then
-- --     options = {}
-- --     req_handler = function(err, result, ctx, config)
-- --         local client = vim.lsp.get_client_by_id(ctx.client_id)
-- --         print("client")
-- --         -- vim.pretty_print(client)
-- --         local handler = client.handlers[name] or vim.lsp.handlers[name]
-- --         handler(err, result, ctx, vim.tbl_extend("force", config or {}, options))
-- --
-- --     end
-- -- 	-- end
-- --
-- --     local res, err = vim.lsp.buf_request(0, name, params, req_handler)
-- --     -- vim.lsp._cmd_parts
-- --
-- --     print("------------------------------------")
-- --     vim.pretty_print(res)
-- --     -- vim.pretty_print(err())
-- --     -- local res = err()
-- --
-- --
-- -- end
-- -- letsgo()

-- local Path = require("plenary.path")
-- local channel = require("plenary.async.control").channel
-- local async = require("plenary.async")
--
-- local function async_test()
-- 	local files = {
-- 		"/home/viktor/hm/research/route-guidance-analysis/bathymetry/src/main.rs",
-- 		"/home/viktor/hm/research/route-guidance-analysis/bathymetry/src/dog_able.rs",
-- 		"/home/viktor/hm/research/route-guidance-analysis/shared/src/plot.rs",
-- 	}
--
-- 	print("----------------------------------------------------------------------------------")
-- 	---@type table
-- 	local outp = {}
--
-- 	local sender, receiver = channel.mpsc()
--
-- 	for i, f in ipairs(files) do
-- 		---@type Path
-- 		async.run(function()
-- 			local path = Path:new(f)
-- 			path:read(function()
-- 				sender.send()
-- 			end)
-- 		end)
-- 	end
-- 	-- vim.loop.sleep(1000)
--
-- 	local r_count = 0
-- 	while r_count < #files do
-- 		local data = receiver.recv()
-- 		print("lets")
-- 		table.insert(outp, data)
-- 		r_count = r_count + 1
-- 		print("received " .. r_count)
-- 	end
-- 	for index, value in ipairs(outp) do
-- 		print("-----")
-- 		print(index)
-- 		vim.pretty_print(value)
-- 	end
-- end
--
-- async.run(async_test)

-- local function mysplit (inputstr, sep)
--         if sep == nil then
--                 sep = "%s"
--         end
--         local t={}
--         for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
--                 table.insert(t, str)
--         end
--         return t
-- end
--
--
-- local function testing()
--     ---@type string
-- 	local tmp_value =  vim.api.nvim_command_output("!list-features")
--     ---@type table
--     local vals = mysplit(tmp_value, "\n")
--     vim.pretty_print(vals)
-- end
--
-- testing()

vim.ui.select({ "tabs", "spaces" }, {
	prompt = "Select tabs or spaces:",
	format_item = function(item)
		return "I'd like to choose " .. item
	end,
}, function(choice)
	if choice == "spaces" then
		vim.o.expandtab = true
	else
		vim.o.expandtab = false
	end
end)

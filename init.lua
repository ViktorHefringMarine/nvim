require('viktor')
require('fidget').setup({})

-- local should_profile = os.getenv("NVIM_PROFILE")
-- if should_profile then
--   require("profile").instrument_autocmds()
--   if should_profile:lower():match("^start") then
--     require("profile").start("*")
--   else
--     require("profile").instrument("*")
--   end
-- end
--
-- local function toggle_profile()
--   local prof = require("profile")
--   if prof.is_recording() then
--     prof.stop()
--     vim.ui.input({ prompt = "Save profile to:", completion = "file", default = "profile.json" }, function(filename)
--       if filename then
--         prof.export(filename)
--         vim.notify(string.format("Wrote %s", filename))
--       end
--     end)
--   else
--     prof.start("*")
--   end
-- end
-- vim.keymap.set("", "<f1>", toggle_profile)
--

local function toggle_profile()
    if _G.__toggle_profile then
        vim.cmd("profile pause")
        vim.cmd("noautocmd qall!")
    else
        vim.cmd("TSContextDisable")
        vim.cmd("TSDisable highlight")
        vim.cmd("TSDisable indent")
        vim.cmd("profile start profile.log")
        vim.cmd("profile func *")
        vim.cmd("profile file *")
        _G.__toggle_profile = true
    end
end
vim.keymap.set("", "<f1>", toggle_profile)


-- vim.cmd [[
--   augroup strdr4605
--     autocmd FileType typescript,typescriptreact compiler tsc | setlocal makeprg=npx\ tsc
--   augroup END
-- ]]

-- local augroup = vim.api.nvim_create_augroup("strdr4605", { clear = true })
-- vim.api.nvim_create_autocmd("FileType", {
--   pattern = "typescript,typescriptreact",
--   group = augroup,
--   command = "compiler tsc | setlocal makeprg=npx\\ tsc",
-- })
-- vim.cmd [[
--   augroup strdr4605
--     autocmd FileType typescript,typescriptreact set makeprg=./node_modules/.bin/tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'
--   augroup END
-- ]]
--

-- vim.cmd('set makeprg=npm\\ start\\ --port\\ 3000')
-- vim.cmd[[
--     compiler tsc
--     " set makeprg=./node_modules/.bin/tsc\ \\\|\ sed\ 's/(\\(.*\\),\\(.*\\)):/:\\1:\\2:/'
--     " set efm=%-P%f,
--     "         \%E%>\ #%n\ %m,%Z%.%#Line\ %l\\,\ Pos\ %c,
--     "                     \%-G%f\ is\ OK.,%-Q
-- ]]








-- /home/viktor/repos/ex/rust_warp_api


M = {}

local function file_exists(name)
    local f = io.open(name, "r")
    if f ~= nil then io.close(f) return true else return false end
end

-- https://stackoverflow.com/a/20460403
local function findLast(haystack, needle)
    local i = haystack:match(".*" .. needle .. "()")
    if i == nil then return nil else return i - 1 end
end

local function parent_dir(dir)
    return dir:sub(1, findLast(dir, '/') - 1)
end

local term_pattern = parent_dir(os.getenv('HOME'))


local function find_root(path, patterns)
    if type(path)~='string' then
        error("path argument in rooter.find_root_dir() should be a string")
    elseif type(patterns) ~='table' then
        error("path argument in rooter.find_root_dir() should be a string")
    elseif #patterns == 0 then
        error("'patterns' argument is of len 0")
    end

    while path ~= term_pattern do
        for _, dir in ipairs(patterns) do
            if file_exists(path .. '/' .. dir) then
                return path
            end
        end
        path = parent_dir(path)
    end

    error("No-match: \npath: "..path)
end


local function get_root_directory(file)
    local file_abs = vim.fn.expand(file .. ":p")
    local dot_root_path = vim.fn.finddir("build", file_abs .. ";")
    return vim.fn.fnamemodify(dot_root_path, ":p:h")
end
M.get_relative_path_to_file = function(file)
    local dot_file_path = vim.fn.expand(file)
    return vim.fn.fnamemodify(dot_file_path, "%:~:.:h")
end
local function get_relative_path_to_directory(file)
    local dot_file_path = vim.fn.expand(file .. ":h")
    return vim.fn.fnamemodify(dot_file_path, "%:~:.:p")
end

local function exists(name)
    if type(name) ~= "string" then return false end
    return os.rename(name, name) and true or false
end

local function isFile(name)
    if type(name) ~= "string" then return false end
    if not exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end

M.get_parent_folder = function(file)
    local dot_file_path = vim.fn.expand(file .. ":h:t")
    return vim.fn.fnamemodify(dot_file_path, "%:p:p")
end
M.get_parent_parent_folder = function(file)
    -- local dot_file_path = vim.fn.expand(file..":p:h:h:t")
    return vim.fn.fnamemodify(file, ":p:h:t")
end

M.string_contains = function(outer, inner)
    return outer:match('%f[%a]' .. inner .. '%f[%A]') ~= nil
end

local function is_test_file(filename)
    return string.sub(filename, 0, 4) == "test"
end

local function get_exe_name_folder(file)
    local exe1 = vim.fn.expand(file .. ":t:r")
    if not is_test_file(exe1) then
        error("\nERROR: Not a test file")
    end
    -- local parent_folder = _G.get_parent_parent_folder(file)
    -- local parent_folder = vim.fn.expand(file..":h:t")
    local parent_folder = string.gsub(vim.fn.expand(file .. ":h:t"), "-", "_")
    local exe2 = "test_" .. parent_folder .. "_" .. string.sub(exe1, 6, -1)

    local relative_path = get_relative_path_to_directory(file)
    -- local relative_path = vim.fn.fnamemodify(vim.fn.expand(file..":h"), 'p:~:.')
    local root_dir = get_root_directory(file)

    local cwd = vim.fn.getcwd()
    local build_dir = root_dir .. "/build"

    if (string.len(root_dir) ~= string.len(cwd)) then
        local sub_folder = string.sub(cwd, string.len(root_dir) + 1, -1)
        build_dir = build_dir .. sub_folder
    end


    local exe_dir_abs_path = build_dir .. "/" .. relative_path .. '/'

    local exe1_abs_path = exe_dir_abs_path .. "/" .. exe1
    local exe2_abs_path = exe_dir_abs_path .. "/" .. exe2

    if (isFile(exe1_abs_path)) then
        return vim.fn.fnamemodify(exe1_abs_path, ":h")
    elseif (isFile(exe2_abs_path)) then
        return vim.fn.fnamemodify(exe2_abs_path, ":h")
    else
        error("No Executable found\n" .. exe1_abs_path .. "\n" .. exe2_abs_path)
    end
end

local function get_exe_name(file)

    local root_dir = find_root(file, {"build"})
    local relative_path = string.gsub(file, root_dir, "")
    local build_dir = root_dir .. "/build"

    local executable = build_dir .. vim.fn.fnamemodify(relative_path, ":r")

    return executable


    -- local exe1 = vim.fn.expand(file .. ":t:r")
    -- if not is_test_file(exe1) then
    --     error("\nERROR: Not a test file")
    -- end
    -- -- local parent_folder = _G.get_parent_parent_folder(file)
    -- local parent_folder = string.gsub(vim.fn.expand(file .. ":h:t"), "-", "_")
    -- local exe2 = "test_" .. parent_folder .. "_" .. string.sub(exe1, 6, -1)
    --
    --
    -- local relative_path = get_relative_path_to_directory(file)
    -- local root_dir = get_root_directory(file)
    --
    --
    -- local cwd = vim.fn.getcwd()
    -- local build_dir = root_dir .. "/build"
    --
    --
    -- if (string.len(root_dir) ~= string.len(cwd)) then
    --     local sub_folder = string.sub(cwd, string.len(root_dir) + 1, -1)
    --     build_dir = build_dir .. sub_folder
    -- end
    --
    -- local exe_dir_abs_path = build_dir .. "/" .. relative_path
    --
    -- print("exe dir : "..exe_dir_abs_path)
    -- local exe1_abs_path = exe_dir_abs_path .. "/" .. exe1
    -- local exe2_abs_path = exe_dir_abs_path .. "/" .. exe2
    --
    --
    -- if (isFile(exe1_abs_path)) then
    --     return exe1
    -- elseif (isFile(exe2_abs_path)) then
    --     return exe2
    -- else
    --     error("No Executable found\n" .. exe1_abs_path .. "\n" .. exe2_abs_path)
    -- end
end

M.run_test = function(file, with_valgrind)

    -- local relative_path = get_relative_path_to_directory(file)

    local harpoon = require('harpoon.term')

    local cr = "\r"

    -- filename without extension
    local exe_path, exe_folder, status

    status, exe_path = pcall(get_exe_name, file)
    if not status then
        print("error calling get_exe_name")
        print(exe_path)
        return 0
    end
    --
    -- local exe_call
    -- if with_valgrind ~= nil then
    --     exe_call = "valgrind ./" .. exe_path
    -- else
    --     exe_call = "./" .. exe_path
    -- end
    --
    -- local run_test = exe_call
    --
    -- local cd_back_to_root = "cd " .. get_root_directory(file)

    local root_dir = find_root(file, {"build"})
    local build_dir = root_dir .. "/build"

    local relative_path = string.gsub(file, root_dir, "")
    local exe_dir = build_dir .. vim.fn.fnamemodify(relative_path, ":h")
    local exe_name = vim.fn.fnamemodify(exe_path, ":t")




    -- run test
    -- vim.cmd('winc l')
    -- harpoon.gotoTerminal(1)
    require('harpoon.tmux').sendCommand('!', cr)
    require('harpoon.tmux').sendCommand('!',
        "echo && echo =================================== && echo - Configure Tests && echo --- " ..
        exe_path ..
        " && echo =================================== && echo " ..
        "&& cd " .. build_dir .. " && cd " .. exe_dir .."&& make " .. exe_name ..
        "&& ./" .. exe_name .. " && " .. "cd ".. root_dir .. cr)

    print("Test Executed: " .. exe_name)
end

M.run_test("/home/viktor/hm/fogeval/tests/fogeval/neural_network/test_model.cpp")

return M

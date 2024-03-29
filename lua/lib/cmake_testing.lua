
_G.get_root_directory = function(file)
    local file_abs = vim.fn.expand(file .. ":p")
    local dot_root_path = vim.fn.finddir("build", file_abs .. ";")
    return vim.fn.fnamemodify(dot_root_path, ":p:h:h")
end
_G.get_relative_path_to_file = function(file)
    local dot_file_path = vim.fn.expand(file)
    return vim.fn.fnamemodify(dot_file_path, "%:~:.:h")
end
_G.get_relative_path_to_directory = function(file)
    local dot_file_path = vim.fn.expand(file .. ":h")
    return vim.fn.fnamemodify(dot_file_path, "%:~:.:p")
end

_G.exists = function(name)
    if type(name) ~= "string" then return false end
    return os.rename(name, name) and true or false
end

_G.isFile = function(name)
    if type(name) ~= "string" then return false end
    if not exists(name) then return false end
    local f = io.open(name)
    if f then
        f:close()
        return true
    end
    return false
end

_G.get_parent_folder = function(file)
    local dot_file_path = vim.fn.expand(file .. ":h:t")
    return vim.fn.fnamemodify(dot_file_path, "%:p:p")
end
_G.get_parent_parent_folder = function(file)
    -- local dot_file_path = vim.fn.expand(file..":p:h:h:t")
    return vim.fn.fnamemodify(file, ":p:h:t")
end

_G.string_contains = function(outer, inner)
    return outer:match('%f[%a]' .. inner .. '%f[%A]') ~= nil
end

_G.is_test_file = function(filename)
    return string.sub(filename, 0, 4) == "test"
end

_G.get_exe_name_folder = function(file)
    local exe1 = vim.fn.expand(file .. ":t:r")
    if not is_test_file(exe1) then
        error("\nERROR: Not a test file")
    end
    -- local parent_folder = _G.get_parent_parent_folder(file)
    -- local parent_folder = vim.fn.expand(file..":h:t")
    local parent_folder = string.gsub(vim.fn.expand(file .. ":h:t"), "-", "_")
    local exe2 = "test_" .. parent_folder .. "_" .. string.sub(exe1, 6, -1)

    local relative_path = _G.get_relative_path_to_directory(file)
    -- local relative_path = vim.fn.fnamemodify(vim.fn.expand(file..":h"), 'p:~:.')
    local root_dir = _G.get_root_directory(file)

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

_G.get_exe_name = function(file)

    local exe1 = vim.fn.expand(file .. ":t:r")
    if not is_test_file(exe1) then
        error("\nERROR: Not a test file")
    end
    -- local parent_folder = _G.get_parent_parent_folder(file)
    local parent_folder = string.gsub(vim.fn.expand(file .. ":h:t"), "-", "_")
    local exe2 = "test_" .. parent_folder .. "_" .. string.sub(exe1, 6, -1)


    local relative_path = _G.get_relative_path_to_directory(file)
    local root_dir = _G.get_root_directory(file)


    local cwd = vim.fn.getcwd()
    local build_dir = root_dir .. "/build"


    if (string.len(root_dir) ~= string.len(cwd)) then
        local sub_folder = string.sub(cwd, string.len(root_dir) + 1, -1)
        build_dir = build_dir .. sub_folder
    end

    local exe_dir_abs_path = build_dir .. "/" .. relative_path

    local exe1_abs_path = exe_dir_abs_path .. "/" .. exe1
    local exe2_abs_path = exe_dir_abs_path .. "/" .. exe2


    if (isFile(exe1_abs_path)) then
        return exe1
    elseif (isFile(exe2_abs_path)) then
        return exe2
    else
        error("No Executable found\n" .. exe1_abs_path .. "\n" .. exe2_abs_path)
    end
end

_G.run_test = function(file, with_valgrind)
    local build_dir = _G.get_root_directory(file)

    local relative_path = _G.get_relative_path_to_directory(file)

    local harpoon = require('harpoon.term')

    local cr = "\r"

    -- filename without extension
    local exe_name, exe_folder, status

    status, exe_name = pcall(get_exe_name, file)
    if not status then
        print(exe_name)
        return 0
    end

    status, exe_folder = pcall(get_exe_name_folder, file)
    if not status then
        print(exe_name)
        return 0
    end

    -- enter build-directory
    local cd_build_dir = "cd " .. build_dir .. "/build"

    -- configure build
    local conf_build = "cmake -DCMAKE_BUILD_TYPE=DEBUG --DDEBUG_MOSQUITTO=1 .."

    -- enter relative-test-directory
    local cd_rel_test_dir = "echo && cd " .. relative_path


    local build = "echo && echo Build Test && echo && make -j12 " .. exe_name

    local exe_call
    if with_valgrind ~= nil then
        exe_call = "valgrind ./" .. exe_name
    else
        exe_call = "./" .. exe_name
    end

    local run_test = exe_call

    local cd_back_to_root = "cd " .. _G.get_root_directory(file)

    -- run test
    -- vim.cmd('winc l')
    -- harpoon.gotoTerminal(1)
    harpoon.sendCommand(1, cr)
    harpoon.sendCommand(1,
        "echo && echo =================================== && echo - Configure Tests && echo --- " ..
        exe_name ..
        " && echo =================================== && echo " ..
        "&&" .. cd_build_dir .. "&& cmake .. && make && cd " .. exe_folder ..
        " && " .. run_test .. " && " .. cd_back_to_root .. cr)

    print("Test Executed: " .. exe_name)
end

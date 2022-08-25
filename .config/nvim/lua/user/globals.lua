--[[ Global functions, useful for plugin develpment. Taken from TJ DeVries ]]

local ok, plenary_reload = pcall(require, "plenary.reload")
if not ok then reloader = require else reloader = plenary_reload.reload_module end

P = function (obj)
    print(vim.inspect(obj))
    return obj
end

RELOAD = function (...)
    return reloader(...)
end

R = function (name)
    RELOAD(name)
    return require(name)
end

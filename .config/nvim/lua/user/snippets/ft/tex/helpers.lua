local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node

local M = {}

-- TODO: function that checks if inside of math environment
-- TODO: function that checks if inside table
-- TODO: function that checks if inside the document
-- TODO: function that checks if inside an itemize-like environment

---Checks if texlab is running
---@return boolean
function M.texlab_active()
    local clients_table = vim.lsp.get_active_clients({ name = "texlab" })
    if type(clients_table) == "table" and clients_table.texlab ~= nil then
        return true
    end
    return false
end

--- Checks if a LaTeX package is loaded using a treesitter query
---@param pkgname string
---@param bufnr? number
---@return boolean
function M.is_pkg_loaded(pkgname, bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local root = M.get_root(bufnr)
    local current_row = vim.api.nvim_win_get_cursor(0)[1]
    local query = vim.treesitter.query.parse(
        "latex",
        [[
        ((package_include 
            paths: (curly_group_path_list
                path: (path) @pth
                (#eq? @pth "]]
            .. pkgname
            .. [[")
                )) @usepkg)
        ]]
        -- [[ ((path) @pth
        --         (#eq? @pth "]] .. pkgname .. [[")
        --         (#has-ancestor? @pth package_include)
        --     )
        -- ]])
    )
    for id, node, _ in query:iter_captures(root, bufnr, 0, current_row) do
        local name = query.captures[id] -- name of the capture in the query
        if name == "pth" then
            local n = node
            if n ~= nil then
                return true
            end
        end
    end
    return false
end

--- Finds the first instance of `\usepackage`, or, if none are present, `\documentclass`
---@param bufnr integer? The number of the buffer to search in
---@returns integer|nil
function M.find_first_include(bufnr)
    bufnr = bufnr or vim.api.nvim_get_current_buf()
    local root = M.get_root(bufnr)
    local current_row = vim.api.nvim_win_get_cursor(0)[1]

    local query_usepkg = vim.treesitter.query.parse("latex", [[ (package_include) @usepkg ]])
    for id, node, _ in query_usepkg:iter_captures(root, bufnr, 0, current_row) do
        local name = query_usepkg.captures[id] -- name of the capture in the query
        if name == "usepkg" then
            local n = node
            if n ~= nil then
                local range = { n:range() }
                local row = range[1]
                if row ~= nil then
                    return row
                end
            end
        end
    end

    local query_docclass = vim.treesitter.query.parse("latex", [[(class_include) @cls]])
    for id, node, _ in query_docclass:iter_captures(root, bufnr, 0, current_row) do
        local name = query_docclass.captures[id] -- name of the capture in the query
        if name == "cls" then
            local n = node
            if n ~= nil then
                -- Can only insert usepackage after documentclass, so get the last row
                local range = { n:range() }
                local end_row = range[3]
                if end_row ~= nil then
                    return end_row
                end
            end
        end
    end
    return nil
end

---@param pkgname string The name of the LaTeX package
---@param opts? string|table Either a string or a key-value table containing the options for the LaTeX package
---@return string|nil
function M.format_pkg_include(pkgname, opts)
    if type(pkgname) ~= "string" then
        return nil
    end
    opts = opts or ""
    if opts == "" then
        return "\\usepackage{" .. pkgname .. "}"
    elseif type(opts) == "string" then
        return "\\usepackage[" .. opts .. "]{" .. pkgname .. "}"
    elseif type(opts) == "table" then
        local line = "\\usepackage["
        local flat_opts = {}
        for a, b in pairs(opts) do
            table.insert(flat_opts, tostring(a) .. "=" .. tostring(b))
        end
        return line .. table.concat(flat_opts, ",") .. "]{" .. pkgname .. "}"
    else
        return nil
    end
end

--- Insterts a `\usepackage` line
---@param pkgname string The name of the LaTeX package
---@param opts? string|table Either a string or a key-value table containing the options for the LaTeX package, optional
---@param buffer integer? The number of the buffer, default is current buffer
function M.write_pkg_include(pkgname, opts, buffer)
    buffer = buffer or vim.api.nvim_get_current_buf()
    opts = opts or ""
    local row_included = M.is_pkg_loaded(pkgname, vim.api.nvim_get_current_buf())
    if row_included == false then
        local location = M.find_first_include() or 0
        local include_statement = M.format_pkg_include(pkgname, opts)
        if include_statement ~= nil then
            vim.api.nvim_buf_set_lines(buffer, location, location, true, { include_statement })
        else
            vim.notify("Cannot make an `include` statement for " .. pkgname, vim.log.levels.ERROR)
        end
    end
end

---If the package `package_name` is not loaded, then it creates the `usepackage` statement for that package.
---@param package_name string The name of the package
---@param command_name string? Optional if command is different from package
---@return string command_name
function M.package_importer(package_name, command_name)
    if type(package_name) ~= "string" then
        return ""
    end
    command_name = command_name or package_name
    if type(command_name) ~= "string" then
        return ""
    end
    if M.is_pkg_loaded(package_name) then
        return command_name
    else
        M.write_pkg_include(package_name)
        vim.notify("The package " .. package_name .. " has been imported", vim.log.levels.INFO)
        return command_name
    end
end

---When `LS_SELECT_RAW` contains a visual selection, return an insert node where the text is set to the visual
---selection, with every line preceeded with an `\item`. When it is empty, returns an empty insert node
function M.get_visual_itemize(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        local res = {}
        for _, ele in ipairs(parent.snippet.env.LS_SELECT_RAW) do
            table.insert(res, "\t\\item " .. ele)
        end
        return sn(nil, i(1, res))
    else -- if LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

---@param args table table of table of text
---@param parent nil needed
function M.transform_table_position(args, parent)
    local a = args[1][1]
    if a == "h" then
        return " % here approx."
    elseif a == "t" then
        return " % top of page"
    elseif a == "b" then
        return " % bottom of page"
    elseif a == "p" then
        return " % special page"
    elseif a == "H" then
        return " % place here"
    end
end

return M

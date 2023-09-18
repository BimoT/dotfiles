local ls = require("luasnip")
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node

local M = {}

---Checks if an LSP server is running
---@param name string the name of the LSP server
---@return boolean
function M.lsp_active(name)
    local clients_table = vim.lsp.get_active_clients({ name = name })[1]
    if type(clients_table) == "table" and clients_table[name] ~= nil then
        return true
    end
    return false
end

--- Gets the root of the tree in the buffer
--- (from tjdevries config)
---@param bufnr number
function M.get_root(bufnr)
    local parser = vim.treesitter.get_parser(bufnr, "latex", {})
    local tree = parser:parse()[1]
    return tree:root()
end

---When `LS_SELECT_RAW` contains a visual selection, return an insert node where the text is set to the visual
---selection. When it is empty, returns an empty insert node
function M.get_visual(args, parent)
    if #parent.snippet.env.LS_SELECT_RAW > 0 then
        return sn(nil, i(1, parent.snippet.env.LS_SELECT_RAW))
    else -- if LS_SELECT_RAW is empty, return a blank insert node
        return sn(nil, i(1))
    end
end

return M

--[[ ftplugin for latex files ]]
-- TODO: Make opening the pdf more robust (check if exists)

vim.opt_local.spelllang = "en_us"
vim.opt_local.spell = true

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then
    return
end
local Job = require("plenary.job")

local function open_pdf()
    if vim.fn.has("win32") == 1 then
        vim.cmd(":!%:r.pdf<CR>")
    else
        local opener_linux = "zathura" -- The pdf reader on linux
        local current_pdf = vim.fn.expand("%:r") .. ".pdf"

        Job:new({
            command = opener_linux,
            args = { current_pdf },
            on_stderr = function()
                print("File not found?")
            end,
        })
    end
end

local function make_latex()
    --[[ Finds a makefile ]]
    local file_dir = vim.fn.expand("%:p:h")

    if vim.fn.has("win32") == 1 then
        return nil
    else
        --[[ "-verbose", ]]
        --[[ "-file-line-error", ]]
        --[[ "-synctex=1", ]]
        --[[ "-interaction=nonstopmode", ]]
        --[[  Job:new({ ]]
        --[[     command = "make", ]]
        --[[     on_stderr = function () ]]
        --[[          ]]
        --[[     end ]]
        --[[ }) ]]
    end
end

wk.register({
    ["<leader>c"] = { "<cmd>w! | make<CR>", "Compile file" },
    ["<leader>o"] = { open_pdf, "Open corresponding PDF" },
}, {
    mode = "n",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})

local environments = {
    generic_environment = true,
    verbatim_environment = true,
    math_environment = true,
}
local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")

---@return TSNode|nil
function is_inside_environment()
    local cursor_node = ts_utils.get_node_at_cursor()
    local scope = ts_locals.get_scope_tree(cursor_node, 0)
    local inside_environment
    for _, v in ipairs(scope) do
        if environments[v:type()] then
            inside_environment = v
            break
        end
    end
    if not inside_environment then
        -- vim.notify("not inside an environment", vim.log.levels.WARN)
        return nil
    end
    return inside_environment
end
local listenv_query = [[
((generic_environment
    begin: (begin
        name: (curly_group_text
            text: (text) @begin_name) )
    end: (end
        name: (curly_group_text
        text: (text) @end_name) )
(#eq? @begin_name @end_name)
(#any-of? @begin_name "itemize" "enumerate" "enumerate*" "labelling" "description")
) @env)
]]
---@param tsnode TSNode a TreeSitter node
---@return table|nil
local function is_inside_listenv(tsnode)
    local ranges = {
        beginning = {},
        ending = {},
    }
    local beginning_found, ending_found
    local query = vim.treesitter.query.parse("latex", listenv_query)
    for id, node, _ in query:iter_captures(tsnode, vim.api.nvim_get_current_buf()) do
        if beginning_found and ending_found then
            break
        end
        local name = query.captures[id] -- name of the capture in the query
        if name == "begin_name" then
            local r = { node:range() }
            ranges.beginning = { r }
            beginning_found = true
        elseif name == "end_name" then
            local r = { node:range() }
            ranges.ending = { r }
            ending_found = true
        end
    end
    if ending_found and beginning_found then
        return ranges
    else
        return nil
    end
end

wk.register({
    ["<S-CR>"] = {
        function()
            local tsnode = is_inside_environment()
            if tsnode ~= nil then
                local ranges = is_inside_listenv(tsnode)
                if ranges ~= nil then
                    -- local row, col = vim.api.nvim_win_get_cursor(0)
                    -- local line = vim.api.nvim_get_current_line()
                    -- local indentation = string.find(line, "%s+")
                    vim.cmd("norm i<c-v><cr>")
                    vim.cmd("norm i\\item")
                    vim.cmd("norm A")
                end
            else
                vim.cmd("norm i<CR>")
            end
        end,
        "Insert item",
    },
}, {
    mode = "i",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})

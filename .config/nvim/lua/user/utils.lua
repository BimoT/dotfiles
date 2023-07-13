local M = {}

---Call a function whenever an LSP gets attached to a buffer. Uses autocmd.
---@param on_attach fun(client, buffer) function that gets called
function M.on_attach(on_attach)
    vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(args)
            local buffer = args.buf
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            on_attach(client, buffer)
        end,
    })
end

---Creates autocmd on VeryLazy event
---@param fn function
function M.on_very_lazy(fn)
    vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        callback = function()
            fn()
        end,
    })
end

---Sets the foreground color
---@param name string
function M.fg(name)
    local hl = vim.api.nvim_get_hl and vim.api.nvim_get_hl(0, { name = name })
        or vim.api.nvim_get_hl_by_name(name, true)
    local fg = hl and hl.fg or hl.foreground
    return fg and { fg = string.format("#%06x", fg) }
end

---Gets the opts of a plugin.
---Uses `(lazy.nvim).core.config` under the hood
---@param name string
function M.get_opts(name)
    local plugin = require("lazy.core.config").plugins[name]
    if not plugin then
        return {}
    end

    local p = require("lazy.core.plugin")
    return p.values(plugin, "opts", false)
end

---Check if lazy.nvim has this plugin
---@param plugin string
---@return boolean
function M.lazy_has_plugin(plugin)
    return require("lazy.core.config").plugins[plugin] ~= nil
end

M.icons = {
    dap = {
        -- TODO: fix unicode character for Stopped
        Stopped = { "󰁕 ", "DiagnosticWarn", "DapStoppedLine" },
        Breakpoint = " ",
        BreakpointCondition = " ",
        BreakpointRejected = { " ", "DiagnosticError" },
        LogPoint = ".>",
    },
    lsp_diagnostics = {
        Error = " ",
        Warn = " ",
        Hint = " ",
        Info = " ",
    },

    mason_icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
    },
    cmp_icons = {
        Class = "",
        Color = "",
        Constant = "",
        Constructor = "",
        Enum = "",
        EnumMember = "",
        Event = "",
        Field = "",
        File = "",
        Folder = "",
        Function = "",
        Interface = "",
        Keyword = "",
        Method = "",
        Module = "",
        Operator = "",
        Property = "",
        Reference = "",
        Snippet = "",
        Struct = "",
        Text = "",
        TypeParameter = "",
        Unit = "",
        Value = "",
        Variable = "",
    },
    git = {
        added = " ",
        modified = " ",
        removed = " ",
    },
}

return M

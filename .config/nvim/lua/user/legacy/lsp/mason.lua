local status_ok, mason = pcall(require, "mason")
if not status_ok then return end

local servers = {
    "pyright",
    "lua_ls",
    "rust_analyzer",
    "bashls",
    "cssls",
    "html",
}

mason.setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗",
        },
    },
    log_level = vim.log.levels.INFO,
    max_concurrent_installers = 4,
})

local masonconfig_ok, masonconfig = pcall(require, "mason-lspconfig")
if not masonconfig_ok then return end

masonconfig.setup({
    ensure_installed = servers,
    automatic_installation = true,
})

local lspconfig_status_ok, lspconfig = pcall(require, "lspconfig")
if not lspconfig_status_ok then return end

local opts = {}

for _, server in pairs(servers) do
    opts = {
        on_attach = require("user.lsp.handlers").on_attach,
        capabilities = require("user.lsp.handlers").capabilities,
    }

    local serveropts_ok, serveropts = pcall(require, "user.lsp.settings" .. server)
    if serveropts_ok then
        opts = vim.tbl_deep_extend("force", serveropts, opts)
    end

    --[[ if server == "lua_ls" then ]]
    --[[     local lua_ls_opts = require("user.lsp.settings.lua_ls") ]]
    --[[     opts = vim.tbl_deep_extend("force", lua_ls_opts, opts) ]]
    --[[ end ]]

    --[[ if server == "pyright" then ]]
    --[[     local pyright_opts = require("user.lsp.settings.pyright") ]]
    --[[     opts = vim.tbl_deep_extend("force", pyright_opts, opts) ]]
    --[[ end ]]

    lspconfig[server].setup(opts)
end

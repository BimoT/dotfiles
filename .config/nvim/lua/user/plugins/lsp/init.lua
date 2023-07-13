return {
    { -- visualizes rename with lsp
        "smjonas/inc-rename.nvim",
        version = false,
        opts = {},
    },
    { -- progress indicator for lsp attatchment to buffer
        "j-hui/fidget.nvim",
        version = false,
        branch = "legacy",
        opts = {},
    },
    { -- LSP configuration, needed for lsp
        "neovim/nvim-lspconfig",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        dependencies = {
            -- { -- manage global and project-local settings
            --     --TODO: check out this plugin more
            --     "folke/neoconf.nvim",
            --     version = false,
            --     cmd = "Neoconf",
            --     config = true,
            -- },
            { -- signature help, docs and completion for the Neovim lua API
                "folke/neodev.nvim",
                version = false,
                opts = {},
            },
            "mason.nvim",
            "williamboman/mason-lspconfig.nvim",
            {
                "hrsh7th/cmp-nvim-lsp",
                -- cond = function()
                --     return require("user.utils").lazy_has_plugin("nvim-cmp")
                -- end,
            },
        },
        opts = {
            -- options for vim.diagnostic.config
            diagnostics = {
                underline = true,
                update_in_insert = true,
                signs = true,
                severity_sort = true,
                virtual_text = {
                    spacing = 4,
                    -- severity = nil,
                    source = "if_many",
                    -- source = nil,
                    -- prefix = "●",
                    prefix = "",
                    format = function(diagn)
                        local icons = require("user.utils").icons.lsp_diagnostics
                        for d, icon in pairs(icons) do
                            if diagn.severity == vim.diagnostic.severity[d:upper()] then
                                return string.format("%s %s", icon, diagn.message)
                            end
                        end
                        -- if diagn.severity == vim.diagnostic.severity.ERROR then
                        --     return string.format("E: %s", diagn.message)
                        -- end
                    end,
                },
                float = {
                    focusable = true,
                    style = "minimal",
                    border = "rounded",
                    source = "always",
                    header = "",
                    prefix = "",
                },
            },
            -- Global capabilities
            capabilities = {},
            -- Automatically format on save
            autoformat = true,
            -- options for vim.lsp.buf.format
            -- 'bufnr' and 'filter' is handled by the formatter, but can be overridden
            format = {
                formatting_options = nil,
                timeout_ms = nil,
            },
            -- LSP server settings
            servers = require("user.plugins.lsp.servers"),
            -- add extra lsp server setup here
            -- return true if you don't want this server to be setup with lspconfig
            setup = {
                -- lua_ls = function(server, opts)
                --     --TODO: check opts
                -- end,
            },
        },
        config = function(_, opts)
            local Util = require("user.utils")
            require("user.plugins.lsp.formatting").lsp_autoformat = opts.autoformat
            Util.on_attach(function(client, buffer)
                require("user.plugins.lsp.formatting").on_attach(client, buffer)
                require("user.plugins.lsp.keymaps").on_attach(client, buffer)
            end)

            -- Diagnostics
            for name, sign in pairs(Util.icons.lsp_diagnostics) do
                name = "DiagnosticSign" .. name
                vim.fn.sign_define(name, {
                    text = sign,
                    texthl = name,
                    numhl = "",
                })
            end

            vim.diagnostic.config(vim.deepcopy(opts.diagnostics))

            -- Hover handling
            vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
                border = "rounded",
            })

            vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
                border = "rounded",
            })

            local servers = opts.servers
            local capabilities = vim.tbl_deep_extend(
                "force",
                {},
                vim.lsp.protocol.make_client_capabilities(),
                require("cmp_nvim_lsp").default_capabilities(),
                opts.capabilities or {}
            )

            local function setup(server)
                local server_opts = vim.tbl_deep_extend("force", {
                    capabilities = vim.deepcopy(capabilities),
                }, servers[server] or {})

                if opts.setup[server] then
                    if opts.setup[server](server, server_opts) then
                        return
                    end
                elseif opts.setup["*"] then
                    if opts.setup["*"](server, server_opts) then
                        return
                    end
                end
                require("lspconfig")[server].setup(server_opts)
            end

            -- get all the servers that are available through mason-lspconfig
            local have_mason, mlsp = pcall(require, "mason-lspconfig")
            local all_mlsp_servers = {}
            if have_mason then
                all_mlsp_servers = vim.tbl_keys(require("mason-lspconfig.mappings.server").lspconfig_to_package)
            end

            local ensure_installed = {}
            for server, server_opts in pairs(servers) do
                if server_opts then
                    server_opts = server_opts == true and {} or server_opts
                    -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
                    if server_opts.mason == false or not vim.tbl_contains(all_mlsp_servers, server) then
                        setup(server)
                    else
                        ensure_installed[#ensure_installed + 1] = server
                    end
                end
            end

            if have_mason then
                mlsp.setup({ ensure_installed = ensure_installed })
                mlsp.setup_handlers({ setup })
            end
        end,
    },
    {
        -- integration with lsp
        "jose-elias-alvarez/null-ls.nvim",
        event = { "BufReadPre", "BufNewFile" },
        dependencies = "williamboman/mason.nvim",
        opts = function()
            local null_ls = require("null-ls")
            local formatting = null_ls.builtins.formatting
            local diagnostics = null_ls.builtins.diagnostics
            return {
                root_dir = require("null-ls.utils").root_pattern(".null-ls-root", ".neoconf.json", "Makefile", ".git"),
                sources = {
                    formatting.stylua,
                    diagnostics.flake8,
                },
            }
        end,
    },
    {
        -- LSP installer
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate", -- Automatically update Mason registry when installed
        opts = {
            ui = {
                icons = require("user.utils").icons.mason_icons,
            },
            log_level = vim.log.levels.INFO,
            max_concurrent_installers = 4,
            --HACK: leave the insure_installed empty for now
            ensure_installed = {
                -- "pyright",
                -- -- "lua_ls",
                -- "rust_analyzer",
                -- "bashls",
                -- "cssls",
                -- "html",
            },
        },
        config = function(_, opts)
            require("mason").setup(opts)
            local mr_ok, mr = pcall(require, "mason-registry")
            if not mr_ok then
                return
            end
            local function ensure_enstalled()
                for _, tool in ipairs(opts.ensure_installed) do
                    local p = mr.get_package(tool)
                    if not p:is_installed() then
                        p:install()
                    end
                end
            end
            if mr.refresh then
                mr.refresh(ensure_enstalled)
            else
                ensure_enstalled()
            end
        end,
    },
}

return {
    lua_ls = {
        -- mason = false, -- set to false if you don't want this server to be installed with mason
        settings = {
            Lua = {
                diagnostics = {
                    properties = {
                        --TODO: make sure this works correctly
                        globals = { "vim" },
                    },
                },
                completion = {
                    callSnippet = "Replace",
                },
                workspace = {
                    library = {
                        [vim.fn.expand("$VIMRUNTIME/lua")] = true,
                        [vim.fn.stdpath("config") .. "/lua"] = true,
                    },
                },
                telemetry = {
                    enable = false,
                },
            },
        },
    },
    pyright = {
        settings = {
            python = {
                analysis = {
                    typeCheckingMode = "off",
                },
            },
        },
    },
    clangd = {
        settings = {},
    },
    bashls = {},
    rust_analyzer = {
        settings = {
            ["rust-analyzer"] = {
                imports = {
                    granularity = {
                        group = "module",
                    },
                    prefix = "self",
                },
                cargo = {
                    buildScripts = {
                        enable = false,
                    },
                },
                procMacro = {
                    enable = true, -- Testing this
                },
                checkOnSave = {
                    command = "clippy",
                },
            },
        },
    },
    texlab = {
        settings = {
            texlab = {
                build = {
                    onSave = true,
                },
            },
        },
    },
}

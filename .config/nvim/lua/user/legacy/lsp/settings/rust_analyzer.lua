return {
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
                enable = false,
            },
            checkOnSave = {
                command = "clippy",
            },
        },
    },
}

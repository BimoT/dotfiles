return {
    { -- Rust: Better interaction with Cargo.toml
        "Saecki/crates.nvim",
        event = "BufRead Cargo.toml",
        dependencies = "jose-elias-alvarez/null-ls.nvim",
        version = false,
        config = function()
            local nlok, null_ls = pcall(require, "null-ls")
            if nlok then
                require("crates").setup({
                    null_ls = {
                        enabled = true,
                        name = "crates.nvim",
                    },
                })
            else
                require("crates").setup({})
                error("[-] cannot load package 'null-ls'", 2)
            end
        end,
        init = function()
            vim.api.nvim_create_autocmd("BufRead", {
                group = vim.api.nvim_create_augroup("CmpSourceCargo", { clear = true }),
                pattern = "Cargo.toml",
                callback = function()
                    local cmpok, cmp = pcall(require, "cmp")
                    if cmpok then
                        cmp.setup.buffer({ sources = { { name = "crates" } } })
                    else
                        error("[-] cannot load package 'cmp'", 2)
                    end
                end,
            })
        end,
    },
}

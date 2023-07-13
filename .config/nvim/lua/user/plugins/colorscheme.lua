return {
    { -- great colorscheme
        "dracula/vim",
        name = "dracula",
        priority = 1000,
        event = "VimEnter",
        config = function()
            vim.cmd.colorscheme("dracula")
        end,
        enabled = false,
    },
    { -- nice colorscheme, might try out
        "catppuccin/nvim",
        name = "catppuccin",
        priority = 1000,
        event = "VimEnter",
        config = function()
            require("catppuccin").setup({
                integrations = {
                    fidget = true,
                    illuminate = false, -- seems to slow things down
                    leap = true,
                    lsp_trouble = true,
                    mason = true,
                    neotree = true,
                    telescope = true,
                    treesitter = true,
                    ts_rainbow2 = true,
                    which_key = true,
                },
                -- the regular bg of todo comments is poorly visible, so we disable the bg
                highlight_overrides = {
                    all = function(colors)
                        return {
                            ["@text.todo"] = { fg = colors.text, bg = colors.none },
                            ["@text.warning"] = { fg = colors.text, bg = colors.none },
                            ["@text.danger"] = { fg = colors.text, bg = colors.none },
                            ["@text.note"] = { fg = colors.text, bg = colors.none },
                        }
                    end,
                },
            })
            vim.cmd.colorscheme("catppuccin-mocha")
        end,
        enabled = true,
    },
}

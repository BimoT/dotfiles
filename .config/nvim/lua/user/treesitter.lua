local status_ok, configs = pcall(require, "nvim-treesitter.configs")
if not status_ok then return end

configs.setup({
    ensure_installed = "all", -- one of "all" or a list of languages
    ignore_install = { "" }, -- list of parser to ignore installing
    highlight = {
        enable = true, -- false will disable the whole extension
        disable = { "css" }, -- list of languages that will be disabled
    },
    autopairs = { enable = true, },
    indent = { enable = true, disable = { "python", "css" } },
    textobjects = {
        select = {
            enable = true,
            -- Automatically jump forward to textobj, similar to targets.vim
            lookahead = true,
            keymaps = {
                -- You can use the capture groups defined in textobjects.scm
                ["af"] = "@function.outer",
                ["if"] = "@function.inner",
                ["ac"] = "@class.outer",
                ["ic"] = "@class.inner",
            },
        },
        move = {
            enable = true,
            set_jumps = true,
            goto_next_start = {
                ["]]"] = "@function.outer",
            },
            goto_previous_start = {
                ["[["] = "@function.outer",
            },
        },
        swap = {
            enable = true,
            swap_next = {
                ["<leader>swp"] = "@parameter.inner"
            },
            swap_previous = {
                ["<leader>swP"] = "@parameter.inner"
            }
        }
    },
})

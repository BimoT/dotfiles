return {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    build = ":TSUpdate",
    -- event = {"BufReadPost", "BufNewFile"},
    dependencies = {
        {
            "nvim-treesitter/nvim-treesitter-textobjects",
            init = function()
                --TODO: figure this out
            end,
        },
        {
            -- view treesitter information
            "nvim-treesitter/playground",
        },
    },
    opts = {
        ensure_installed = "all", -- one of "all" or a list of languages
        ignore_install = { "" }, -- list of parser to ignore installing
        highlight = {
            enable = true, -- false will disable the whole extension
            additional_vim_regex_highlighting = false,
            -- disable = { "css" }, -- list of languages that will be disabled
        },
        context_commentstring = {
            enable = true,
            enable_autocmd = false,
        },
        autopairs = { enable = true },
        indent = {
            enable = true,
            -- disable = { "python", "css" }
        },
        rainbow = {
            enable = true,
            query = "rainbow-parens",
            strategy = require("ts-rainbow").strategy.global,
        },
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
                -- TODO: conflicting keymap with <leader>s, so this is disabled for now. find better keymap
                enable = false,
                -- swap_next = {
                --     ["<leader>swp"] = "@parameter.inner"
                -- },
                -- swap_previous = {
                --     ["<leader>swP"] = "@parameter.inner"
                -- }
            },
        },
        playground = {
            enable = true,
            disable = {},
            updatetime = 25, -- Debounced time fo rhighlighting nodes in the playground from source
            persist_queries = false, -- Whether the query persists across vim sessions
            keybindings = {
                toggle_query_editor = "o",
                toggle_hl_groups = "i",
                toggle_injected_languages = "t",
                toggle_anonymous_nodes = "a",
                toggle_language_display = "I",
                focus_language = "f",
                unfocus_language = "F",
                update = "R",
                goto_node = "<CR>",
                show_help = "?",
            },
        },
    },
    config = function(_, opts)
        require("nvim-treesitter.configs").setup(opts)
    end,
}

-- This holds (most) of the coding-related plugins
-- The completion-related plugins are in their own file

return {
    { -- easier surrounding of text objects with quotes, braces, etc.
        "kylechui/nvim-surround",
        version = false,
        opts = {},
    },
    { -- plenary is used in many plugins as a dependency
        "nvim-lua/plenary.nvim",
        version = false,
    },
    { -- case conversion, abbreviations, substitutions
        --TODO: check out this plugin more
        "tpope/vim-abolish",
        version = false,
    },
    { -- align text
        "tommcdo/vim-lion",
        event = "VeryLazy",
        version = false,
    },
    { -- Split and join lines
        "AndrewRadev/splitjoin.vim",
        version = false,
    },
    { -- easy uncomment/comment
        "numToStr/Comment.nvim",
        version = false,
        event = "VeryLazy",
        dependencies = {
            -- comments for files with multiple languages
            -- "JoosepAlviste/nvim-ts-context-commentstring",
        },
        opts = {
            -- pre_hook = require("ts_context_commentstring.integrations.comment_nvim").create_pre_hook(),
        },
        init = function()
            local ft = require("Comment.ft")
            ft.set("lua", "-- %s")
        end,
    },
    { -- Search and replace in multiple files
        "nvim-pack/nvim-spectre",
        version = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
        },
        opts = { open_cmd = "noswapfile vnew" },
        -- stylua: ignore
        -- keys = k.spectre.keys,
        -- {
        --     { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
        -- },
    },
    { -- color delimiters based on nesting level
        "HiPhish/nvim-ts-rainbow2",
        version = false,
        dependencies = "nvim-treesitter/nvim-treesitter",
    },
    { -- easily jump to any location and enhanced f/t motions for Leap
        "ggandor/flit.nvim",
        keys = function()
            local ret = {}
            for _, key in ipairs({ "f", "F", "t", "T" }) do
                ret[#ret + 1] = { key, mode = { "n", "x", "o" }, desc = key }
            end
            return ret
        end,
        opts = {
            labeled_modes = "nx",
            multiline = false, -- because we already have leap
        },
    },
    { -- Updated version of hop
        "ggandor/leap.nvim",
        version = false,
        dependencies = {
            "tpope/vim-repeat",
        },
        -- keys = k.leap.keys,
        -- {
        --     { "<leader>hf", "<Plug>(leap-forward-to)", mode = "n", desc = "Leap forward to" },
        --     { "<leader>hb", "<Plug>(leap-backward-to)", mode = "n", desc = "Leap backward to" },
        -- },
        opts = {},
    },
    { -- git signs
        "lewis6991/gitsigns.nvim",
        version = false,
        event = { "BufReadPre", "BufNewFile" },
        opts = {
            signs = {
                add = {
                    hl = "GitSignsAdd",
                    text = "▎",
                    numhl = "GitSignsAddNr",
                    linehl = "GitSignsAddLn",
                },
                change = {
                    hl = "GitSignsChange",
                    text = "▎",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                delete = {
                    hl = "GitSignsDelete",
                    text = "契",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                topdelete = {
                    hl = "GitSignsDelete",
                    text = "契",
                    numhl = "GitSignsDeleteNr",
                    linehl = "GitSignsDeleteLn",
                },
                changedelete = {
                    hl = "GitSignsChange",
                    text = "▎",
                    numhl = "GitSignsChangeNr",
                    linehl = "GitSignsChangeLn",
                },
                -- untracked = { text = "▎" },
            },
        },
    },
    { -- view git diff in 1 window
        "sindrets/diffview.nvim",
        cmd = { "DiffviewOpen", "DiffviewFileHistory" },
        version = false,
        opts = {},
    },
    { -- Highlight references
        "RRethy/vim-illuminate",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        opts = { delay = 200 },
        config = function(_, opts)
            require("illuminate").configure(opts)
            vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }

            --TODO: make sure this shows up in which-key
            local function map(key, dir, buffer)
                vim.keymap.set("n", key, function()
                    require("illuminate")["goto_" .. dir .. "_reference"](false)
                end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
            end

            map("]]", "next")
            map("[[", "prev")

            -- also set it after loading ftplugins, since a lot overwrite [[ and ]]
            vim.api.nvim_create_autocmd("FileType", {
                callback = function()
                    local buffer = vim.api.nvim_get_current_buf()
                    map("]]", "next", buffer)
                    map("[[", "prev", buffer)
                end,
            })
        end,
        keys = {
            { "]]", desc = "Next Reference" },
            { "[[", desc = "Prev Reference" },
        },
    },
    { -- good diagnostics
        "folke/trouble.nvim",
        version = false,
        cmd = { "TroubleToggle", "Trouble" },
        opts = {
            use_diagnostic_signs = true,
        },
        -- keys = k.trouble.keys,
        -- {
        --     { "<leader>dd", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
        --     { "<leader>dw", "<cmd>TroubleToggle workplace_diagnostics<cr>", desc = "Workplace Diagnostics (Trouble)" },
        --     { "<leader>dl", "<cmd>TroubleToggle loclist<cr>", desc = "Location List (Trouble)" },
        --     { "<leader>dq", "<cmd>TroubleToggle quickfix<cr>", desc = "Quickfix List (Trouble)" },
        --     {
        --         "[q",
        --         function()
        --             if require("trouble").is_open() then
        --                 require("trouble").previous({
        --                     skip_groups = true,
        --                     jump = true,
        --                 })
        --             else
        --                 vim.cmd.cprev()
        --             end
        --         end,
        --         desc = "Previous trouble/quickfix item",
        --     },
        --     {
        --         "]q",
        --         function()
        --             if require("trouble").is_open() then
        --                 require("trouble").next({
        --                     skip_groups = true,
        --                     jump = true,
        --                 })
        --             else
        --                 vim.cmd.cnext()
        --             end
        --         end,
        --         desc = "Next trouble/quickfix item",
        --     },
        -- },
    },
    { -- highlights --TODO and similar comments
        "folke/todo-comments.nvim",
        dependencies = "nvim-lua/plenary.nvim",
        version = false,
        -- event = { "BufReadPost", "BufNewFile" },
        -- cmd = { "TodoTrouble", "TodoTelescope" },
        config = function()
            require("todo-comments").setup({
                signs = true,
                sign_priority = 10,
                highlight = {
                    multiline = false,
                    before = "",
                    after = "fg",
                    keyword = "fg",
                },
                gui_style = {
                    fg = "BOLD",
                    bg = "NONE",
                },
            })
        end,
        -- {
        --     {
        --         "]t",
        --         function()
        --             require("todo-comments").jump_next()
        --         end,
        --         desc = "Next todo comment",
        --     },
        --     {
        --         "[t",
        --         function()
        --             require("todo-comments").jump_prev()
        --         end,
        --         desc = "Previous todo comment",
        --     },
        --     { "<leader>dt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
        --     { "<leader>dT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
        --     { "<leader>ft", "<cmd>TodoTelescope<cr>", desc = "Todo" },
        --     { "<leader>fT", "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme" },
        -- },
    },
    { --colorizes text for like css (color: #f00 )
        "norcalli/nvim-colorizer.lua",
        version = false,
        opts = {
            "html",
            "javascript",
            "lua",
            css = { css = true },
        },
        ft = {
            "html",
            "javascript",
            "lua",
            "css",
        },
    },
    { -- uses LanguageTool
        "rhysd/vim-grammarous",
        version = false,
        cmd = { "GrammarousCheck", "GrammarousReset" },
    },
    { -- preview markdown inside neovim
        "ellisonleao/glow.nvim",
        version = false,
        opts = {},
        cmd = "Glow",
    },
    { -- lua docs as vimdocs
        "milisims/nvim-luaref",
        version = false,
        ft = "lua",
    },
    { --NOTE: local plugin
        dir = "~/projects/lua/massimport.nvim",
        event = "VeryLazy",
        opts = {},
        -- config = function () require("massimport").setup({}) end
    },
}

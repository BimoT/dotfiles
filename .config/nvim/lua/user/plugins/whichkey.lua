-- This file contains all of the keymaps as well

return {
    "folke/which-key.nvim",
    -- event = "VeryLazy",
    lazy = false,
    opts = {
        plugins = {
            marks = true, -- shows a list of your marks on ' and `
            registers = true, -- shows your registers on " in NORMAL or <C-r> in INSERT mode
            spelling = {
                enabled = true, -- enabling this will show WhichKey when pressing z= to select spelling suggestions
                suggestions = 20, -- how many suggestions should be shown in the list?
            },
            -- the presets plugin, adds help for a bunch of default keybindings in Neovim
            -- No actual key bindings are created
            presets = {
                operators = false, -- adds help for operators like d, y, ... and registers them for motion / text object completion
                motions = false, -- adds help for motions
                text_objects = false, -- help for text objects triggered after entering an operator
                windows = true, -- default bindings on <c-w>
                nav = true, -- misc bindings to work with windows
                z = true, -- bindings for folds, spelling and others prefixed with z
                g = true, -- bindings for prefixed with g
            },
        },
        icons = {
            breadcrumb = "»", -- symbol used in the command line area that shows your active key combo
            separator = "➜", -- symbol used between a key and it's label
            group = "+", -- symbol prepended to a group
        },
        popup_mappings = {
            scroll_down = "<c-n>", -- binding to scroll down inside the popup
            scroll_up = "<c-p>", -- binding to scroll up inside the popup
        },
        window = {
            border = "rounded", -- none, single, double, shadow
            position = "bottom", -- bottom, top
            margin = { 1, 0, 1, 0 }, -- extra window margin [top, right, bottom, left]
            padding = { 2, 2, 2, 2 }, -- extra window padding [top, right, bottom, left]
            winblend = 0,
        },
        layout = {
            height = { min = 4, max = 25 }, -- min and max height of the columns
            width = { min = 20, max = 50 }, -- min and max width of the columns
            spacing = 3, -- spacing between columns
            align = "left", -- align columns left, center or right
        },
        ignore_missing = true, -- enable this to hide mappings for which you didn't specify a label
        hidden = {
            "<silent>",
            "<cmd>",
            "<Cmd>",
            "<CR>",
            "call",
            "lua",
            "^:",
            "^ ",
        }, -- hide mapping boilerplate
        show_help = true, -- show help message on the command line when the popup is visible
        triggers = "auto", -- automatically setup triggers
        -- triggers = {"<leader>"} -- or specify a list manually
        triggers_blacklist = {},
        defaults = {
            mode = "n",

            -- Some default keymaps
            ["<leader>t"] = { "<cmd>tabnew<CR>", "Open new tab" },
            ["<leader>w"] = { "<cmd>w!<CR>", "Save" },
            ["<leader>q"] = { name = "Quit" },
            ["<leader>qq"] = { "<cmd>q!<CR>", "Quit (force)" },
            ["<leader>qa"] = { "<cmd>qa<CR>", "Quit all" },
            ["<leader><CR>"] = { "<cmd>startinsert<CR><CR>", "Open newline at this point" },
            ["<leader><space>"] = { ":<c-u>put =repeat(nr2char(10), v:count1)<cr>", "Add newline" },

            -- Reload Snippets file
            ["<leader>rs"] = {
                function()
                    require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/user/snippets/ft/" })
                end,
                "Reload Snippets",
            },

            -- [[ Move lines ]]
            ["<A-j>"] = { "<cmd>m .+1<cr>==", "Move down" },
            ["<A-k>"] = { "<cmd>m .-2<cr>==", "Move up" },

            -- [[ Window resizing ]]
            ["<C-Up>"] = { "<cmd>resize -2<CR>", "Resize window -2" },
            ["<C-Down>"] = { "<cmd>resize +2<CR>", "Resize window +2" },
            ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "Vertical resize window -2" },
            ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "Vertical resize window +2" },

            -- [[ Buffer movement ]]
            ["[b"] = { "<cmd>bprevious<cr>", "Previous buffer" },
            ["]b"] = { "<cmd>bnext<cr>", "Next buffer" },
            ["<leader>bp"] = { "<cmd>bprevious<cr>", "Previous buffer" },
            ["<leader>bn"] = { "<cmd>bnext<cr>", "Next buffer" },
            ["<leader>ba"] = { "<cmd>e #<cr>", "Alternate buffer" },

            -- [[ Window movement ]]
            ["<C-h>"] = { "<C-w>h", "Move to left window" },
            ["<C-j>"] = { "<C-w>j", "Move to down window" },
            ["<C-k>"] = { "<C-w>k", "Move to up window" },
            ["<C-l>"] = { "<C-w>l", "Move to right window" },

            ["<leader>b"] = { name = "Buffer" },
            ["<leader>D"] = { name = "DAP" },
            ["<leader>d"] = { name = "Diagnostics" },
            ["<leader>f"] = { name = "Find" },
            -- ["<leader>g"] = { name = "Git" },
            ["<leader>h"] = { name = "Hop" },
            ["<leader>l"] = { name = "LSP" },
            ["<leader>sn"] = { name = "noice" },
            ["<leader>T"] = { name = "ToggleTerm" },

            -- [[ nvim_notify ]]
            ["<leader>un"] = {
                -- stylua: ignore
                function() require("notify").dismiss({ silent = true, pending = true }) end,
                "Dismiss all Notifications",
            },

            -- [[ telescope ]]
            ["<leader>ff"] = { "<cmd>Telescope find_files<CR>", "Find Files" },
            ["<leader>fg"] = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
            ["<leader>fb"] = { "<cmd>Telescope buffers<CR>", "Search Buffers" },
            ["<leader>fR"] = { "<cmd>Telescope registers<CR>", "Registers" },
            ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>", "Help tags" },

            -- [[ project ]]
            ["<leader>fp"] = { "<Cmd>Telescope projects<cr>", "Projects" },

            -- [[ splitjoin ]]
            ["gJ"] = { "<cmd>SplitjoinJoin<cr>", "Join lines" },
            ["gS"] = { "<cmd>SplitjoinSplit<cr>", "Split lines" },

            -- [[ spectre ]]
            -- stylua: ignore
            ["<leader>sr"] = { function() require("spectre").open() end, "Replace in files (Spectre)", },

            -- [[ leap ]]
            ["<leader>hf"] = { "<Plug>(leap-forward-to)", mode = "n", "Leap forward to" },
            ["<leader>hb"] = { "<Plug>(leap-backward-to)", mode = "n", "Leap backward to" },
            --TODO: add illuminate?

            -- [[ trouble ]]
            ["<leader>dd"] = { "<cmd>TroubleToggle document_diagnostics<cr>", "Document Diagnostics (Trouble)" },
            ["<leader>dw"] = {
                "<cmd>TroubleToggle workspace_diagnostics<cr>",
                "Workplace Diagnostics (Trouble)",
            },
            ["<leader>dl"] = { "<cmd>TroubleToggle loclist<cr>", "Location List (Trouble)" },
            ["<leader>dq"] = { "<cmd>TroubleToggle quickfix<cr>", "Quickfix List (Trouble)" },
            ["[q"] = {
                function()
                    if require("trouble").is_open() then
                        require("trouble").previous({
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        vim.cmd("cprev")
                    end
                end,
                "Previous trouble/quickfix item",
            },
            ["]q"] = {
                function()
                    if require("trouble").is_open() then
                        require("trouble").next({
                            skip_groups = true,
                            jump = true,
                        })
                    else
                        vim.cmd("cnext")
                    end
                end,
                "Next trouble/quickfix item",
            },

            -- [[ todo_comments ]]
            ["<leader>dt"] = { "<cmd>TodoTrouble<cr>", "Todo (Trouble)" },
            ["<leader>dT"] = { "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme (Trouble)" },
            ["<leader>ft"] = { "<cmd>TodoTelescope<cr>", "Todo" },
            ["<leader>fT"] = { "<cmd>TodoTelescope keywords=TODO,FIX,FIXME<cr>", "Todo/Fix/Fixme" },
            -- stylua: ignore
            ["]t"] = { function() require("todo-comments").jump_next() end, "Next todo comment", },
            -- stylua: ignore
            ["[t"] = { function() require("todo-comments").jump_prev() end, "Previous todo comment", },

            -- [[ toggleterm ]]
            ["<leader>TF"] = {
                "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='float', float_opts={border='double'}}):toggle()<CR>",
                "Floating ToggleTerm",
            },
            ["<leader>TV"] = {
                "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='vertical'}):toggle()<CR>",
                "Vertical ToggleTerm",
            },
            ["<leader>TH"] = {
                "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='horizontal'}):toggle()<CR>",
                "Horizontal ToggleTerm",
            },
            ["<leader>TT"] = {
                "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='tab'}):toggle()<CR>",
                "Tab ToggleTerm",
            },
            -- [[ nvim_tree ]]
            ["<leader>e"] = {
                function()
                    require("neo-tree.command").execute({ toggle = true, dir = vim.loop.cwd() })
                end,
                "NvimTree",
            },

            -- [[ dap ]]
            -- stylua: ignore
            ["<leader>Db"] = { function() require("dap").toggle_breakpoint() end, "Toggle Breakpoint", },
            -- stylua: ignore
            ["<leader>Dc"] = { function() require('dap').continue() end, "Continue",},
            -- stylua: ignore
            ["<leader>Di"] = { function() require('dap').step_into() end, "Step Into",},
            -- stylua: ignore
            ["<leader>Do"] = { function() require('dap').step_over() end, "Step Over",},
            -- stylua: ignore
            ["<leader>DO"] = { function() require('dap').step_out() end, "Step Out",},
            -- stylua: ignore
            ["<leader>Dr"] = { function() require('dap').repl.toggle() end, "Toggle REPL",},
            -- stylua: ignore
            ["<leader>Dl"] = { function() require('dap').run_last() end, "Run Last",},
            -- stylua: ignore
            ["<leader>Dt"] = { function() require('dap').terminate() end, "Terminate",},

            -- [[ dap_ui ]]
            -- stylua: ignore
            ["<leader>Du"] = { function() require("dapui").toggle() end, "DAP ui toggle",},
            -- stylua: ignore
            ["<leader>De"] = { function() require("dapui").eval() end, "DAP ui eval", mode = {"n", "v"},},

            -- [[ one_small_step_for_vimkind ]]
            -- stylua: ignore
            ["<leader>DaL"] = { function() require("osv").launch({port = 8086 }) end, "Adapter Launch (Lua Server)",},
            -- stylua: ignore
            ["<leader>Dar"] = { function() require("osv").run_this() end, "Adapter Run (lua)",},
        },
    },
    config = function(_, opts)
        local wk = require("which-key")
        wk.setup(opts)
        wk.register(opts.defaults)

        -- local keymaplist = require("user.keymapsforwhichkey")
        -- wk.register(keymaplist)

        --[[ Visual mode keymaps ]]
        wk.register({
            ["<leader/"] = { '"_dP', "Paste + black hole" },
            ["."] = { ":norm .<CR>", "Dot-repeat visual range" },
            [">"] = { ">gv", "Indent and back to visual" },
            ["<"] = { "<gv", "Indent and back to visual" },
            ["y"] = { "ygv<esc>", "Yank with correct cursor placement" },

            --[[ Move line ]]
            ["<A-j>"] = { ":m '>+1<cr>gv=gv", "Move down" },
            ["<A-k>"] = { ":m '<-2<cr>gv=gv", "Move up" },
        }, {
            mode = "v", -- only in normal mode
            prefix = "",
            -- use 'prefix = "<leader>" to prefix every made keybinding with "<leader>"'
            buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
            silent = true, -- use silent when creating keymaps
            noremap = true,
            nowait = true,
        })

        --[[ Insert mode keymaps ]]
        wk.register({
            ["<A-j>"] = { "<esc><cmd>m .+1<cr>==gi", "Move down" },
            ["<A-k>"] = { "<esc><cmd>m .-2<cr>==gi", "Move up" },
        }, {
            mode = "i",
            prefix = "",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })

        --[[ Terminal mode keymaps ]]
        wk.register({
            ["<esc>"] = { [[<C-\><C-n>]], "Exit terminal" },
            ["<C-h>"] = { [[<C-\><C-n><C-W>h]], "" },
            ["<C-j>"] = { [[<C-\><C-n><C-W>j]], "" },
            ["<C-k>"] = { [[<C-\><C-n><C-W>k]], "" },
            ["<C-l>"] = { [[<C-\><C-n><C-W>l]], "" },
        }, {
            mode = "t",
            prefix = "",
            buffer = nil,
            silent = true,
            noremap = true,
            nowait = true,
        })
    end,
}

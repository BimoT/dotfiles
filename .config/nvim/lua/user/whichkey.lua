local status_ok, which_key = pcall(require, "which-key")
if not status_ok then
    return
end

local setup = {
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
    key_labels = {
        -- use this to override the label used to display some keys.
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
}

local opts = {
    mode = "n", -- only in normal mode
    prefix = "",
    -- use 'prefix = "<leader>" to prefix every made keybinding with "<leader>"'
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use silent when creating keymaps
    noremap = true,
    nowait = true,
}

local mappings = {
    --[[ Window resizing ]]
    ["<C-Up>"] = { "<cmd>resize -2<CR>", "Resize window -2" },
    ["<C-Down>"] = { "<cmd>resize +2<CR>", "Resize window +2" },
    ["<C-Left>"] = { "<cmd>vertical resize -2<CR>", "Vertical resize window -2" },
    ["<C-Right>"] = { "<cmd>vertical resize +2<CR>", "Vertical resize window +2" },

    --[[ Window movement ]]
    ["<C-h>"] = { "<C-w>h", "Move to left window" },
    ["<C-j>"] = { "<C-w>j", "Move to down window" },
    ["<C-k>"] = { "<C-w>k", "Move to up window" },
    ["<C-l>"] = { "<C-w>l", "Move to right window" },

    --[[ ToggleTerm ]]
    ["<leader>T"] = { name = "ToggleTerm" },
    ["<leader>TF"] = {
        "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='float', float_opts={border='double'}}):toggle()<CR>",
        "Floating ToggleTerm",
    },
    ["<leader>TS"] = {
        "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='vertical'}):toggle()<CR>",
        "Split ToggleTerm",
    },

    --[[ Hop ]]
    ["<leader>h"] = { name = "Hop" },
    ["<leader>ht"] = { "<cmd>HopChar2<CR>", "Hop 2 chars" },
    ["<leader>hw"] = { "<cmd>HopWord<CR>", "Hop word" },

    --[[ Telescope ]]
    ["<leader>f"] = { name = "Telescope" },
    ["<leader>ff"] = { "<cmd>Telescope find_files<CR>", "Find Files" },
    ["<leader>ft"] = { "<cmd>Telescope live_grep<CR>", "Live Grep" },
    ["<leader>fp"] = { "<cmd>Telescope projects<CR>", "Search Projects" },
    ["<leader>fb"] = { "<cmd>Telescope buffers<CR>", "Search Buffers" },
    ["<leader>fR"] = { "<cmd>Telescope registers<CR>", "Registers" },
    ["<leader>fh"] = { "<cmd>Telescope help_tags<CR>", "Help tags" },

    --[[ Git ]]
    ["<leader>g"] = { name = "Git" },
    ["<leader>gg"] = {
        "<cmd>lua require('toggleterm.terminal').Terminal:new({cmd = 'lazygit', hidden=true}):toggle()<CR>",
        "Toggle lazygit",
    },

    --[[ DAP ]]
    ["<leader>d"] = { name = "DAP" },
    ["<leader>db"] = { "<cmd>lua require('dap').toggle_breakpoint()<cr>" },
    ["<leader>dc"] = { "<cmd>lua require('dap').continue()<cr>" },
    ["<leader>di"] = { "<cmd>lua require('dap').step_into()<cr>" },
    ["<leader>do"] = { "<cmd>lua require('dap').step_over()<cr>" },
    ["<leader>dO"] = { "<cmd>lua require('dap').step_out()<cr>" },
    ["<leader>dr"] = { "<cmd>lua require('dap').repl.toggle()<cr>" },
    ["<leader>dl"] = { "<cmd>lua require('dap').run_last()<cr>" },
    ["<leader>du"] = { "<cmd>lua require('dapui').toggle()<cr>" },
    ["<leader>dt"] = { "<cmd>lua require('dap').terminate()<cr>" },

    --[[ Comment ]]
    ["<leader>/"] = { "<cmd>lua require('Comment.api').toggle_current_linewise()<CR>", "Comment/uncomment line" },

    --[[ NvimTree ]]
    ["<leader>e"] = { "<cmd>NvimTreeToggle<CR>", "NvimTree" },

    --[[ Illuminate]]
    ["<a-n>"] = { "<cmd>lua require('illuminate').next_reference({wrap=true})<cr>", "Illuminate next reference" },
    ["<a-p>"] = {
        "<cmd>lua require('illuminate').next_reference({reverse=true,wrap=true})<cr>",
        "Illuminate previous reference",
    },

    --[[ Other ]]
    ["<leader>w"] = { "<cmd>w!<CR>", "Save" },
    ["<leader>q"] = { name = "Quit" },
    ["<leader>qq"] = { "<cmd>q!<CR>", "Quit (force)" },
    ["<leader>qa"] = { "<cmd>qa<CR>", "Quit all" },
    ["<leader>t"] = { "<Plug>PlenaryTestFile", "Test this file with plenary" },
    ["<leader>x"] = { "<cmd>w! | so % <CR>", "Save and run this file" },
    ["<leader><CR>"] = { "<cmd>startinsert<CR><CR>", "Open newline at this point" },
}

which_key.setup(setup)
-- Visual mode keymaps
which_key.register({
    --stylua: ignore
    ["<leader/"] = { '"_dP', "Paste + black hole" },
}, {
    mode = "v", -- only in normal mode
    prefix = "",
    -- use 'prefix = "<leader>" to prefix every made keybinding with "<leader>"'
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use silent when creating keymaps
    noremap = true,
    nowait = true,
})
which_key.register(mappings, opts)

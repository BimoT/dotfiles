local k = require("user.keymaplist")
-- toggling terminal windows, easily spawning them
return {
    "akinsho/toggleterm.nvim",
    version = false,
    keys = k.toggleterm.keys,
    -- {
    --     {
    --         "<leader>TF",
    --         "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='float', float_opts={border='double'}}):toggle()<CR>",
    --         desc = "Floating ToggleTerm",
    --     },
    --     {
    --         "<leader>TV",
    --         "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='vertical'}):toggle()<CR>",
    --         desc = "Vertical ToggleTerm",
    --     },
    --     {
    --         "<leader>TH",
    --         "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='horizontal'}):toggle()<CR>",
    --         desc = "Horizontal ToggleTerm",
    --     },
    --     {
    --         "<leader>TT",
    --         "<cmd>lua require('toggleterm.terminal').Terminal:new({direction='tab'}):toggle()<CR>",
    --         desc = "Tab ToggleTerm",
    --     },
    -- },
    opts = {
        size = 20,
        -- open_mapping = [[<c-\>]],
        hide_numbers = true,
        shade_terminals = true,
        shading_factors = 2,
        start_in_insert = true,
        insert_mappings = true,
        persist_size = true,
        direction = "float",
        close_on_exit = true,
        shell = vim.o.shell,
        float_opts = { border = "curved" },
    },
}

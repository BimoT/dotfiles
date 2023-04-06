local status_ok, toggleterm = pcall(require, "toggleterm")
if not status_ok then return end

toggleterm.setup({
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
    float_opts = { border = "curved", },
})

-- function _G.set_terminal_keymaps()
--     local opts = { noremap = true }
--     local vk = vim.api.nvim_buf_set_keymap
--     vk(0, "t", "<C-h>", [[<C-\><C-n><C-W>h]], opts)
--     vk(0, "t", "<C-j>", [[<C-\><C-n><C-W>j]], opts)
--     vk(0, "t", "<C-k>", [[<C-\><C-n><C-W>k]], opts)
--     vk(0, "t", "<C-l>", [[<C-\><C-n><C-W>l]], opts)
-- end

-- vim.cmd("autocmd! TermOpen term://* lua set_terminal_keymaps()")
-- vim.api.nvim_create_autocmd({ "TermOpen" }, {
--     pattern = "term://*",
--     callback = function ()
--         local whichkey = require("which-key")
--         whichkey.register({
--             ["<esc>"] = { [[<C-\><C-n>]], "Exit terminal" },
--             ["<C-h>"] = { [[<C-\><C-n><C-W>h]], ""},
--             ["<C-j>"] = { [[<C-\><C-n><C-W>j]], ""},
--             ["<C-k>"] = { [[<C-\><C-n><C-W>k]], ""},
--             ["<C-l>"] = { [[<C-\><C-n><C-W>l]], ""},
--         },
--             {
--             mode = "t",
--             prefix = "",
--             buffer = 0,
--             silent = true,
--             noremap = true,
--             nowait = true,
--         })
--     end
-- })
--[[ local Terminal = require("toggleterm.terminal").Terminal
local lazygit = Terminal:new({ cmd = "lazygit", hidden = true })

function _LAZYGIT_TOGGLE()
    lazygit:toggle()
end ]]

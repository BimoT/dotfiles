-- first, set leader to <space>
vim.keymap.set("", "<Space>", "<Nop>", { silent = true })
vim.g.mapleader = " "
vim.keymap.set("i", "ii", "<Esc>", { silent = true }) -- leave insert mode with "ii"
require("user.globals")
require("user.alpha")
require("user.autocommands")
require("user.autopairs")
require("user.bufferline")
require("user.cmp")
require("user.colorscheme")
require("user.comment")
require("user.dap")
require("user.gitsigns")
-- require("user.illuminate")
require("user.impatient")
require("user.indentline")
-- require("user.keybindings")
require("user.lsp")
require("user.nvim-tree")
require("user.options")
require("user.plugins")
require("user.statusline")
require("user.telescope")
require("user.toggleterm")
require("user.treesitter")
require("user.whichkey")

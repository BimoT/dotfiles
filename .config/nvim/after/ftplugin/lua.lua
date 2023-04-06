--[[ ftplugin for lua files ]]

vim.opt_local.textwidth = 120
vim.opt_local.makeprg = "lua %:S"

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then return end

wk.register({
    ["<leader>c"] = { "<cmd>w! | make<CR>", "Compile file" },
    ["<leader>s"] = { "<cmd>w! | so % <CR>", "Save and run this file" },
    --[[ ["<leader>t"] = { "<Plug>PlenaryTestFile", "Test this file with plenary" }, ]]
}, {
    mode = "n",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})

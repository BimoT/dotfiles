--[[ ftplugin for .vim files ]]

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then return end

wk.register({
    ["<leader>x"] = { "<cmd>w! | so % <CR>", "Save and run this file" },
}, {
    mode = "n",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})

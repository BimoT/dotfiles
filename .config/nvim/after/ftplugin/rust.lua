
local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then return end

wk.register({
    ["<leader>c"] = { "<cmd>w! | RustRun<CR>", "Compile file" },
}, {
    mode = "n",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})
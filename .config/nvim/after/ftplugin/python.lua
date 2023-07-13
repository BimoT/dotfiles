--[[ ftplugin for python files ]]

vim.opt_local.makeprg = "python %:S"

-- local wk_ok, wk = pcall(require, "which-key")
-- if not wk_ok then return end
--
-- wk.register({
--     ["<leader>c"] = { "<cmd>w! | make<CR>", "Compile file" },
-- }, {
--     mode = "n",
--     prefix = "",
--     buffer = 0, -- Buffer local mapping, use nil for global
--     silent = true,
--     noremap = true,
--     nowait = true,
-- })

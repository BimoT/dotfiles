--[[ ftplugin for latex files ]]
-- TODO: Make opening the pdf more robust (check if exists)

vim.opt_local.spelllang = "en_us"
vim.opt_local.spell = true

local wk_ok, wk = pcall(require, "which-key")
if not wk_ok then return end
local Job = require("plenary.job")

local function open_pdf()
    if vim.fn.has("win32") == 1 then
        vim.cmd(":!%:r.pdf<CR>")
    else
        local opener_linux = "zathura" -- The pdf reader on linux
        local current_pdf = vim.fn.expand("%:r") .. ".pdf"

        Job:new({
            command = opener_linux,
            args = { current_pdf },
            on_stderr = function ()
                print("File not found?")
            end,
        })
    end
end

local function make_latex()
    --[[ Finds a makefile ]]
    local file_dir = vim.fn.expand("%:p:h")
    
    if vim.fn.has("win32") == 1 then
        return nil
    else
                --[[ "-verbose", ]]
                --[[ "-file-line-error", ]]
                --[[ "-synctex=1", ]]
                --[[ "-interaction=nonstopmode", ]]
        --[[  Job:new({ ]]
        --[[     command = "make", ]]
        --[[     on_stderr = function () ]]
        --[[          ]]
        --[[     end ]]
        --[[ }) ]]
    end
end


wk.register({
    ["<leader>c"] = { "<cmd>w! | make<CR>", "Compile file" },
    ["<leader>o"] = { open_pdf, "Open corresponding PDF" },
}, {
    mode = "n",
    prefix = "",
    buffer = 0, -- Buffer local mapping, use nil for global
    silent = true,
    noremap = true,
    nowait = true,
})

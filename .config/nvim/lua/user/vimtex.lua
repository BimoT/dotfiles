--[[ VimTex plugin for latex: lervag/vimtex ]]
local opener_windows = "sumatrapdf"
local opener_linux = "zathura"
vim.g.tex_flavor = "latex"
if vim.fn.has("win32") == 1 then
    vim.g.vimtex_view_method = opener_windows
else
    vim.g.vimtex_view_method = opener_linux
end
vim.g.quickfix_mode = 0
vim.g.tex_conceal = "abdmg"


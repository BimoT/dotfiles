-- TeX/LaTeX related plugins
return {
    { -- Vim plugin
        "lervag/vimtex",
        version = false,
        ft = { "tex" },
        opts = {},
        config = function()
            local opener_windows = "sumatrapdf"
            local opener_linux = "zathura"
            if vim.fn.has("win32") == 1 then
                vim.g.vimtex_view_method = opener_windows
            else
                vim.g.vimtex_view_method = opener_linux
            end
            vim.g.tex_flavor = "latex"
            vim.g.quickfix_mode = 0
            vim.g.tex_conceal = "abdmg"
        end,
    },
}

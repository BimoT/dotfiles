local nvcmd = vim.api.nvim_create_autocmd

-- needs better
vim.cmd([[au BufRead, BufNewFile *.tex set filetype=tex]])
nvcmd({ "BufNewFile" }, {
    pattern = { "*.tex"},
    callback = function() vim.cmd([[set filetype=tex]]) end
})

nvcmd({ "BufRead" }, {
    pattern = { "*.tex"},
    callback = function() vim.cmd([[set filetype=tex]]) end
})
nvcmd({ "Filetype" }, {
    pattern = { "tex" },
    callback = function()
        vim.keymap.set("n", "<leader>c", ":w | !pdflatex %s<CR>", { silent = true })
        -- vim.cmd([[nnoremap <leader>c :!pdflatex %s<CR>]])
    end
})

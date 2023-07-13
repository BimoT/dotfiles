local myoptions = {
    fileencoding = "utf-8",
    number = true, -- number column
    relativenumber = true, -- numbers are relative to current number
    showtabline = 2, -- always show tab bar
    hlsearch = false, -- I dont want to see the match after i've searched
    wrapscan = false, -- stops searching when the end of the file is reached
    incsearch = true, -- incremental searching when you type
    title = true,
    scrolloff = 8,
    mouse = "a", -- mouse enabled in all modes,
    --{{ tab stuff
    shiftwidth = 4, -- spaces for each inserted indent
    tabstop = 4, -- 1 tab equals 4 spaces
    softtabstop = 4, -- tab=spaces also for backspaces and stuff
    expandtab = true, -- tabs are converted to spaces
    --}}
    completeopt = { "menuone", "noselect" }, -- autocomplete menu options
    conceallevel = 1, -- for markdown apparently?
    showmode = false, -- now it doesn't show "--INSERT-- anymore
    smartindent = true, -- automatic indentation smart
    splitbelow = true, -- horizontal split opens below current window
    splitright = true, -- vertical split opens to the right of current window
    cmdheight = 2, -- height of the command line
    signcolumn = "yes",
    timeoutlen = 600,
    numberwidth = 4, -- number column width
    termguicolors = true,
    backspace = { "start", "eol", "indent" },
    matchtime = 2, -- shortly highlights matching braces
    showmatch = true, -- shows the matching braces when mouse is on it
    linebreak = true, -- so that lines break at sensible places
    pumheight = 8, -- popupmenu height
}

-- vim.cmd([[GuiFont! JetBrains Mono Nerd Font:6]])
vim.opt.display:append("lastline")
vim.opt.whichwrap:append("<,>,[,],h,l")
for k, v in pairs(myoptions) do
    vim.opt[k] = v
end

-- TODO: rewrite in lua
-- This should turn off all the annoying highlighted matches after the search is done
-- vim.cmd([[augroup vimrc-incsearch-highlight
-- autocmd!
-- autocmd CmdLineEnter /,\? :set hlsearch
-- autocmd CmdLineLeave /,\? :set nohlsearch
-- augroup END
-- ]])

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]])

-- protected call to avoid errors on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then return end

-- Have packer use a popup window
packer.init({
    display = {
        open_fn = function()
            return require("packer.util").float { border = "rounded" }
        end,
    },
})

-- Install plugins here
return packer.startup(function(use)
    --[[ Required packages ]]
    use { "wbthomason/packer.nvim" } -- packer itself
    use { "nvim-lua/plenary.nvim" } -- plenary contains useful functions
    use { "nvim-lua/popup.nvim" }
    use { "kyazdani42/nvim-web-devicons" } -- Icons
    --[[ Local packages ]]
    use { "~/projects/lua/massimport.nvim",
        config = function () require("massimport").setup({}) end
    }
    --[[ General packages ]]
    use { "kyazdani42/nvim-tree.lua" } -- File explorer
    use { "goolord/alpha-nvim" } -- custom greeter
    use { "nvim-lualine/lualine.nvim" } -- statusline
    use { "akinsho/bufferline.nvim" } -- tabline
    use { "akinsho/toggleterm.nvim" } -- handles terminals within nvim
    use { "folke/which-key.nvim" } -- which-key like in emacs
    use { "ahmedkhalf/project.nvim" }
    use { "lewis6991/impatient.nvim" } -- speeds up nvim load time
    use { "lukas-reineke/indent-blankline.nvim" } -- IDE indentation guides
    use { "numToStr/Comment.nvim" } -- easy uncomment/comment
    use { "rcarriga/nvim-notify" } -- notifications prettier
    use { "nvim-telescope/telescope.nvim" } -- fuzzy finder
    use { "nvim-telescope/telescope-fzf-native.nvim",
        run = 'make' } -- better faster fuzzy finder
    use { "nvim-telescope/telescope-ui-select.nvim" } -- replaces vim.ui.select() with a telescope selector
    use { "phaazon/hop.nvim", commit = "a7ad781962831c14d53cb9788cc67b8be45a9024", config = function ()
        require("hop").setup()
    end } -- fast movement
    use { "folke/trouble.nvim", config = function ()
        require("trouble").setup({})
    end}
    --[[ Text manipulation ]]
    use { "windwp/nvim-autopairs" } -- automatically inserts matching brackets/quotes/stuff
    use { "tpope/vim-surround", disable = true } -- change surrounding quotes/brackets
    use { "kylechui/nvim-surround", config = function ()
        require("nvim-surround").setup({})
    end } -- extended vim-surround
    use { "tpope/vim-abolish" } -- case conversion, abbreviations, substitutions
    use { "tommcdo/vim-lion", commit = "ce46593ecd60e6051fb6e4d3986d2fc9f5a618b1" } -- align text
    use { "AndrewRadev/splitjoin.vim",
        keys = { "gJ", "gS" },
    } -- Split and join lines
    --[[ Colors ]]
    use { "catppuccin/nvim", as = "catppuccin" } -- nice colorscheme, might try out
    use { "norcalli/nvim-colorizer.lua", config = function ()
        require("colorizer").setup({
            "html";
            "javascript";
            "lua";
            css = {css = true}
        })
    end} --colorizes text for like css (color: #f00 )
    use { "dracula/vim" } -- great colorscheme
    use { "folke/todo-comments.nvim",
    requires = "nvim-lua/plenary.nvim",
    config = function()
            require("todo-comments").setup({
                highlight = {
                    multiline = false,
                    before = "",
                    after = "fg",
                    keyword = "fg",
                }
            })
        end} -- highlights -- TODO and similar comments

    --[[ Treesitter ]]
    use { "nvim-treesitter/nvim-treesitter" }
    use { "nvim-treesitter/playground" } -- view treesitter information
    use { "nvim-treesitter/nvim-treesitter-textobjects" }
    use { "JoosepAlviste/nvim-ts-context-commentstring" } -- comments for files with multiple languages

    --[[ Git ]]
    use { "sindrets/diffview.nvim" } -- view git diff in 1 window
    use { "lewis6991/gitsigns.nvim" } -- git

    --[[ Snippets ]]
    use { "L3MON4D3/LuaSnip" } -- the engine for snippets
    use { "rafamadriz/friendly-snippets" } -- premade collection of snippets

    --[[ Language-Server Protocol ]]
    -- neodev needs to be loaded before lspconfig
    use { "folke/neodev.nvim", config = function ()
        require("neodev").setup({})
    end } -- neovim-specific lua hints
    use { "williamboman/mason.nvim" } -- easy installer
    use { "williamboman/mason-lspconfig.nvim" } -- extra config for mason
    use { "neovim/nvim-lspconfig" } -- base needed for lsp
    use { "https://git.sr.ht/~whynothugo/lsp_lines.nvim", config = function ()
        require("lsp_lines").setup()
    end} -- LSP diagnostics in lines under the erroring parts of code
    use { "j-hui/fidget.nvim" , config = function ()
        require("fidget").setup()
    end} -- eye candy for lsp progress
    use { "jose-elias-alvarez/null-ls.nvim" }
    use { "RRethy/vim-illuminate", config = function ()
        vim.g.Illuminate_ftblacklist = { "alpha", "NvimTree" }
    end } -- highlights instances of word under cursor

    --[[ Language specific stuff ]]

    --[[ Human languages ]]
    use { "rhysd/vim-grammarous" } -- uses LanguageTool

    --[[ Markdown ]]
    use { "ellisonleao/glow.nvim" } -- preview markdown inside neovim

    --[[ Lua ]]
    use { "milisims/nvim-luaref" } -- lua docs as vimdocs 
    use { "nanotee/luv-vimdocs" } -- libuv docs, might need later

    --[[ TeX ]]
    use { "lervag/vimtex" }

    --[[ Autocompletion (using cmp) ]]
    -- maybe later test out "coc" or "coq"
    use { "hrsh7th/nvim-cmp" } -- The completion plugin
    use { "hrsh7th/cmp-buffer" } -- buffer completions
    use { "hrsh7th/cmp-path" } -- path completions
    use { "saadparwaiz1/cmp_luasnip" } -- snippet completions
    use { "hrsh7th/cmp-nvim-lsp" }
    use { "hrsh7th/cmp-nvim-lua" }
    use { "lukas-reineke/cmp-under-comparator" } -- better autocomplete sorting for items starting with an underscore

    --[[ Debug Adapter Protocol ]]
    use { "mfussenegger/nvim-dap" } -- needed for debugger stuff
    use { "rcarriga/nvim-dap-ui" } -- better UI for DAP
    use { "theHamsta/nvim-dap-virtual-text" } -- virtual text, highlighted like a comment, displaying values
    use { "ravenxrz/DAPInstall.nvim" }
    use { "mfussenegger/nvim-dap-python"} -- python debug adapter
end)


local k = require("user.keymaplist")
-- good fuzzy finder, many extensions available
return {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false,
    keys = k.telescope.keys,
    -- {
    --     { "<leader>ff", "<cmd>Telescope find_files<CR>", desc = "Find Files" },
    --     { "<leader>fg", "<cmd>Telescope live_grep<CR>", desc = "Live Grep" },
    --     { "<leader>fp", "<cmd>Telescope projects<CR>", desc = "Search Projects" },
    --     { "<leader>fb", "<cmd>Telescope buffers<CR>", desc = "Search Buffers" },
    --     { "<leader>fR", "<cmd>Telescope registers<CR>", desc = "Registers" },
    --     { "<leader>fh", "<cmd>Telescope help_tags<CR>", desc = "Help tags" },
    -- },
    dependencies = {
        {
            "nvim-lua/plenary.nvim",
        },
        -- {
        --     "folke/which-key.nvim",
        -- },
        { -- better faster fuzzy finder
            "nvim-telescope/telescope-fzf-native.nvim",
            build = "make",
            version = false,
            -- config = function()
            -- end,
        },
        -- { -- replaces vim.ui.select() with a telescope selector
        -- "nvim-telescope/telescope-ui-select.nvim",
        -- version = false,
        -- config = function()
        -- require("telescope").load_extension("ui-select")
        -- end,
        -- },
        { -- Easy finding of projects
            "ahmedkhalf/project.nvim",
            version = false,
            opts = {},
            event = "VeryLazy",
            config = function(_, opts)
                require("project_nvim").setup(opts)
                -- require("telescope").load_extension("projects")
            end,
            keys = k.project.keys,
            -- {
            --     { "<leader>fp", "<Cmd>Telescope projects<cr>", desc = "Projects" },
            -- },
        },
    },
    config = function(_, opts)
        local actions = require("telescope.actions")
        local opts = {
            defaults = {
                propmpt_prefix = " ",
                selection_caret = " ",
                path_display = { "smart" },
                file_ignore_patterns = { ".git/", "node_modules" },
                mappings = {
                    i = {
                        ["<Down>"] = actions.cycle_history_next,
                        ["<Up>"] = actions.cycle_history_prev,
                        ["<C-j>"] = actions.move_selection_next,
                        ["<C-k>"] = actions.move_selection_previous,
                    },
                },
            },
            extensions = {
                fzf = {
                    fuzzy = true,
                    override_generic_sorter = true,
                    override_file_sorter = true,
                    case_mode = "smart_case",
                },
                -- ["ui-select"] = {
                -- require("telescope.themes").get_dropdown({}),
                -- },
            },
        }
        require("telescope").load_extension("fzf")
        require("telescope").load_extension("projects")
        require("telescope").setup(opts)
    end,
}

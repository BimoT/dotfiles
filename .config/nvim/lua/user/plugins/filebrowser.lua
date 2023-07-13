-- A good file explorer
-- return {
--     "nvim-tree/nvim-tree.lua",
--     dependencies = "nvim-tree/nvim-web-devicons",
--     version = false,
--     -- keys = k.nvim_tree.keys,
--     -- {
--     --     { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "NvimTree" },
--     -- },
--     opts = {
--         update_focused_file = {
--             enable = true,
--             update_cwd = true,
--         },
--         renderer = {
--             root_folder_modifier = ":t",
--             icons = {
--                 glyphs = {
--                     default = "",
--                     symlink = "",
--                     folder = {
--                         arrow_open = "",
--                         arrow_closed = "",
--                         default = "",
--                         open = "",
--                         empty = "",
--                         empty_open = "",
--                         symlink = "",
--                         symlink_open = "",
--                     },
--                     git = {
--                         unstaged = "",
--                         staged = "S",
--                         unmerged = "",
--                         renamed = "➜",
--                         untracked = "U",
--                         deleted = "",
--                         ignored = "◌",
--                     },
--                 },
--             },
--         },
--         diagnostics = {
--             enable = true,
--             show_on_dirs = true,
--             icons = {
--                 hint = "",
--                 info = "",
--                 warning = "",
--                 error = "",
--             },
--         },
--         -- on_attach = function()
--         --     local api = require("nvim-tree.api")
--         --     local function opts(d)
--         --         return { desc = "nvim-tree: " .. d, buffer = bufnr, noremap = true, silent = true, nowait = true }
--         --     end
--         --     vim.keymap.set("n", "l", api.node.open.edit, opts("Edit"))
--         --     vim.keymap.set("n", "h", api.node.navigate.parent_close, opts("Close node"))
--         --     vim.keymap.set("n", "v", api.node.open.vertical, opts("Close node"))
--         -- end,
--         view = {
--             width = 30,
--             --[[ height = 30, ]]
--             side = "left",
--             -- NOTE: mappings.list is deprecated.
--             -- mappings = {
--             --     list = {
--             --         { key = { "l", "<CR>", "o" }, action = "edit" },
--             --         { key = "h", action = "close_node" },
--             --         { key = "v", action = "vsplit" },
--             --     },
--             -- },
--         },
--     },
-- }

return {
    "nvim-neo-tree/neo-tree.nvim",
    version = false,
    dependencies = {
        "MunifTanjim/nui.nvim",
    },
    cmd = "Neotree",
    deactivate = function()
        vim.cmd([[Neotree close]])
    end,
    init = function()
        vim.g.neo_tree_remove_legacy_commands = 1
        if vim.fn.argc() == 1 then
            local stat = vim.loop.fs_stat(vim.fn.argv(0))
            if stat and stat.type == "directory" then
                require("neo-tree")
            end
        end
    end,
    opts = {
        sources = { "filesystem", "buffers", "git_status", "document_symbols" },
        filesystem = {
            bind_to_cwd = false,
            follow_current_file = true,
            use_libuv_file_watcher = true,
            filtered_items = { hide_dotfiles = false },
        },
        window = {
            mappings = {
                ["<space>"] = "none",
                ["l"] = "open",
                ["v"] = "open_vsplit",
                ["h"] = "close_node",
            },
        },
        default_component_configs = {
            indent = {
                width_expanders = true, -- if nil and file nesting is enabled, will enable expanders
                -- expander_collapsed = "",
                -- expander_expanded = "",
                expander_highlight = "NeoTreeExpander",
            },
        },
    },
    config = function(_, opts)
        require("neo-tree").setup(opts)
        vim.api.nvim_create_autocmd("TermClose", {
            pattern = "*lazygit",
            callback = function()
                if package.loaded["neo-tree.sources.git_status"] then
                    require("neo-tree.sources.git_status").refresh()
                end
            end,
        })
    end,
}

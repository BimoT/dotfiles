local k = require("user.keymaplist")
-- Holds all of the UI-related plugins
return {
    {
        "rcarriga/nvim-notify",
        version = false,
        keys = k.nvim_notify.keys,
        -- {
        --     {
        --         "<leader>un",
        --         function()
        --             require("notify").dismiss({ silent = true, pending = true })
        --         end,
        --         desc = "Dismiss all Notifications",
        --     },
        -- },
        opts = {
            timeout = 3000,
            max_height = function()
                return math.floor(vim.o.lines * 0.75)
            end,
            max_width = function()
                return math.floor(vim.o.columns * 0.75)
            end,
        },
        init = function()
            -- when noice is not enabled, install notify on VeryLazy
            local Util = require("user.utils")
            if not Util.lazy_has_plugin("noice.nvim") then
                Util.on_very_lazy(function()
                    vim.notify = require("notify")
                end)
            end
        end,
    },
    { -- better vim.ui
        "stevearc/dressing.nvim",
        version = false,
        lazy = true,
        init = function()
            vim.ui.select = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.select(...)
            end

            vim.ui.input = function(...)
                require("lazy").load({ plugins = { "dressing.nvim" } })
                return vim.ui.input(...)
            end
        end,
    },
    { -- Statusline
        "nvim-lualine/lualine.nvim",
        version = false,
        event = "VeryLazy",
        opts = function()
            local icons = require("user.utils").icons
            local Util = require("user.utils")
            return {
                options = {
                    icons_enabled = true,
                    theme = "auto",
                    disabled_filetypes = { statusline = { "alpha" } },
                    always_divide_middle = true,
                    globalstatus = false,
                },
                sections = {
                    lualine_a = { "mode" },
                    lualine_b = { "branch" },
                    lualine_c = {
                        {
                            "diagnostics",
                            symbols = {
                                error = icons.lsp_diagnostics.Error,
                                warn = icons.lsp_diagnostics.Warn,
                                info = icons.lsp_diagnostics.Info,
                                hint = icons.lsp_diagnostics.Hint,
                            },
                        },
                        { "filetype", icon_only = true, separator = "" },
                        {
                            "filename", --[[path = 1,]]
                            symbols = { modified = "  ", readonly = "", unnamed = "" },
                        },
                        {
                            function()
                                return require("nvim-navic").get_location()
                            end,
                            cond = function()
                                return package.loaded["nvim-navic"] and require("nvim-navic").is_available()
                            end,
                        },
                    },

                    lualine_x = {
                        "encoding",
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.command.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.command.has() end,
                        --     color = Util.fg("Statement"),
                        -- },
                        -- stylua: ignore
                        -- {
                        --     function() return require("noice").api.status.mode.get() end,
                        --     cond = function() return package.loaded["noice"] and require("noice").api.status.mode.has() end,
                        --     color = Util.fg("Constant"),
                        -- },
                        -- stylua: ignore
                        {
                            function() return "  " .. require("dap").status() end,
                            cond = function () return package.loaded["dap"] and require("dap").status() ~= "" end,
                            color = Util.fg("Debug"),
                        },
                        -- {
                        --     require("lazy.status").updates,
                        --     cond = require("lazy.status").has_updates,
                        --     color = Util.fg("Special"),
                        -- },
                        {
                            "diff",
                            symbols = {
                                added = icons.git.added,
                                modified = icons.git.modified,
                                removed = icons.git.removed,
                            },
                        },
                    },
                    lualine_y = {
                        { "progress" },
                    },
                    lualine_z = { "location" },
                },
                tabline = {},
                extensions = { "lazy" },
            }
        end,
    },
    { -- Indent guides
        "lukas-reineke/indent-blankline.nvim",
        version = false,
        event = { "BufReadPost", "BufNewFile" },
        opts = {
            char = "▏",
            show_trailing_blankline_indent = false,
            show_first_indent_level = false,
            use_treesitter = true,
            show_current_context = true,
            buftype_exclude = { "terminal", "nofile" },
            filetype_exclude = {
                "alpha",
                "help",
                "lazy",
                "mason",
                "NvimTree",
                "packer",
                "Trouble",
            },
        },
    },
    { -- UI replacement
        "folke/noice.nvim",
        event = "VeryLazy",
        enabled = false,
        version = false,
        dependencies = {
            -- {
            --     "MunifTanjim/nui.nvim",
            -- },
            -- {
            --     "rcarriga/nvim-notify",
            -- },
            {
                "folke/which-key.nvim",
                opts = function(_, opts)
                    if require("user.utils").lazy_has_plugin("noice.nvim") then
                        opts.defaults["<leader>sn"] = { name = "noice" }
                    end
                end,
            },
        },
        opts = {
            popupmenu = {
                enabled = false,
            },
            lsp = {
                override = {
                    ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
                    ["vim.lsp.util.stylize_markdown"] = true,
                    ["cmp.entry.get_documentation"] = true,
                },
                hover = {
                    enabled = false,
                },
                signature = {
                    enabled = false,
                },
            },
            routes = {
                {
                    filter = {
                        event = "msg_show",
                        find = "%d+L, %d+B",
                    },
                    view = "mini",
                },
            },
            presets = {
                bottom_search = false,
                command_palette = true,
                long_message_to_split = true,
                inc_rename = true,
            },
        },
        -- TODO: check these keys
            -- stylua: ignore
            keys = k.noice.keys,
        -- {
        --         { "<S-Enter>", function() require("noice").redirect(vim.fn.getcmdline()) end, mode = "c", desc = "Redirect Cmdline" },
        --         { "<leader>snl", function() require("noice").cmd("last") end, desc = "Noice Last Message" },
        --         { "<leader>snh", function() require("noice").cmd("history") end, desc = "Noice History" },
        --         { "<leader>sna", function() require("noice").cmd("all") end, desc = "Noice All" },
        --         { "<leader>snd", function() require("noice").cmd("dismiss") end, desc = "Dismiss All" },
        --         { "<c-f>", function() if not require("noice.lsp").scroll(4) then return "<c-f>" end end, silent = true, expr = true, desc = "Scroll forward", mode = {"i", "n", "s"} },
        --         { "<c-b>", function() if not require("noice.lsp").scroll(-4) then return "<c-b>" end end, silent = true, expr = true, desc = "Scroll backward", mode = {"i", "n", "s"}},
        -- },
    },
    { -- "Welcome screen"
        "goolord/alpha-nvim",
        version = false,
        event = "VimEnter",
        dependencies = {
            "telescope.nvim",
            "project.nvim",
        },
        opts = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                -- [[                                   ]],
                -- [[     ____  _              _______  ]],
                -- [[    |  _ \(_)            |__   __| ]],
                -- [[    | |_) |_ _ __ ___   ___ | |    ]],
                -- [[    |  _ <| | '_ ` _ \ / _ \| |    ]],
                -- [[    | |_) | | | | | | | (_) | |    ]],
                -- [[    |____/|_|_| |_| |_|\___/|_|    ]],
                -- [[                                   ]],
                [[                                           ]],
                [[  ██████╗ ██╗███╗   ███╗ ██████╗ ████████╗ ]],
                [[  ██╔══██╗██║████╗ ████║██╔═══██╗╚══██╔══╝ ]],
                [[  ██████╔╝██║██╔████╔██║██║   ██║   ██║    ]],
                [[  ██╔══██╗██║██║╚██╔╝██║██║   ██║   ██║    ]],
                [[  ██████╔╝██║██║ ╚═╝ ██║╚██████╔╝   ██║    ]],
                [[  ╚═════╝ ╚═╝╚═╝     ╚═╝ ╚═════╝    ╚═╝    ]],
                [[                                           ]],
            }
            dashboard.section.buttons.val = {
                dashboard.button("f", " " .. " Find file", ":Telescope find_files <CR>"),
                dashboard.button("e", " " .. " New file", ":ene <BAR> startinsert <CR>"),
                -- dashboard.button("p", " " .. " Find project", ":lua require('telescope').extensions.projects.projects()<CR>"),
                dashboard.button("p", " " .. " Find project", "<cmd>Telescope projects <cr>"),
                dashboard.button("r", " " .. " Recent files", ":Telescope oldfiles <CR>"),
                dashboard.button("t", " " .. " Find text", ":Telescope live_grep <CR>"),
                dashboard.button("c", " " .. " Config", ":e ~/.config/nvim/init.lua <CR>"),
                dashboard.button("q", " " .. " Quit", ":qa<CR>"),
            }
            for _, button in ipairs(dashboard.section.buttons.val) do
                button.opts.hl = "AlphaButtons"
                button.opts.hl_shortcut = "AlphaShortcut"
            end
            dashboard.section.header.opts.hl = "AlphaHeader"
            dashboard.section.buttons.opts.hl = "AlphaButtons"
            dashboard.section.footer.opts.hl = "AlphaFooter"
            -- dashboard.opts.layout[1].val = 0 -- figure out what this does
            return dashboard
        end,

        config = function(_, dashboard)
            -- close Lazy and re-open when the dashboard is ready
            -- TODO: check if this is correct
            if vim.o.filetype == "lazy" then
                vim.cmd.close()
                vim.api.nvim_create_autocmd("User", {
                    pattern = "AlphaReady",
                    callback = function()
                        require("lazy").show()
                    end,
                })
            end

            require("alpha").setup(dashboard.opts)

            vim.api.nvim_create_autocmd("User", {
                pattern = "VimStarted",
                callback = function()
                    local stats = require("lazy").stats()
                    local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
                    dashboard.section.footer.val = "⚡ Neovim loaded " .. stats.count .. " plugins in " .. ms .. "ms"
                    pcall(vim.cmd.AlphaRedraw)
                end,
            })
        end,
    },
    { -- LSP symbols for lualine
        "SmiteshP/nvim-navic",
        version = false,
        enabled = false,
        lazy = true,
        init = function()
            vim.g.navic_silence = false
            require("user.utils").on_attach(function(client, buffer)
                if client.server_capabilities.documentSymbolProvider then
                    require("nvim-navic").attach(client, buffer)
                end
            end)
        end,
        opts = function()
            return {
                separator = " ",
                highlight = true,
                depth_limit = 1,
                icons = require("user.utils").icons.cmp_icons,
            }
        end,
    },
    { -- icons
        "nvim-tree/nvim-web-devicons",
        version = false,
        lazy = true,
    },
    { -- ui components
        "MunifTanjim/nui.nvim",
        version = false,
        enabled = true,
        lazy = true,
    },
}

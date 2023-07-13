-- snippet engine, snippet collection and completion plugins

return {
    { -- the engine for snippets
        "L3MON4D3/LuaSnip",
        version = false,
        dependencies = {
            -- premade collection of snippets
            "rafamadriz/friendly-snippets",
            version = false,
            config = function()
                require("luasnip.loaders.from_vscode").lazy_load({
                    exclude = {
                        "license",
                    },
                })
            end,
        },
    },
    { -- The completion plugin
        "hrsh7th/nvim-cmp",
        version = false,
        event = "InsertEnter",
        dependencies = {
            { -- buffer completions
                "hrsh7th/cmp-buffer",
                version = false,
            },
            { -- path completions
                "hrsh7th/cmp-path",
                version = false,
            },
            { -- snippet completions
                "saadparwaiz1/cmp_luasnip",
                version = false,
            },
            -- "hrsh7th/cmp-nvim-lsp", --NOTE: this should be installed in the lsp.lua file
            -- { -- Try and see if this is necessary
            --     "hrsh7th/cmp-nvim-lua",
            --     version = false,
            -- },
            { -- better autocomplete sorting for items starting with an underscore
                "lukas-reineke/cmp-under-comparator",
                version = false,
            },
        },
        opts = function()
            local kind_icons = require("user.utils").icons.cmp_icons
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            return {
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                sources = {
                    -- { name = "nvim_lua", keyword_length = 2 },
                    { name = "nvim_lsp", keyword_length = 2 },
                    { name = "luasnip", keyword_length = 2 },
                    { name = "path" },
                    --[[ { name = "buffer", keyword_length = 5 }, ]]
                },
                mapping = {
                    ["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-p>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<C-n>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
                    ["<Down>"] = {
                        i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
                    },
                    ["<Up>"] = {
                        i = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
                    },
                    ["<C-b>"] = cmp.mapping(cmp.mapping.scroll_docs(-1), { "i", "c" }),
                    ["<C-f>"] = cmp.mapping(cmp.mapping.scroll_docs(1), { "i", "c" }),
                    ["<C-Space>"] = cmp.mapping(cmp.mapping.complete(), { "i", "c" }),
                    ["<C-e>"] = cmp.mapping({
                        i = cmp.mapping.abort(),
                        c = cmp.mapping.close(),
                    }),
                    -- Accept currently selected item. If none selected, then select first item.
                    -- set 'select' to false to only confirm explicitly selected items
                    -- Try out the <S-Space> keybinding instead of ";"
                    [";"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            local entry = cmp.get_selected_entry()
                            if not entry then
                                cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
                            else
                                cmp.confirm({
                                    behavior = cmp.ConfirmBehavior.Insert,
                                    select = true,
                                })
                            end
                            -- cmp.mapping.confirm({
                            --     behavior = cmp.ConfirmBehavior.Insert,
                            --     select = true,
                            -- })
                        else
                            fallback()
                        end
                    end, { "i", "s", "c" }),
                    ["<Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_next_item()
                        elseif luasnip.expand_or_locally_jumpable() then
                            luasnip.expand_or_jump()
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                    ["<S-Tab>"] = cmp.mapping(function(fallback)
                        if cmp.visible() then
                            cmp.select_prev_item()
                        elseif luasnip.jumpable(-1) then
                            luasnip.jump(-1)
                        else
                            fallback()
                        end
                    end, { "i", "s" }),
                },
                formatting = {
                    fields = {
                        "kind",
                        "abbr",
                        "menu",
                    },
                    format = function(entry, vim_item)
                        vim_item.kind = kind_icons[vim_item.kind]
                        vim_item.menu = ({
                            nvim_lsp = "[lsp]",
                            -- nvim_lua = "[lua]",
                            luasnip = "[snip]",
                            --[[ buffer   = "[buf]", ]]
                            path = "[path]",
                            emoji = "",
                        })[entry.source.name]
                        return vim_item
                    end,
                },
                sorting = {
                    comparators = {
                        cmp.config.compare.offset,
                        cmp.config.compare.exact,
                        cmp.config.compare.score,
                        require("cmp-under-comparator").under,
                        cmp.config.compare.kind,
                        cmp.config.compare.sort_text,
                        cmp.config.compare.length,
                        cmp.config.compare.order,
                    },
                },
                confirm_opts = {
                    behavior = cmp.ConfirmBehavior.Replace,
                    select = false,
                },
                window = {
                    completion = cmp.config.window.bordered(),
                    documentation = cmp.config.window.bordered(),
                },
                experimental = {
                    ghost_text = true,
                },
                enabled = function()
                    -- disable completion in comments
                    local context = require("cmp.config.context")
                    -- keep command mode completion enabled when cursor in comments
                    if vim.api.nvim_get_mode().mode == "c" then
                        return true
                    else
                        return not context.in_treesitter_capture("comment") and not context.in_syntax_group("Comment")
                    end
                end,
            }
        end,
    },
}

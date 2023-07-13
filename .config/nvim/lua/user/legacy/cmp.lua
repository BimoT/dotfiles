local cmp_status_ok, cmp = pcall(require, "cmp")
if not cmp_status_ok then return end

local snip_status_ok, luasnip = pcall(require, "luasnip")
if not snip_status_ok then return end

require("luasnip.loaders.from_vscode").lazy_load()

--[[ local check_backspace = function()
    local col = vim.fn.col(".") - 1
    return col == 0 or vim.fn.getline("."):sub(col, col):match("%s")
end ]]


local kind_icons = {
    Array = " ",
    Boolean = " ",
    Class = "",
    Color = " ",
    Constant = " ",
    Constructor = " ",
    Copilot = " ",
    Enum = " ",
    EnumMember = " ",
    Event = " ",
    Field = "",
    File = " ",
    Folder = " ",
    Function = " ",
    Interface = " ",
    Key = " ",
    Keyword = " ",
    Method = " ",
    Module = " ",
    Namespace = " ",
    Null = " ",
    Number = " ",
    Object = " ",
    Operator = "",
    Package = " ",
    Property = " ",
    Reference = "",
    Snippet = " ",
    String = " ",
    Struct = " ",
    Text = " ",
    TypeParameter = " ",
    Unit = "",
    Value = "",
    Variable = " ",
}

cmp.setup({
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body) -- for luasnip users
        end,
    },
    mapping = {
		["<C-k>"] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert}),
		["<C-j>"] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert}),
        ['<Down>'] = {
      i = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
    },
    ['<Up>'] = {
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
        
        [";"] = cmp.mapping(
            cmp.mapping.confirm({
                behavior = cmp.ConfirmBehavior.Insert,
                select = true }),
            { "i", "c" }),

        --[[ ["<Tab>"] = cmp.config.disable, ]]

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
				nvim_lua = "[lua]",
				luasnip  = "[snip]",
				--[[ buffer   = "[buf]", ]]
				path     = "[path]",
				emoji    = "",
            })[entry.source.name]
            return vim_item
        end,
    },
    sources = {
		{ name = "nvim_lua" },
        { name = "nvim_lsp" },
		{ name = "luasnip" },
		{ name = "path" },
		--[[ { name = "buffer", keyword_length = 5 }, ]]
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
    end
})

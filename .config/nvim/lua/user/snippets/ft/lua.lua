local ls = require("luasnip")
local snippet_collection = require("luasnip.session.snippet_collection")

local helpers = require("user.snippet_helpers")

local s = ls.s
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local t = ls.text_node

local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

-- TODO: finish snippet or enable comment snippet from lua_languageserver
-- ls.add_snippets("lua", {
--     s({trig="annotate", dscr="Annotations from Lua_languageserver"},
--     fmta([[<>]], {
--             d(1, function (args, parent, user_args)
--                 local linenr, _ = vim.api.nvim_win_get_cursor(0)
--                 local next_line_raw = vim.api.nvim_buf_get_lines(0, linenr, linenr + 1, false)
--
--                 local next_line = next_line_raw[1] or ""
--                 local i, j = string.find(next_line, "%(([^%)]*)%)")
--                 string.sub(next_line)
--
--             end)
--         })
--
--     ),
-- })

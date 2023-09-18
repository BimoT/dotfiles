local ls = require("luasnip")
local snippet_collection = require("luasnip.session.snippet_collection")

local calculate_commentstring = require("Comment.ft").calculate
local comment_utils = require("Comment.utils")
local s = ls.s
local sn = ls.snippet_node
local i = ls.insert_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node
local t = ls.text_node
local fmta = require("luasnip.extras.fmt").fmta

local function get_commentstring()
    local cstring = calculate_commentstring({ ctype = 1, range = comment_utils.get_region() }) or vim.bo.commentstring
    local left, right = comment_utils.unwrap_cstr(cstring)
    return { left, right }
end

ls.add_snippets("all", {
    s(
        { trig = "todo", dscr = "Adds TODO comment" },
        fmta("<> <>: <><>", {
            f(function()
                return get_commentstring()[1]
            end),
            c(1, {
                t("TODO"),
                t("FIX"),
                t("WARN"),
                t("HACK"),
                t("NOTE"),
                t("PERF"),
            }),
            i(2),
            i(0),
        })
    ),
})

local ls = require("luasnip")
local snippet_collection = require("luasnip.session.snippet_collection")

local helpers = require("user.snippets.helpers")
local thelpers = require("user.snippets.ft.tex.helpers")

local s = ls.s
local sn = ls.snippet_node
local i = ls.insert_node
local t = ls.text_node
local c = ls.choice_node
local d = ls.dynamic_node
local f = ls.function_node

local ts_utils = require("nvim-treesitter.ts_utils")
local ts_locals = require("nvim-treesitter.locals")

local fmta = require("luasnip.extras.fmt").fmta
local rep = require("luasnip.extras").rep

ls.add_snippets("tex", {
    s(
        { trig = "italic", dscr = "Makes text Italic" },
        fmta("\\textit{<>}", {
            d(1, helpers.get_visual),
        })
    ),
    s(
        { trig = "bold", dscr = "Makes text bold" },
        fmta("\\textbf{<>}", {
            d(1, helpers.get_visual),
        })
    ),
    s(
        { trig = "emph", dscr = "Emphasizes text" },
        fmta("\\emph{<>}", {
            d(1, helpers.get_visual),
        })
    ),
    s(
        { trig = "underline", dscr = "Underlines text" },
        fmta("\\underline{<>}", {
            d(1, helpers.get_visual),
        })
    ),
    s(
        { trig = "multirow", dscr = "Adds multirow" },
        fmta([[\multirow<>[<>]{<>}{<>}{<>}<>]], {
            f(function()
                -- thelpers.package_importer("multirow")
                return ""
            end),
            i(1, "vertical_pos"),
            i(2, "num_rows"),
            c(3, {
                t("*"),
                t("="),
            }),
            i(4, "text"),
            i(0),
        })
    ),
    s(
        { trig = "multicol", dscr = "Adds multicolumn in table" },
        fmta([[\multicolumn{<>}{<>}{<>}<>]], {
            i(1, "num_cols"),
            c(2, {
                t("c"),
                t("l"),
                t("r"),
            }),
            i(3, "text"),
            i(0),
        })
    ),
    s({ trig = "item", dscr = "Insert an item" }, fmta("\\item <>", i(0))),
    s(
        { trig = "begin", dscr = "Begin environment" },
        fmta(
            [[
\begin{<>}
<>
\end{<>}
]],
            { i(1, "environment"), i(0), rep(1) }
        )
    ),
    s(
        { trig = "enumerate", dscr = "Enumerate environment" },
        fmta(
            [[
\begin{enumerate}
<>
\end{enumerate}
]],
            { d(1, thelpers.get_visual_itemize) }
        )
    ),
    s(
        { trig = "itemize", dscr = "Itemize environment" },
        fmta(
            [[
\begin{itemize}
<>
\end{itemize}
]],
            { d(1, thelpers.get_visual_itemize) }
        )
    ),
    s(
        { trig = "description", dscr = "Description environment" },
        fmta(
            [[
\begin{description}
    \item[<>]<>
\end{description}
]],
            { i(1, "item_name"), i(0) }
        )
    ),
    s(
        { trig = "titleformat", dscr = "Formats section titles" },
        fmta(
            [[
\titleformat<>{<>}
{<>}
{<>}
{<>}
[<>]<>
]],
            {
                f(function()
                    -- thelpers.package_importer("titlesec")
                    return ""
                end),
                i(1, "command"),
                i(2, "label"),
                i(3, "separator"),
                i(4, "before_code"),
                i(5, "after_code"),
                i(0),
            }
        )
    ),
    s(
        { trig = "figure", dscr = "Include figure" },
        fmta(
            [[
\begin{figure}[<>]<>
    \centering
    \includegraphics[width=<>]{<>}
    \caption{<>}
    \label{fig:<>}
\end{figure}<>
    ]],
            {
                c(1, {
                    t("h"),
                    t("t"),
                    t("b"),
                    t("p"),
                    t("H"),
                }),
                f(thelpers.transform_table_position, { 1 }),
                i(2, "width"),
                i(3, "file_path"),
                i(4, "caption"),
                i(5, "label"),
                i(0),
            }
        )
    ),
    s(
        { trig = "usepackage", dscr = "Import package" },
        fmta([[\usepackage<>{<>}<>]], {
            c(1, {
                t(""),
                sn(nil, { t("["), i(1), t("]") }),
            }),
            i(2, "packagename"),
            i(0),
        })
    ),
    --================Tables================
    s(
        { trig = "taby", dscr = "Tabulary environment" },
        fmta(
            [[
\begin{table}[<>]<>
    \caption{<>}
    \label{tab:<>}
    \begin{center}
        \begin{tabulary<>}{<>}[<>]{<>}
        <>
        \end{tabulary}
    \end{center}
\end{table}
]],
            {
                c(1, { t("h"), t("t"), t("b"), t("p"), t("H") }),
                f(thelpers.transform_table_position, { 1 }),
                i(2, "caption"),
                i(3, "label"),
                f(function()
                    -- thelpers.package_importer("tabularx")
                    return ""
                end),
                i(4, "width"),
                i(5, "position"),
                i(6, "preamble"),
                i(0),
            }
        )
    ),
    s(
        { trig = "tabx", dscr = "Tabularx environment" },
        fmta(
            [[
\begin{table}[<>]<>
    \caption{<>}
    \label{tab:<>}
    \begin{center}
        \begin{tabularx<>}{<>}[<>]{<>}
        <>
        \end{tabularx}
    \end{center}
\end{table}
]],
            {
                c(1, { t("h"), t("t"), t("b"), t("p"), t("H") }),
                f(thelpers.transform_table_position, { 1 }),
                i(2, "caption"),
                i(3, "label"),
                f(function()
                    -- thelpers.package_importer("tabularx")
                    return ""
                end),
                i(4, "width"),
                i(5, "position"),
                i(6, "preamble"),
                i(0),
            }
        )
    ),
    s(
        { trig = "threeparttable", dscr = "Include threeparttable" },
        fmta(
            [[
\begin{table}[<>]
    \begin{threeparttable}[<>]
    \caption{<>}
    \label{tab:<>}
    \begin{center}
        \begin{<>}<>
            <>
        \end{<>}
        \begin{tablenotes}
            
        \end{tablenotes}
    \end{center}
    \end{threeparttable}
\end{table}
            ]],
            {
                c(1, { t("h"), t("t"), t("b"), t("p"), t("H") }),
                c(2, { t("t"), t("b"), t("c") }),
                i(3, "caption"),
                i(3, "label"),
                c(4, { t("tabular"), t("tabular*"), t("tabulary"), t("tabularx") }),
                d(5, function(args, parent, user_args)
                    local txt = args[1][1]
                    if type(txt) ~= "string" then
                        error("not text", 1)
                    end
                    vim.notify(tostring(txt), vim.log.levels.DEBUG, {})
                    if txt == "tabular" then
                        return sn(
                            nil,
                            fmta("{<>}", {
                                i(1, "column_spec"),
                            })
                        )
                    elseif txt == "tabularx" or txt == "tabulary" or txt == "tabular*" then
                        return sn(
                            nil,
                            fmta("{<>}{<>}", {
                                i(1, "table_width"),
                                i(2, "column_spec"),
                            })
                        )
                    else
                        return sn(nil, { i(1) })
                    end
                end, { 4 }), -- TODO: give correct options based on node 4
                i(0),
                rep(4),
            }
        )
    ),

    s({ trig = "chapter", dscr = "Chapter" }, fmta([[\chapter{<>}<>]], { i(1, "name"), i(0) })),
    s({ trig = "section", dscr = "Section" }, fmta([[\section{<>}<>]], { i(1, "name"), i(0) })),
    s({ trig = "subsection", dscr = "Subsection" }, fmta([[\subsection{<>}<>]], { i(1, "name"), i(0) })),
    s({ trig = "subsubsection", dscr = "Subsubsection" }, fmta([[\subsubsection{<>}<>]], { i(1, "name"), i(0) })),

    s({ trig = "label", dscr = "Label" }, fmta([[\label{<>}<>]], { i(1, "label"), i(0) })),
    s({ trig = "reference", dscr = "Reference" }, fmta([[\ref{<>}<>]], { i(1, "reference"), i(0) })),
    --========= Mathematics =========
    s(
        { trig = "matrix", dscr = "Matrix" },
        fmta(
            [[
\begin{<>}
    <>
\end{<>}
]],
            {
                c(1, {
                    t("matrix"),
                    t("pmatrix"),
                    t("bmatrix"),
                    t("Bmatrix"),
                    t("vmatrix"),
                    t("Vmatrix"),
                    t("smallmatrix"),
                }),
                i(0),
                rep(1),
            }
        )
    ),
    s(
        { trig = "fraction", dscr = "Fraction" },
        fmta([[\frac{<>}{<>}<>]], {
            i(1, "top"),
            i(2, "bottom"),
            i(0),
        })
    ),
    s(
        { trig = "binom", dscr = "Binomial" },
        fmta([[\binom{<>}{<>}<>]], {
            i(1, "top"),
            i(2, "bottom"),
            i(0),
        })
    ),
    s(
        { trig = "summation", dscr = "Summation" },
        fmta([[\sum_{<>}^{<>} <>]], {
            i(1, "bottom"),
            i(1, "top"),
            i(0, "formula"),
        })
    ),
    s(
        { trig = "integral", dscr = "Integral" },
        fmta([[\int_{<>}^{<>} <>]], {
            i(1, "bottom"),
            i(1, "top"),
            i(0, "formula"),
        })
    ),
    s(
        { trig = "math", dscr = "Math environment" },
        fmta(
            [[
\begin{math}
    <>
\end{math}
]],
            { i(0) }
        )
    ),
    s(
        { trig = "displaymath", dscr = "Displaymath environment" },
        fmta(
            [[
\begin{displaymath}
    <>
\end{displaymath}
]],
            { i(0) }
        )
    ),

    -- Programming TeX
    s(
        { trig = "newcommand", dscr = "Create new command" },
        fmta("\\newcommand{<>}<>{<>}<>", {
            i(1, "name"),
            c(2, {
                t(""),
                sn(nil, fmta("[<>]", { i(1, "nr_args") })),
                sn(nil, fmta("[<>][<>]", { i(1, "nr_args"), i(2, "default_arg") })),
            }),
            i(3, "body"),
            i(0),
        })
    ),
    s(
        { trig = "newenvironment", dscr = "Create new environment" },
        fmta(
            [[
\newenvironment{<>}<>
{<>}
{<>}<>
]],
            {
                i(1, "name"),
                c(2, {
                    t(""),
                    sn(nil, fmta("[<>]", { i(1, "nr_args") })),
                    sn(nil, fmta("[<>][<>]", { i(1, "nr_args"), i(2, "default_arg") })),
                }),
                i(3, "before"),
                i(4, "after"),
                i(0),
            }
        )
    ),
})

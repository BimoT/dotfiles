local status_ok, npairs = pcall(require, "nvim-autopairs")
if not status_ok then return end

npairs.setup({
    check_ts = true, -- treesitter integration
    disable_filetype = { "TelescopePrompt" },
})

local status_ok_rules, Rule = pcall(require, "nvim-autopairs.rule")
if not status_ok_rules then return end
local status_ok_cond, cond = pcall(require, "nvim-autopairs.conds")
if not status_ok_rules then return end

npairs.add_rules({
    Rule("$", "$", { "tex", "latex" })
    -- don't add a pair if the next character is "%"
    :with_pair(cond.not_after_regex("%%"))
    -- don't add a pair if the next character is "$"
    :with_pair(cond.not_after_regex("%$"))
    -- don't add a pair if the previous character is "\"
    :with_pair(cond.not_before_regex("\\"))
})

npairs.add_rules({
    Rule("`", "`", { "tex", "latex" })
    -- Disable completely because quotation in latex
    :with_pair(cond.none())
})

npairs.add_rules({
    Rule("'", "'", { "tex", "latex" })
    -- Disable completely because quotation in latex
    :with_pair(cond.none())
})

npairs.add_rules({
    Rule('"', '"', { "tex", "latex" })
    -- Disable completely because quotation in latex
    :with_pair(cond.none())
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local status_ok_cmp, cmp = pcall(require, "cmp")
if not status_ok_cmp then return end

cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))

return {
    "windwp/nvim-autopairs",
    opts =  {
        check_ts = true,
        disable_filetypes = {
            "TelescopePrompt"
        }
    },
    init = function ()
        local npairs = require("nvim-autopairs")
        local rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")
        npairs.add_rules({
            rule("$", "$", { "tex", "latex" })
                -- don't add a pair if the next character is "%"
                :with_pair(cond.not_after_regex("%%"))
                -- don't add a pair if the next character is "$"
                :with_pair(cond.not_after_regex("%$"))
                -- don't add a pair if the previous character is "\"
                :with_pair(cond.not_before_regex("\\"))
        })

        npairs.add_rules({
            rule("`", "`", { "tex", "latex" })
                -- Disable completely because quotation in latex
                :with_pair(cond.none())
        })

        npairs.add_rules({
            rule("'", "'", { "tex", "latex" })
                -- Disable completely because quotation in latex
                :with_pair(cond.none())
        })

        npairs.add_rules({
            rule('"', '"', { "tex", "latex" })
                -- Disable completely because quotation in latex
                :with_pair(cond.none())
        })

        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local status_ok_cmp, cmp = pcall(require, "cmp")
        if not status_ok_cmp then return end

        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done({}))
    end
}

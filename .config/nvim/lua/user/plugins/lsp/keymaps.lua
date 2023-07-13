-- Modified from LazyVim/LazyVim/lua/lazyvim/plugins/lsp/format.lua

local M = {}

M._keys = nil

---@return (LazyKeys|{has?:string})[]
function M.get()
    local format = function()
        require("user.plugins.lsp.formatting").format({ force = true })
    end

    if not M._keys then
        -- stylua: ignore
        M._keys = {
            --TODO: populate table of keybindings
            {"<leader>lD", "<cmd>lua vim.lsp.buf.declaration()<CR>",          desc = "Declaration"       },
            {"<leader>ld", "<cmd>Telescope lsp_definitions<CR>",              desc = "Definition", has = "definition" },
            {"<leader>li", "<cmd>lua vim.lsp.buf.implementation()<CR>",       desc = "Implementation"    },
            {"<leader>lR", "<cmd>Telescope lsp_references<cr>",               desc = "References" },
            {"<leader>lo", "<cmd>lua vim.diagnostic.open_float()<CR>",        desc = "Float diagnostics" },
            {"<leader>la", "<cmd>lua vim.lsp.buf.code_action()<CR>", mode = "v", desc = "Code action", has = "codeAction" },
            {"<leader>lh", "<cmd>lua vim.lsp.buf.hover()<CR>",                desc = "Hover"             },
            {"<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>",       desc = "Signature help", has = "signatureHelp"    },
            {"<leader>lf", format, desc = "Format document", has = "documentFormatting"        },
            {"<leader>lf", format, desc = "Format range", mode = "v", has = "documentRangeFormatting"        },
            {"<leader>lj", M.diagnostic_goto(true),                           desc = "Next diagnostic"   },
            {"<leader>lk", M.diagnostic_goto(false),                          desc = "Prev diagnostic"   },
            {"]e",         M.diagnostic_goto(true, "ERROR"),                  desc = "Next Error"        },
            {"[e",         M.diagnostic_goto(false, "ERROR"),                 desc = "Prev Error"        },
            {"]w",         M.diagnostic_goto(true, "WARN"),                   desc = "Next Warning"      },
            {"[w",         M.diagnostic_goto(false, "WARN"),                  desc = "Prev Warning"      },
            -- {"<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>",        desc = "Setloclist"        },
        }

        if require("user.utils").lazy_has_plugin("inc-rename.nvim") then
            M._keys[#M._keys + 1] = {
                --TODO: set keymap for incremental renaming
                "<leader>lr",
                "<cmd>IncRename<cr>",
                -- function()

                -- local inc_rename = require("inc_rename")
                -- return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
                -- end,
                -- expr = true,
                desc = "Rename",
                has = "rename",
            }
        else
            M._keys[#M._keys + 1] = {
                "<leader>lr",
                vim.lsp.buf.rename,
                desc = "Rename",
                has = "rename",
            }
        end
    end
    return M._keys
end

function M.on_attach(client, buffer)
    local Keys = require("lazy.core.handler.keys")
    local keymaps = {}

    -- for _, value in ipairs(M.get()) do
    --     local keys = Keys.parse(value)
    --     if keys[2] == vim.NIL or keys[2] == false then
    --         keymaps[keys.id] = nil
    --     else
    --         keymaps[keys.id] = keys
    --     end
    -- end

    -- TODO: this is also in the M.get() function
    local format = function()
        require("user.plugins.lsp.formatting").format({ force = true })
    end
    --
    local wk = require("which-key")
    -- local km = {}
    -- for _, value in ipairs(M.get()) do
    --     km[value[1]] = { value[2], desc = desc, mode = mode or "n" }
    -- end
    -- wk.register(km)

    wk.register({
        -- ["<leader>l"] = { name = "LSP" },
        ["<leader>lD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
        -- ["<leader>ld"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
        ["<leader>ld"] = { "<cmd>Telescope lsp_definitions<CR>", "Definition" },
        ["<leader>li"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
        ["<leader>lo"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Float diagnostics" },
        ["<leader>lR"] = { "<cmd>Telescope lsp_references<CR>", "References" },
        -- TODO: update this one
        ["<leader>lf"] = { format, "Format document" },
        ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
        ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["<leader>lj"] = { M.diagnostic_goto(true), "Next diagnostic" },
        ["<leader>lk"] = { M.diagnostic_goto(false), "Previous diagnostic" },
        ["]e"] = { "<cmd>lua vim.diagnostic.goto_next({severity = 'ERROR'})<cr>", "Next Error" },
        ["[e"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = 'ERROR'})<cr>", "Prev Error" },
        ["]w"] = { "<cmd>lua vim.diagnostic.goto_next({severity = 'WARN'})<cr>", "Next Warning" },
        ["[w"] = { "<cmd>lua vim.diagnostic.goto_prev({severity = 'WARN'})<cr>", "Prev Warning" },
        ["<leader>ls"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
        -- ["<leader>lq"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Setloclist" },
        --[[ Requires "lsp_lines"]]
        -- ["<leader>ll"] = { "<cmd>lua require('lsp_lines').toggle()<CR>", "Toggle lsp_lines" },
    }, {
        mode = "n",
        prefix = "",
        buffer = bufnr,
        silent = true,
        noremap = true,
        nowait = true,
    })

    wk.register({
        ["<leader>lr"] = {
            function()
                local ok, inc_rename = pcall(require, "inc_rename")
                if ok then
                    return ":" .. inc_rename.config.cmd_name .. " " .. vim.fn.expand("<cword>")
                else
                    return vim.lsp.buf.rename
                end
            end,
            "Rename",
        },
    }, {
        mode = "n",
        prefix = "",
        buffer = bufnr,
        expr = true,
        silent = true,
        noremap = true,
        nowait = true,
    })
    wk.register({
        ["<leader>lf"] = { format, "Format range" },
    }, {
        mode = "v",
        prefix = "",
        buffer = bufnr,
        silent = true,
        noremap = true,
        nowait = true,
    })
    -- for _, keys in pairs(keymaps) do
    --     if not keys.has or client.server_capabilities[keys.has .. "Provider"] then
    --         local opts = Keys.opts(keys)
    --         opts.has = nil
    --         opts.silent = opts.silent ~= false
    --         opts.buffer = buffer
    --         vim.keymap.set(keys.mode or "n", keys[1], keys[2], opts)
    --     end
    -- end
end

function M.diagnostic_goto(next, severity)
    local go = next and vim.diagnostic.goto_next or vim.diagnostic.goto_prev
    severity = severity and vim.diagnostic.severity[severity] or nil
    return function()
        go({ severity = severity })
    end
end

return M

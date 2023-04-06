local M = {}
local vim = vim

local status_cmp_ok, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if not status_cmp_ok then return end
local whichkey = require("which-key")

M.capabilities = vim.lsp.protocol.make_client_capabilities()
M.capabilities.textDocument.completion.completionItem.snippetSupport = true
M.capabilities = cmp_nvim_lsp.default_capabilities(M.capabilities)

M.setup = function()
    local signs = {
        { name = "DiagnosticSignError", text = "" },
        { name = "DiagnosticSignWarn", text = "" },
        { name = "DiagnosticSignHint", text = "" },
        { name = "DiagnosticSignInfo", text = "" },
    }

    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name,
            {
                texthl = sign.name,
                text = sign.text,
                numhl = "",
            })
    end

    local config = {
        -- [[ Currently virtual text enabled, checking out lsp_lines ]]
        virtual_text = {
            severity = nil,
            source = nil,
            format = function (diagnostic)
                if diagnostic.severity == vim.diagnostic.severity.ERROR then
                    return string.format("E: %s", diagnostic.message)
                end
                return diagnostic.message
            end,
        },
        signs = true,
        update_in_insert = true,
        underline = true,
        severity_sort = true,
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
            source = "always",
            header = "",
            prefix = "",
        },
    }

    vim.diagnostic.config(config)

    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
        border = "rounded",
    })

    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
        border = "rounded",
    })
end

local function lsp_keymaps(bufnr)
    -- Use WhichKey instead of the regular keymap system, because this gives you a useful help menu
    whichkey.register({
        ["<leader>l"] = { name = "LSP"},
        ["<leader>lD"] = { "<cmd>lua vim.lsp.buf.declaration()<CR>", "Declaration" },
        ["<leader>ld"] = { "<cmd>lua vim.lsp.buf.definition()<CR>", "Definition" },
        ["<leader>li"] = { "<cmd>lua vim.lsp.buf.implementation()<CR>", "Implementation" },
        ["<leader>lo"] = { "<cmd>lua vim.diagnostic.open_float()<CR>", "Float diagnostics" },
        ["<leader>lf"] = { "<cmd>lua vim.lsp.buf.format({async = true})<CR>", "Formatting" },
        ["<leader>la"] = { "<cmd>lua vim.lsp.buf.code_action()<CR>", "Code action" },
        ["<leader>lh"] = { "<cmd>lua vim.lsp.buf.hover()<CR>", "Hover" },
        ["<leader>lj"] = { "<cmd>lua vim.diagnostic.goto_next({buffer=0})<CR>", "Next diagnostic" },
        ["<leader>lk"] = { "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<CR>", "Previous diagnostic" },
        ["<leader>lr"] = { "<cmd>lua vim.lsp.buf.rename()<CR>", "Rename" },
        ["<leader>ls"] = { "<cmd>lua vim.lsp.buf.signature_help()<CR>", "Signature help" },
        ["<leader>lq"] = { "<cmd>lua vim.diagnostic.setloclist()<CR>", "Setloclist" },
        --[[ Requires "lsp_lines"]]
        ["<leader>ll"] = { "<cmd>lua require('lsp_lines').toggle()<CR>", "Toggle lsp_lines" },
    }, {
            mode = "n",
            prefix = "",
            buffer = bufnr,
            silent = true,
            noremap = true,
            nowait = true,
        }
    )
    -- local opts = { noremap = true, silent = true }
    -- local keymap = vim.api.nvim_buf_set_keymap
    -- keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    -- keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
    -- keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
    -- keymap(bufnr, "n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    -- keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
    -- keymap(bufnr, "n", "gl", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    -- keymap(bufnr, "n", "<leader>lf", "<cmd>lua vim.lsp.buf.formatting()<cr>", opts)
    -- keymap(bufnr, "n", "<leader>li", "<cmd>LspInfo<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lI", "<cmd>LspInstallInfo<cr>", opts)
    -- keymap(bufnr, "n", "<leader>la", "<cmd>lua vim.lsp.buf.code_action()<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lj", "<cmd>lua vim.diagnostic.goto_next({buffer=0})<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lk", "<cmd>lua vim.diagnostic.goto_prev({buffer=0})<cr>", opts)
    -- keymap(bufnr, "n", "<leader>lr", "<cmd>lua vim.lsp.buf.rename()<cr>", opts)
    -- keymap(bufnr, "n", "<leader>ls", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    -- keymap(bufnr, "n", "<leader>lq", "<cmd>lua vim.diagnostic.setloclist()<CR>", opts)
end

M.on_attach = function(client, bufnr)
    if client.name == "lua_ls" then
        client.server_capabilities.document_formatting = false
    end

    lsp_keymaps(bufnr)
    local status_ok, illuminate = pcall(require, "illuminate")
    if not status_ok then return end
    illuminate.on_attach(client)
end

return M

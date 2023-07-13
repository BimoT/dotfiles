local dap_status_ok, dap = pcall(require, "dap")
if not dap_status_ok then return end
local dap_ui_status_ok, dapui  = pcall(require, "dapui")
if not dap_ui_status_ok then return end
local dap_install_status_ok, dap_install = pcall(require, "dap-install")
if not dap_install_status_ok then return end

local vt_status_ok, vt = pcall(require, "nvim-dap-virtual-text")
if not vt_status_ok then return end
local python_status_ok, dappython = pcall(require, "dap-python")
if not python_status_ok then return end

dap_install.setup()

dap_install.config("python", {})
-- add other configs here

dapui.setup({
    layouts = {
        {
            elements = {
                { id = "scopes", size = 0.25 },
                { id = "breakpoints", size = 0.25 },
                "stacks",
                "watches",
            },
            size = 40,
            position = "right", -- can be "left", "right", "top", "bottom"
        },
        {
            elements = {
                "repl",
                "console"
            },
            size = 0.25,
            position = "bottom",
        }
    },
})

vim.fn.sign_define("DapBreakpoint", {
    text = "",
    texthl = "DiagnosticSignError",
    linehl = "",
    numhl = ""
})

-- virtual text setup
vt.setup()
-- For "one-small-step-for-vimkind", a neovim lua debugger

--[[ dap.configuration.lua = {
    {
        type = "nlua",
        request = "attach",
        name = "Attach to a running Neovim instance",
        host = function ()
            local value = vim.fn.input("Host [127.0.0.1]: ")
            if value ~= "" then
                return value
            end
            return "127.0.0.1"
        end,
        port = function ()
            local val = tonumber(vim.fn.input("Port: "))
            assert(val, "Please provide a port number")
            return val
        end,
    }
}

dap.adapters.nlua = function (callback, config)
    callback({ type = "server", host = config.host, port = config.port })
end ]]

dappython.setup("~/.virtualenvs/debugpy/bin/python")

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

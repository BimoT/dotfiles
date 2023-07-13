return {
    "mfussenegger/nvim-dap",
    version = false,
    dependencies = {
        {
            "rcarriga/nvim-dap-ui",
            keys = {
                {
                    "<leader>Du",
                    function()
                        require("dapui").toggle()
                    end,
                    desc = "DAP ui toggle",
                },
                {
                    "<leader>De",
                    function()
                        require("dapui").eval()
                    end,
                    desc = "DAP ui eval",
                    mode = { "n", "v" },
                },
            },
            opts = {
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
                            "console",
                        },
                        size = 0.25,
                        position = "bottom",
                    },
                },
            },
            config = function(_, opts)
                local dap = require("dap")
                local dapui = require("dapui")

                -- testing out python debugger
                dap.adapters.python = {
                    type = "executable",
                    command = "python",
                    args = { "-m", "debugpy.adapter" },
                }
                dap.configurations.python = {
                    {
                        type = "python",
                        request = "launch",
                        name = "Launch file",
                        program = "$file",
                        pythonPath = function()
                            local venv_path = vim.fn.getenv("VIRTUAL_ENVIRONMENT")
                            if venv_path ~= vim.NIL and venv_path ~= "" then
                                return venv_path .. "/bin/python"
                            else
                                return "/usr/bin/python"
                            end
                        end,
                    },
                }

                dapui.setup(opts)
                dap.listeners.after.event_initialized["dapui_config"] = function()
                    dapui.open()
                end
                dap.listeners.before.event_terminated["dapui_config"] = function()
                    dapui.close()
                end
                dap.listeners.before.event_exited["dapui_config"] = function()
                    dapui.close()
                end
            end,
        },
        -- Virtual text for debugger
        {
            "theHamsta/nvim-dap-virtual-text",
            version = false,
            opts = {},
        },
        {
            "mfussenegger/nvim-dap-python",
            version = false,
        },
        -- TODO: add lldb, python debugger
        { -- Nvim lua debugger
            "jbyuki/one-small-step-for-vimkind",
            version = false,
            keys = {
                {
                    "<leader>DaL",
                    function()
                        require("osv").launch({ port = 8086 })
                    end,
                    desc = "Adapter Launch (Lua Server)",
                },
                {
                    "<leader>Dar",
                    function()
                        require("osv").run_this()
                    end,
                    desc = "Adapter Run (lua)",
                },
            },
            config = function()
                local dap = require("dap")
                dap.adapters.nlua = function(callback, config)
                    callback({ type = "server", host = config.host or "127.0.0.1", port = config.port or 8086 })
                end
                dap.configurations.lua = {
                    {
                        type = "nlua",
                        request = "attach",
                        name = "Attach to running Neovim instance",
                        host = function()
                            local value = vim.fn.input("Host [127.0.0.1]: ")
                            if value ~= "" then
                                return value
                            end
                            return "127.0.0.1"
                        end,
                        port = function()
                            local val = tonumber(vim.fn.input("Port: "))
                            assert(val, "Please provide a port number")
                            return val
                        end,
                    },
                }
            end,
        },
        {
            "jay-babu/mason-nvim-dap.nvim",
            version = false,
            dependencies = "mason.vim",
            cmd = { "DapInstall", "DapUninstall" },
            opts = {
                automatic_setup = true,
                handlers = {},
                ensure_installed = {
                    -- make sure that stuff is installed manually!
                },
            },
        },
    },
    --TODO: extend DAP list
    keys = {
        {
            "<leader>Db",
            function()
                require("dap").toggle_breakpoint()
            end,
            desc = "Toggle Breakpoint",
        },
        {
            "<leader>Dc",
            function()
                require("dap").continue()
            end,
            desc = "Continue",
        },
        {
            "<leader>Di",
            function()
                require("dap").step_into()
            end,
            desc = "Step Into",
        },
        {
            "<leader>Do",
            function()
                require("dap").step_over()
            end,
            desc = "Step Over",
        },
        {
            "<leader>DO",
            function()
                require("dap").step_out()
            end,
            desc = "Step Out",
        },
        {
            "<leader>Dr",
            function()
                require("dap").repl.toggle()
            end,
            desc = "Toggle REPL",
        },
        {
            "<leader>Dl",
            function()
                require("dap").run_last()
            end,
            desc = "Run Last",
        },
        {
            "<leader>Dt",
            function()
                require("dap").terminate()
            end,
            desc = "Terminate",
        },
    },
    config = function()
        vim.api.nvim_set_hl(0, "DapStoppedLine", {
            default = true,
            link = "Visual",
        })

        -- vim.fn.sign_define("DapBreakpoint", {
        --     text = "",
        --     texthl = "DiagnosticSignError",
        --     linehl = "",
        --     numhl = ""
        -- })

        local icons = require("user.utils").icons
        for name, sign in pairs(icons.dap) do
            sign = type(sign) == "table" and sign or { sign }
            vim.fn.sign_define(
                "Dap" .. name,
                { text = sign[1], texthl = sign[2] or "DiagnosticInfo", linehl = sign[3], numhl = sign[3] }
            )
        end
    end,
}

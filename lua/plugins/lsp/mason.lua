return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
        "neovim/nvim-lspconfig",
    },
    build = ":MasonUpdate",
    config = function()
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")
        local lspconfig = require("lspconfig")

        mason.setup()

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "lua_ls",
                -- "black",
                "pyright",
                "rust_analyzer"
            }
        })

        -- This will set up all servers installed through Mason
        mason_lspconfig.setup_handlers({
            function(server_name)
                lspconfig[server_name].setup({})
            end,
            -- Add custom server configurations if needed
            ["lua_ls"] = function()
                lspconfig.lua_ls.setup({
                    settings = {
                        Lua = {
                            diagnostics = {
                                globals = { "vim" }
                            }
                        }
                    }
                })
            end
        })
    end
}

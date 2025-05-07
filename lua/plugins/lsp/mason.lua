return {
    "williamboman/mason.nvim",
    dependencies = {
        "williamboman/mason-lspconfig.nvim",
    },
    build = ":MasonUpdate",
    config = function()
        local mason = require("mason")

        -- import mason-lspconfig
        local mason_lspconfig = require("mason-lspconfig")

        mason.setup()

        mason_lspconfig.setup({
            -- list of servers for mason to install
            ensure_installed = {
                "lua_ls",
                -- "black",
                "pyright"
            }
        })
    end
}

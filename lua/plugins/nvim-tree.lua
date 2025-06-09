return {
    "nvim-tree/nvim-tree.lua",
    version = "*",
    lazy = false,
    dependencies = {
        "nvim-tree/nvim-web-devicons",
    },
    config = function()
        require("nvim-tree").setup({
            view = {
                side = "right",
            },
            update_focused_file = {
                enable = true,
                update_root = true,
            },
            sync_root_with_cwd = true,
        })

        -- Open tree view
        vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })
    end,
}

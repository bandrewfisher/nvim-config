-- Set leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Show line numbers
vim.opt.number = true

-- Clipboard integration
vim.opt.clipboard = "unnamedplus"

-- Set up tab size
vim.opt.tabstop = 4 	-- Number of visual spaces per tab
vim.opt.shiftwidth = 4	-- Number of spaces to use for each level of indentation
vim.opt.expandtab = true	-- Convert tab to spaces

-- Set scroll navigation
vim.opt.scrolloff = 10
vim.opt.sidescrolloff = 10
vim.opt.wrap = false    -- Disable line wrap
vim.opt.sidescroll = 1

-- search settings
vim.opt.ignorecase = true   -- ignore case when searching
vim.opt.smartcase = true    -- case-sensitive if including mixed case in search

-- cursor line
vim.opt.cursorline = true   -- highlight current cursor line


-- Disable auto comment completions
vim.api.nvim_create_autocmd("FileType", {
    pattern = "*",
    callback = function()
        vim.opt.formatoptions:remove({ "c", "r", "o" })
    end
})

-- Disable highlight when hitting escape
vim.keymap.set('n', '<Esc>', '<cmd>nohlsearch<CR>')

-- Move focus between windows
vim.keymap.set('n', '<C-h>', '<C-w><C-h>', { desc = 'Move focus to the left window' })
vim.keymap.set('n', '<C-l>', '<C-w><C-l>', { desc = 'Move focus to the right window' })
vim.keymap.set('n', '<C-j>', '<C-w><C-j>', { desc = 'Move focus to the lower window' })
vim.keymap.set('n', '<C-k>', '<C-w><C-k>', { desc = 'Move focus to the upper window' })

-- Set up lazy
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
        vim.api.nvim_echo({
            { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
            { out, "WarningMsg" },
            { "\nPress any key to exit..." },
        }, true, {})
        vim.fn.getchar()
        os.exit(1)
    end
end
vim.opt.rtp:prepend(lazypath)


require("lazy").setup({ { import = "plugins" }, { import = "plugins.lsp" } }, {
    -- Optional Lazy.nvim settings (these go in the second argument)
    install = { colorscheme = { "habamax" } },
    checker = { enabled = true },
})


return {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  config = function()
    local keymap = vim.keymap

    -- Add a command to check if LSP is attached
    vim.api.nvim_create_user_command("LspInfo", function()
      local clients = vim.lsp.get_active_clients({ bufnr = 0 })
      if #clients == 0 then
        vim.notify("No LSP clients attached to this buffer", vim.log.levels.WARN)
      else
        local client_names = {}
        for _, client in ipairs(clients) do
          table.insert(client_names, client.name)
        end
        vim.notify("LSP clients: " .. table.concat(client_names, ", "), vim.log.levels.INFO)
      end
    end, {})

    vim.api.nvim_create_autocmd("LspAttach", {
      group = vim.api.nvim_create_augroup("UserLspConfig", {}),
      callback = function(ev)
        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf, silent = true }

        -- set keybinds
        opts.desc = "Show LSP references"
        keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts) -- show definition, references

        opts.desc = "Go to declaration"
        keymap.set("n", "gD", vim.lsp.buf.declaration, opts) -- go to declaration

        opts.desc = "Show LSP definitions"
        keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts) -- show lsp definitions

        opts.desc = "Show LSP implementations"
        keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts) -- show lsp implementations

        opts.desc = "Show LSP type definitions"
        keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts) -- show lsp type definitions

        opts.desc = "See available code actions"
        keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts) -- see available code actions, in visual mode will apply to selection

        -- opts.desc = "Smart rename"
        -- keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts) -- smart rename
        vim.keymap.set("n", "<leader>rn", function()
          local curr_name = vim.fn.expand("<cword>")
          vim.ui.input({ prompt = "New Name: ", default = curr_name }, function(new_name)
            if not new_name or #new_name == 0 or new_name == curr_name then return end

            vim.lsp.buf.rename(new_name)

            -- Delay to let LSP apply edits
            vim.defer_fn(function()
              local visited = {}
              for _, buf in ipairs(vim.api.nvim_list_bufs()) do
                local name = vim.api.nvim_buf_get_name(buf)
                if name ~= "" and vim.api.nvim_buf_get_option(buf, "modified") and not visited[name] then
                  visited[name] = true
                  vim.cmd("tabnew " .. vim.fn.fnameescape(name))
                end
              end
            end, 100)
          end)
        end, { desc = "Smart rename and open modified files in tabs" })


        opts.desc = "Show buffer diagnostics"
        keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts) -- show  diagnostics for file

        opts.desc = "Show line diagnostics"
        keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts) -- show diagnostics for line

        opts.desc = "Go to previous diagnostic"
        keymap.set("n", "[d", vim.diagnostic.goto_prev, opts) -- jump to previous diagnostic in buffer

        opts.desc = "Go to next diagnostic"
        keymap.set("n", "]d", vim.diagnostic.goto_next, opts) -- jump to next diagnostic in buffer

        opts.desc = "Show documentation for what is under cursor"
        keymap.set("n", "K", vim.lsp.buf.hover, opts) -- show documentation for what is under cursor

        opts.desc = "Restart LSP"
        keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts) -- mapping to restart lsp if necessary
      end,
    })
  end,
}

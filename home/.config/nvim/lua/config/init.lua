-- Mapleader
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Line Numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Tab Width
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true

-- Default to clipboard
vim.opt.clipboard = "unnamedplus"

-- Split shortcuts
vim.keymap.set("n", "<leader>vs", "<cmd>vsp<CR>", { desc = "Split vertically" })
vim.keymap.set("n", "<leader>ss", "<cmd>sp<CR>", { desc = "Split horizontally" })


-- Terminal keymaps
vim.keymap.set("n", "<leader>tt", ":terminal<CR>", { desc = "Open terminal" })
vim.keymap.set("n", "<leader>tv", ":rightbelow vsp|terminal<CR>", { desc = "Vertical split terminal" })
vim.keymap.set("n", "<leader>ts", ":belowright sp|terminal<CR>", {desc = "Horizontal split terminal" })
vim.keymap.set("n", "<leader>w", "<C-w>", { desc = "Initiate switch window" } )

-- Map <Esc> in terminal mode
vim.api.nvim_create_autocmd("TermOpen", {
  pattern = "*",
  callback = function()
    vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true, buffer = true })
  end,
})

-- Translate to unix when copy-pasting
vim.api.nvim_create_autocmd({"BufRead"}, {
  pattern = "*",
  callback = function(args)
    vim.bo[args.buf].fileformat = "unix"
    -- Remove carriage returns in-place
    vim.cmd([[%s/\r//ge]])
  end,
})

-- LSP keymaps
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = { buffer = ev.buf }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, { desc = "LSP: go to declaration" })
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = "LSP: go to definition" })
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = "LSP: hover" })
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, { desc = "LSP: go to implementation" })
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "LSP: signature help" })
        vim.keymap.set('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "LSP: add workspace folder" })
        vim.keymap.set('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "LSP: type definition" })
        vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = "LSP: rename" })
        vim.keymap.set({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "LSP: code action" })
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, { desc = "LSP: go to references" })
        vim.keymap.set('n', '<leader>f', function()
            vim.lsp.buf.format { async = true }
        end, { desc = "LSP: format" })
    end,
})

-- Ignore case
vim.opt.ignorecase = true
vim.keymap.set("n", "<leader>ic", ":set ignorecase!<CR>", { desc = "Toggle ignore case" })

-- No highlight search
vim.keymap.set("n", "<Esc>", ":nohlsearch<CR>", { silent = true })

-- Remap quit
vim.keymap.set("n", "<leader>q", "<cmd>q<CR>", { desc = "Close page" })
vim.keymap.set("n", "<leader>Q", "<cmd>qall<CR>", { desc = "Close all pages" })

-- Diagnostics
vim.keymap.set("n", "gl", vim.diagnostic.open_float, { desc = "Show diagnostics" })
vim.keymap.set("n", "gn", vim.diagnostic.goto_next, { desc = "Go to next error" })
vim.keymap.set("n", "gp", vim.diagnostic.goto_prev, { desc = "Go to previous error" })

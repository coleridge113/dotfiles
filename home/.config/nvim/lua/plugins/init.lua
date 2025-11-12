return {

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            require("nvim-treesitter.configs").setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query",
                    "kotlin", "bash", "json", "yaml",
                    "markdown", "markdown_inline",
                },
                highlight = { enable = true, additional_vim_regex_highlighting = false },
                indent = { enable = true },
                incremental_selection = {
                    enable = true,
                    keymaps = {
                        init_selection = "gnn",
                        node_incremental = "grn",
                        scope_incremental = "grc",
                        node_decremental = "grm",
                    },
                },
            })
        end,
    },
    -- Git
    {
        "lewis6991/gitsigns.nvim", config = function()
            require("gitsigns").setup({
                current_line_blame = true, -- inline blame for the current line
                current_line_blame_opts = {
                    delay = 500,
                    virt_text = true,
                    virt_text_pos = "eol", -- eol | overlay | right_align
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "<author>, <author_time:%Y-%m-%d> - <summary>",
            })
            local gs = require("gitsigns")
            vim.keymap.set("n", "<leader>gb", gs.toggle_current_line_blame, { desc = "Git: toggle inline blame" })
            vim.keymap.set("n", "<leader>gl", function() gs.blame_line({ full = true }) end, { desc = "Git: blame line (full)" })
        end
    },
    -- UI/UX
    { "windwp/nvim-autopairs", config = function() require("nvim-autopairs").setup() end },

    -- Telescope
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim",
            { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        },
        config = function()
            require("telescope").setup({
                defaults = {
                    path_display = { "smart" },
                    mappings = { i = { ["<esc>"] = require("telescope.actions").close } },
                },
            })
            local map = vim.keymap.set
            map("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })
            map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope: live grep" })
            map("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Telescope: buffers" })
            map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope: help tags" })
        end,
    },

    -- LSP + Mason
    {
        "williamboman/mason.nvim",
        build = ":MasonUpdate",
        config = function()
            require("mason").setup()
        end,
    },

    {
        "williamboman/mason-lspconfig.nvim",
        dependencies = { "williamboman/mason.nvim", "neovim/nvim-lspconfig" },
        config = function()
            -- ensure Neovim can run mason shims
            vim.env.PATH = os.getenv("HOME")
            .. "/.local/share/nvim/mason/bin:"
            .. os.getenv("HOME")
            .. "/.local/bin:"
            .. vim.env.PATH

            local servers = { "lua_ls", "jdtls", "kotlin_language_server" }
            require("mason-lspconfig").setup({ ensure_installed = servers })

            local function is_lsp_attached(server_name, root_dir)
                local clients = vim.lsp.get_clients({ bufnr = 0 })
                for _, client in ipairs(clients) do
                    if client.name == server_name and client.root_dir == root_dir then
                        return true
                    end
                end
                return false
            end

            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            -- Autocmd for Java files (start jdtls if not already running for this root)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "java",
                callback = function()
                    local root_dir = require("lspconfig.util").root_pattern(
                        "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", "pom.xml", "mvnw", "gradlew", ".git"
                    )(vim.fn.expand("%:p"))
                    if not root_dir then return end
                    if not is_lsp_attached("jdtls", root_dir) then
                        local workspace_dir = os.getenv("HOME") .. "/.local/share/eclipse/" .. vim.fn.fnamemodify(root_dir, ":p:h:t")
                        vim.lsp.start({
                            name = "jdtls",
                            cmd = { "jdtls", "-data", workspace_dir },
                            root_dir = root_dir,
                            capabilities = capabilities,
                        })
                    end
                end,
            })

            -- Autocmd for Kotlin files (start kotlin_language_server if not already running for this root)
            vim.api.nvim_create_autocmd("FileType", {
                pattern = { "kotlin", "kotlin.kts" },
                callback = function()
                    local root_dir = require("lspconfig.util").root_pattern(
                        "settings.gradle", "settings.gradle.kts", "build.gradle", "build.gradle.kts", ".git"
                    )(vim.fn.expand("%:p"))
                    if not root_dir then return end
                    if not is_lsp_attached("kotlin_language_server", root_dir) then
                        vim.lsp.start({
                            name = "kotlin_language_server",
                            cmd = { "kotlin-language-server" },
                            root_dir = root_dir,
                            capabilities = capabilities,
                        })
                    end
                end,
            })

            -- Lua LSP
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "lua",
                callback = function()
                    local root_dir = require("lspconfig.util").root_pattern(".git")(vim.fn.getcwd())
                    if not root_dir then return end
                    if not is_lsp_attached("lua_ls", root_dir) then
                        vim.lsp.start({
                            name = "lua_ls",
                            cmd = { "lua-language-server" },
                            root_dir = root_dir,
                            settings = {
                                Lua = { diagnostics = { globals = { "vim" } } },
                            },
                            capabilities = capabilities,
                        })
                    end
                end,
            })
        end,
    },

    -- Completion
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            cmp.setup({
                snippet = {
                    expand = function(args)
                        require("luasnip").lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = {
                    { name = "supermaven" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                },
            })
        end,
    },

    -- lspconfig plugin entry (ensure available)
    { "neovim/nvim-lspconfig" },

    -- Neo-Tree
    {
        "nvim-neo-tree/neo-tree.nvim",
        branch = "v3.x",
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons", -- optional
            "MunifTanjim/nui.nvim",
        },
        config = function()
            require("neo-tree").setup({
                close_if_last_window = true,
                enable_git_status = true,
                enable_diagnostics = true,
                filesystem = {
                    filtered_items = {
                        hide_dotfiles = false,
                        hide_gitignored = true,
                    },
                    follow_current_file = { enabled = true },
                    hijack_netrw_behavior = "open_default",
                },
                window = {
                    width = 32,
                    mappings = {
                        --            ["<space>"] = "toggle_node",
                        ["<cr>"] = "open",
                        ["S"] = "open_split",
                        ["s"] = "open_vsplit",
                        ["t"] = "open_tabnew",
                        ["C"] = "close_node",
                        ["q"] = "close_window",
                    },
                },
                default_component_configs = {
                    git_status = {
                        symbols = {
                            added = "A",
                            modified = "M",
                            deleted = "D",
                            renamed = "R",
                            untracked = "?",
                            ignored = "I",
                            unstaged = "U",
                            staged = "S",
                            conflict = "!",
                        },
                    },
                },
            })
            vim.keymap.set("n", "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Neo-tree: toggle" })
            vim.keymap.set("n", "<leader>o", "<cmd>Neotree focus<cr>", { desc = "Neo-tree: focus" })
        end,
    },
    -- Super Maven
    {
        "supermaven-inc/supermaven-nvim",
        event = "InsertEnter",
        cmd = { "SupermavenUseFree" },
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
                log_level = "info",
            })
        end,
    },
    -- MiniMap
    { 
        'nvim-mini/mini.nvim', 
        version = false,
        config = function()
            require('mini.map').setup()
            vim.keymap.set('n', '<leader>m', function() require('mini.map').toggle() end, { desc = 'MiniMap: toggle' })
            vim.api.nvim_create_autocmd({ 'BufWinEnter' }, { callback = function() require('mini.map').open() end })
        end,
    },
    {
        "kylechui/nvim-surround",
        version = "^3.0.0", -- Use for stability; omit to use `main` branch for the latest features
        event = "VeryLazy",
        config = function()
            require("nvim-surround").setup({
                -- Configuration here, or leave empty to use defaults
            })
        end
    }
}

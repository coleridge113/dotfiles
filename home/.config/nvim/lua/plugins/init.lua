return {
    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.config")

            configs.setup({
                ensure_installed = {
                    "lua", "vim", "vimdoc", "query",
                    "kotlin", "bash", "json", "yaml",
                    "markdown", "markdown_inline", "javascript"
                },
                highlight = { 
                    enable = true, 
                    additional_vim_regex_highlighting = false 
                },
                indent = { enable = true },
            })
        end,
    },
    -- Git
    {
        "lewis6991/gitsigns.nvim", config = function()
            vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { italic = true, link = "Comment" })
            require("gitsigns").setup({
                current_line_blame = true, -- inline blame for the current line
                current_line_blame_opts = {
                    delay = 500,
                    virt_text = true,
                    virt_text_pos = "eol", -- eol | overlay | right_align
                    ignore_whitespace = false,
                },
                current_line_blame_formatter = "    <author>, <author_time:%Y-%m-%d> - <summary>",
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
                pickers = {
                    find_files = {
                        hidden = true,
                        no_ignore = false,
                    },
                },
            })
            local map = vim.keymap.set
            map("n", "<leader>sf", "<cmd>Telescope find_files<cr>", { desc = "Telescope: find files" })
            map("n", "<leader>sg", "<cmd>Telescope live_grep<cr>", { desc = "Telescope: live grep" })
            map("n", "<leader>sb", "<cmd>Telescope buffers<cr>", { desc = "Telescope: buffers" })
            map("n", "<leader>sh", "<cmd>Telescope help_tags<cr>", { desc = "Telescope: help tags" })
        end,
    },
    -- LSP Config
    {
        "neovim/nvim-lspconfig",
        dependencies = {
            { "williamboman/mason.nvim", build = ":MasonUpdate" },
            "williamboman/mason-lspconfig.nvim",
            "hrsh7th/cmp-nvim-lsp", -- Required for capabilities
        },
        config = function()
            -- Initialize Mason tools
            require("mason").setup()

            local lspconfig = require("lspconfig")
            local capabilities = require("cmp_nvim_lsp").default_capabilities()

            local on_attach = function(client, bufnr)
                -- You can add common LSP keybindings/autocmds here if needed
                -- For example:
                -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')
                -- vim.api.nvim_buf_set_keymap(bufnr, 'n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', { noremap=true, silent=true })
                -- etc.
            end

            require("mason-lspconfig").setup({
                ensure_installed = { "lua_ls", "jdtls", "kotlin_language_server", "ts_ls" },
                handlers = {
                    -- Default handler for all servers not explicitly listed below
                    function(server_name)
                        lspconfig[server_name].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                        })
                    end,

                    -- Specific handler for Kotlin Language Server
                    ['kotlin_language_server'] = function()
                        lspconfig['kotlin_language_server'].setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            root_dir = lspconfig.util.root_pattern("settings.gradle", "settings.gradle.kts", ".git"),
                            -- settings = {
                            --     kotlin = {
                            --         java = { home = "/usr/lib/jvm/java-21-openjdk-amd64" },
                            --         compiler = { jvm = { target = "21" } }
                            --     },
                            -- },
                            flags = { debounce_text_changes = 150 }
                        })
                    end,

                    -- Recommended handler for jdtls
                    ['jdtls'] = function()
                        -- Create a project-specific workspace directory
                        local project_name = vim.fn.fnamemodify(vim.fn.getcwd(), ':p:h:t')
                        local workspace_dir = vim.fn.stdpath('data') .. '/jdtls-workspace/' .. project_name
                        
                        -- Use glob to find the jdtls jar and config paths installed by Mason
                        local jdtls_jar = vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/plugins/org.eclipse.equinox.launcher_*.jar')
                        local jdtls_config = vim.fn.glob(vim.fn.stdpath('data') .. '/mason/packages/jdtls/config_*')

                        lspconfig.jdtls.setup({
                            capabilities = capabilities,
                            on_attach = on_attach,
                            cmd = {
                                'java',
                                '-Declipse.application=org.eclipse.jdt.ls.core.id1.XmlServerApplication',
                                '-Dosgi.bundles.defaultStartLevel=4',
                                '-Declipse.product=org.eclipse.jdt.ls.core.product',
                                '-Dlog.protocol=true',
                                '-Dlog.level=ALL',
                                '-Xms1g',
                                '--add-modules=ALL-SYSTEM',
                                '--add-opens', 'java.base/java.lang=ALL-UNNAMED',
                                '--add-opens', 'java.base/java.io=ALL-UNNAMED',
                                '-jar', jdtls_jar,
                                '-configuration', jdtls_config,
                                '-data', workspace_dir
                            },
                            root_dir = require('lspconfig').util.root_pattern('.git', 'mvnw', 'gradlew', 'pom.xml'),
                        })
                    end,
                }
            })
        end,
    },

    -- Auto complete
    {
        "hrsh7th/nvim-cmp",
        dependencies = {
            "hrsh7th/cmp-nvim-lsp",
            "L3MON4D3/LuaSnip",
            "saadparwaiz1/cmp_luasnip",
        },
        config = function()
            local cmp = require("cmp")
            local luasnip = require("luasnip")

            cmp.setup({
                snippet = {
                    expand = function(args)
                        luasnip.lsp_expand(args.body)
                    end,
                },
                mapping = cmp.mapping.preset.insert({
                    ["<Tab>"] = cmp.mapping.select_next_item(),
                    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
                    ["<CR>"] = cmp.mapping.confirm({ select = true }),
                }),
                sources = cmp.config.sources({
                    { name = "supermaven" },
                    { name = "nvim_lsp" },
                    { name = "luasnip" },
                }),
            })
        end,
    },
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
            vim.api.nvim_set_hl(0, "NeoTreeNormal", { link = "Normal" })
            vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { link = "NormalNC" })
            vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { link = "Normal" })

            require("neo-tree").setup({
                close_if_last_window = true,
                enable_git_status = true,
                enable_diagnostics = true,
                filesystem = {
                    filtered_items = {
                        visible = true,        -- show filtered items, but with different style
                        hide_dotfiles = false, -- do NOT hide dotfiles
                        hide_gitignored = false,
                        hide_hidden = true,   -- important on Linux
                        hide_by_name = {},
                        hide_by_pattern = {},
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
        cmd = { "SupermavenUseFree" },
        config = function()
            require("supermaven-nvim").setup({
                disable_keymaps = true,
            })
        end,
    },
    -- MiniMap
    {
        'nvim-mini/mini.nvim',
        version = false,
        config = function()
            require('mini.map').setup()
            -- toggle manually with <leader>m
            vim.keymap.set('n', '<leader>m', function()
                require('mini.map').toggle()
            end, { desc = 'MiniMap: toggle' })

            -- remove the BufWinEnter autocmd so it doesn't auto-open
            -- if you want to ensure it's closed on startup:
            vim.api.nvim_create_autocmd('VimEnter', {
                callback = function() require('mini.map').close() end
            })
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
    },
    {
        "terrortylor/nvim-comment",
        config = function()
            require("nvim_comment").setup()
        end,
    },
    -- Fugitive
    {
        "tpope/vim-fugitive"
    },
    -- Colorizer
    {
        "catgoose/nvim-colorizer.lua",
        event = "BufReadPre",
        config = function()
            require("colorizer").setup({
                css = true, -- enable all CSS features
                mode = "background", -- set mode to background
            })
        end,
    },
    -- Autosave
    {
        "okuuva/auto-save.nvim",
        config = function()
            require("auto-save").setup({
                enabled = true,
                events = { "InsertLeave", "TextChanged" },
                conditions = {
                    exists = true,
                    modifiable = true
                }
            })
        end,
    },
    -- Indent
    {
        'https://github.com/nvimdev/indentmini.nvim',
        event = { 'BufReadPre', 'BufNewFile' },
        config = function()
            require('indentmini').setup({
                char = '▏',
                exclude = { 'markdown', 'help', 'text', 'rst' },
                minlevel = 2,
            })
        vim.cmd.highlight('IndentLine guifg=#404040')  -- Add this line here
        end,
    },
    -- Markdown Render
    {
        'MeanderingProgrammer/render-markdown.nvim',
        -- dependencies = { 'nvim-treesitter/nvim-treesitter' },
        ---@module 'render-markdown'
        ---@type render.md.UserConfig
        config = function()
            require('render-markdown').setup({
                completions = { lsp = { enabled = true } },
                render_modes = true,
                code = {
                    enabled = true,
                    render_modes = false,
                    sign = false,
                    conceal_delimiters = true,
                    language = true,
                    position = 'left',
                    language_icon = true,
                    language_name = true,
                    language_info = true,
                    language_pad = 0,
                    disable_background = { 'diff' },
                    width = 'full',
                    left_margin = 0,
                    left_pad = 0,
                    right_pad = 0,
                    min_width = 0,
                    border = 'hide',
                    language_border = '█',
                    language_left = '',
                    language_right = '',
                    above = '▄',
                    below = '▀',
                    inline = true,
                    inline_left = '',
                    inline_right = '',
                    inline_pad = 0,
                    priority = 140,
                    highlight = 'RenderMarkdownCode',
                    highlight_info = 'RenderMarkdownCodeInfo',
                    highlight_language = nil,
                    highlight_border = 'RenderMarkdownCodeBorder',
                    highlight_fallback = 'RenderMarkdownCodeFallback',
                    highlight_inline = 'RenderMarkdownCodeInline',
                    style = 'full',
                },
                sign = {
                    enabled = false,
                    highlight = 'RenderMarkdownSign',
                },
                link = {
                    enabled = true,
                    conceal = true,
                    render_modes = false,
                    footnote = {
                        enabled = true,
                        icon = '󰯔 ',
                        superscript = true,
                        prefix = '',
                        suffix = '',
                    },
                    image = '󰥶 ',
                    email = '󰀓 ',
                    hyperlink = '󰌹 ',
                    highlight = 'RenderMarkdownLink',
                    highlight_title = 'RenderMarkdownLinkTitle',
                    wiki = {
                        icon = '󱗖 ',
                        body = function()
                            return nil
                        end,
                        highlight = 'RenderMarkdownWikiLink',
                        scope_highlight = nil,
                    },
                    custom = {
                        web = { pattern = '^http', icon = '󰖟 ' },
                        apple = { pattern = 'apple%.com', icon = ' ' },
                        discord = { pattern = 'discord%.com', icon = '󰙯 ' },
                        github = { pattern = 'github%.com', icon = '󰊤 ' },
                        gitlab = { pattern = 'gitlab%.com', icon = '󰮠 ' },
                        google = { pattern = 'google%.com', icon = '󰊭 ' },
                        hackernews = { pattern = 'ycombinator%.com', icon = ' ' },
                        linkedin = { pattern = 'linkedin%.com', icon = '󰌻 ' },
                        microsoft = { pattern = 'microsoft%.com', icon = ' ' },
                        neovim = { pattern = 'neovim%.io', icon = ' ' },
                        reddit = { pattern = 'reddit%.com', icon = '󰑍 ' },
                        slack = { pattern = 'slack%.com', icon = '󰒱 ' },
                        stackoverflow = { pattern = 'stackoverflow%.com', icon = '󰓌 ' },
                        steam = { pattern = 'steampowered%.com', icon = ' ' },
                        twitter = { pattern = 'x%.com', icon = ' ' },
                        wikipedia = { pattern = 'wikipedia%.org', icon = '󰖬 ' },
                        youtube = { pattern = 'youtube[^.]*%.com', icon = '󰗃 ' },
                        youtube_short = { pattern = 'youtu%.be', icon = '󰗃 ' },
                    },
                },
            })
        end,
    },
}

local gc = {
    yellow = "#fabd2f",
    aqua   = "#8ec07c",
    blue   = "#83a598",
    orange = "#fe8019",
    purple = "#d3869b",
    red    = "#fb4934",
    green  = "#b8bb26",
    fg     = "#ebdbb2",
    bg     = "#282828", -- Using the dark "hard" color for the cursor
}

-- Syntax Highlighting Definitions
local functions = {
    ["@function"] = { fg = gc.green },
    ["@function.call"] = { fg = gc.green },
    ["@function.builtin"] = { fg = gc.green },
    Function = { fg = gc.green },
}

local keywords = {
    ["@keyword"] = { fg = gc.purple },
    Keyword = { fg = gc.purple },
}

local objects = {
    ["@type"] = { fg = gc.blue },
    ["@type.builtin"] = { fg = gc.blue },
    Type = { fg = gc.blue },
    ["@namespace"] = { fg = gc.blue },
}

-- Force the cursor and selection to be dark for Light Mode
local interface_overrides = {
    -- This sets the cursor to be the dark background color
    Cursor = { fg = "#fbf1c7", bg = gc.bg, reverse = false },
    TermCursor = { fg = "#fbf1c7", bg = gc.bg, reverse = false },
    lCursor = { fg = "#fbf1c7", bg = gc.bg, reverse = false },
    -- Matches the dark selection seen in the Gruvbox Light screenshots
    Visual = { bg = gc.bg, fg = gc.fg }, 
    Search = { bg = gc.yellow, fg = gc.bg, bold = true },
}

local overrides = vim.tbl_extend("force", functions, keywords, objects, interface_overrides)

local gruvbox_config = {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    opts = {
        terminal_colors = true,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
            strings = false,
            emphasis = false,
            comments = false,
            operators = false,
            folds = false,
        },
        strikethrough = true,
        invert_selection = false,
        invert_signs = false,
        invert_tabline = false,
        inverse = true,
        contrast = "soft", -- The creamy background
        palette_overrides = {},
        dim_inactive = false,
        transparent_mode = false,
        overrides = overrides,
    },
    config = function(_, opts)
        -- 1. Set background mode first
        vim.o.background = "light"
        
        -- 2. Force Neovim to take control of the cursor from Ghostty
        -- This tells nvim to use our "Cursor" highlight group for everything
        vim.opt.guicursor = "n-v-c-sm:block-Cursor,i-ci-ve:ver25-Cursor,r-cr-o:hor20-Cursor,a:blinkwait700-blinkoff400-blinkon250-Cursor"
        
        -- 3. Load Gruvbox
        require("gruvbox").setup(opts)
        vim.cmd("colorscheme gruvbox")
        
        -- 4. Re-apply highlight to ensure nothing overrides it
        vim.api.nvim_set_hl(0, "Cursor", { fg = "#fbf1c7", bg = gc.bg })
    end,
}

-- Your Theme Switcher Logic
local active = "gruvbox-light"
local themes = {
    ["gruvbox-light"] = gruvbox_config,
    -- ["rose-pine"] = require("colors.themes.rose-pine"),
    -- ["tokyonight"] = require("colors.themes.tokyonight"),
}

return {
    themes[active],
}

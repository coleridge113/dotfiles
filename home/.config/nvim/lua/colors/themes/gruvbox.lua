local gc = {
    yellow = "#fabd2f",
    aqua   = "#8ec07c",
    blue   = "#83a598",
    orange = "#fe8019",
    purple = "#d3869b",
    red    = "#fb4934",
    green  = "#b8bb26",
    fg     = "#ebdbb2",
    bg     = "#282828",
}

local c = gc.green
local functions = {
    ["@function"] = { fg = c },
    ["@function.call"] = { fg = c },
    ["@function.builtin"] = { fg = c },
    Function = { fg = c },
}

local c = gc.purple
local keywords = {
    ["@keyword"] = { fg = c },
    Keyword = { fg = c },
}


local c = gc.blue
local objects = {
    ["@type"] = { fg = c },
    ["@type.builtin"] = { fg = c },
    Type = { fg = c },
    ["@namespace"] = { fg = c },
}

local placeholder = {}
local overrides = vim.tbl_extend("force", functions, keywords, objects) 

return {
    {
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
            contrast = "",
            palette_overrides = {},
            dim_inactive = false,
            transparent_mode = false,
            overrides = overrides,
        },
        config = function(_, opts)
            require("gruvbox").setup(opts)
            vim.cmd("colorscheme gruvbox")
        end,
    },
}

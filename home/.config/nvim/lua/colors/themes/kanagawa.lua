return {
    "rebelot/kanagawa.nvim",
    name = "kanagawa",
    lazy = false,
    priority = 1000,
    opts = {
        compile = false,
        undercurl = true,
        underline = true,
        bold = true,
        italic = {
            comments   = true,
            keywords   = false,
            statements = false,
            types      = false,
            functions  = false,
            variables  = false,
        },
        strikethrough = true,
        transparent = false,
        dimInactive = false,
        terminalColors = true,
        colors = {
            palette = {},
            theme = {},
        },
        overrides = function(colors)
            return {
                GitSignsCurrentLineBlame = { fg = colors.fujiGray, italic = true },
            }
        end,
    },
    config = function(_, opts)
        -- Map bundled italic options into Kanagawa’s style tables
        opts.commentStyle   = { italic = opts.italic.comments }
        opts.keywordStyle   = { italic = opts.italic.keywords }
        opts.statementStyle = { italic = opts.italic.statements }
        opts.typeStyle      = { italic = opts.italic.types }
        opts.functionStyle  = { italic = opts.italic.functions }
        opts.variableStyle  = { italic = opts.italic.variables }

        require("kanagawa").setup(opts)
        vim.cmd("colorscheme kanagawa-dragon") -- try: kanagawa-dragon, kanagawa-lotus
    end,
}

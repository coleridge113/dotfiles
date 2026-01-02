return {
  {
    "sainnhe/sonokai",
    name = "sonokai",
    lazy = false,
    priority = 1000,
    opts = {
      style = "espresso", -- variants: default, atlantis, andromeda, shusia, maia, espresso
      transparent_background = false,
      terminal_colors = true,
      italic = {
        comments   = true,
        keywords   = false,
        statements = false,
        types      = false,
        functions  = false,
        variables  = false,
      },
      overrides = function(colors)
        return {
          -- Remove unwanted italics from Treesitter groups
          ["@type"]       = { fg = colors.fg, italic = false },
          ["@namespace"]  = { fg = colors.fg, italic = false },
          ["@field"]      = { fg = colors.fg, italic = false },
          ["@variable"]   = { fg = colors.fg, italic = false },
          ["@property"]   = { fg = colors.fg, italic = false },
          -- Optional: tweak inline blame color from gitsigns
          GitSignsCurrentLineBlame = { fg = colors.fg, italic = true },
        }
      end,
    },
    config = function(_, opts)
      -- Map bundled italic options into Sonokai globals
      vim.g.sonokai_style = opts.style
      vim.g.sonokai_transparent_background = opts.transparent_background and 1 or 0
      vim.g.sonokai_enable_italic = 1
      vim.g.sonokai_disable_italic_comment   = opts.italic.comments   and 0 or 1
      vim.g.sonokai_disable_italic_keyword   = opts.italic.keywords   and 0 or 1
      vim.g.sonokai_disable_italic_statement = opts.italic.statements and 0 or 1
      vim.g.sonokai_disable_italic_type      = opts.italic.types      and 0 or 1
      vim.g.sonokai_disable_italic_function  = opts.italic.functions  and 0 or 1
      vim.g.sonokai_disable_italic_variable  = opts.italic.variables  and 0 or 1

      -- Apply the colorscheme
      vim.cmd("colorscheme sonokai")
    end,
  },
}

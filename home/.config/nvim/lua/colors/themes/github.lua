return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = false,
        terminal_colors = true,
        dim_inactive = false,
        styles = {
          comments   = "italic",
          keywords   = "bold",
          functions  = "NONE",
          variables  = "NONE",
          types      = "NONE",
        },
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)
      vim.cmd("colorscheme github_dark")  -- try: github_dimmed, github_light, github_dark_default, github_dark_tritanopia, etc.
      -- Optional: tweak inline blame color from gitsigns
      vim.api.nvim_set_hl(0, "GitSignsCurrentLineBlame", { fg = "#6e7681", italic = true })
    end,
  },
}

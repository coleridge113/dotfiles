return {
  {
    "shaunsingh/nord.nvim",
    lazy = false, -- Load during startup because it's a colorscheme
    priority = 1000, -- Load this before all other plugins
    config = function()
      -- Example customization (optional)
      vim.g.nord_contrast = true
      vim.g.nord_borders = false
      vim.g.nord_disable_background = false
      vim.g.nord_italic = true

      -- Load the colorscheme
      require('nord').set()
    end,
  },
}

return {
    "sainnhe/gruvbox-material",
    lazy = false,
    priority = 1000,
    config = function()
        vim.g.gruvbox_material_enable_italic = true

        -- load theme
        vim.cmd.colorscheme("gruvbox-material")

        -- override highlights AFTER colorscheme loads
        vim.api.nvim_set_hl(0, "Visual", {
            bg = "#cab692",
            fg = "#282828",
        })

        vim.api.nvim_set_hl(0, "CursorLine", {
            bg = "#32302f",
        })
    end,
}

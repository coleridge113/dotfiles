return {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    opts = {
        flavour = "mocha", -- latte, frappe, macchiato, mocha
        color_overrides = {
            mocha = {
                -- Default mocha background is #1e1e2e. 
                -- Let's drop it down to a deep, neutral ink black:
                base = "#0f0f14",   -- Main editor background
                mantle = "#0b0b0e", -- Split dividers, statusline, float backdrops
                crust = "#070709",  -- Very dark accents (e.g., box borders)
            },
        },
    },
    config = function(_, opts)
        require("catppuccin").setup(opts)
        -- No hardcoded colorscheme command here so Themery can swap into it cleanly!
    end
}

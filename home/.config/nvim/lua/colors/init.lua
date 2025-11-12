local active = "gruvbox"

local themes = {
    ["rose-pine"] = require("colors.themes.rose-pine"),
    ["tokyonight"] = require("colors.themes.tokyonight"),
    ["gruvbox"] = require("colors.themes.gruvbox"),
    ["github"] = require("colors.themes.github")
}

return {
    themes[active],
}

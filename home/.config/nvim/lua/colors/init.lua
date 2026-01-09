local active = "gruvbox-material"

local themes = {
    ["rose-pine"] = require("colors.themes.rose-pine"),
    ["tokyonight"] = require("colors.themes.tokyonight"),
    ["gruvbox"] = require("colors.themes.gruvbox"),
    ["gruvbox-material"] = require("colors.themes.gruvbox-material"),
    ["github"] = require("colors.themes.github"),
    ["kanagawa"] = require("colors.themes.kanagawa"),
    ["sonokai"] = require("colors.themes.sonokai"),
    ["nord"] = require("colors.themes.nord"),
    ["everforest"] = require("colors.themes.everforest"),
}

return {
    themes[active],
}

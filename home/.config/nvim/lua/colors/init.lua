<<<<<<< HEAD
local active = "github"
=======
local active = "gruvbox"
>>>>>>> refs/remotes/origin/master

local themes = {
    ["rose-pine"] = require("colors.themes.rose-pine"),
    ["tokyonight"] = require("colors.themes.tokyonight"),
    ["gruvbox"] = require("colors.themes.gruvbox"),
    ["github"] = require("colors.themes.github")
}

return {
    themes[active],
}

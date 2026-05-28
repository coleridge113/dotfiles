local active_theme = "tokyonight" -- Set your initial boot colorscheme here

local function load_theme(name, module_path)
    -- Safely grab the configuration table returned by your theme file
    local spec = require(module_path)
    
    -- If your theme file uses double nesting (like returning an array inside an array),
    -- we extract the core plugin block out of it safely
    if spec[1] == nil and type(spec) == "table" then
        -- This is a dictionary format spec
    elseif type(spec) == "table" and type(spec[1]) == "table" then
        spec = spec[1]
    end

    -- Intercept and hook into the config block
    local original_config = spec.config
    spec.config = function(plugin, opts)
        if original_config then original_config(plugin, opts) end
        
        -- Only set the global scheme if this matches your active boot selection
        if name == active_theme then
            local cmd_name = spec.name or name
            vim.cmd("colorscheme " .. cmd_name)
        end
    end
    
    return spec
end

-- Return a perfectly flat, normalized array of specs to Lazy
return {
    load_theme("rose-pine", "colors.themes.rose-pine"),
    load_theme("tokyonight", "colors.themes.tokyonight"),
    load_theme("gruvbox", "colors.themes.gruvbox"),
    load_theme("gruvbox-material", "colors.themes.gruvbox-material"),
    load_theme("github", "colors.themes.github"),
    load_theme("kanagawa", "colors.themes.kanagawa"),
    load_theme("sonokai", "colors.themes.sonokai"),
    load_theme("nord", "colors.themes.nord"),
    load_theme("everforest", "colors.themes.everforest"),
}

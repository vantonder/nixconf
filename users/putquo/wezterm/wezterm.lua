local wezterm = require 'wezterm'
local config = {}

local function get_appearance()
  if wezterm.gui then
    return wezterm.gui.get_appearance()
  end
  return 'Dark'
end

local function scheme_for_appearance(appearance)
  if appearance:find 'Dark' then
    local scheme = require 'colors/catppuccin-mocha'
    return { colors = scheme.colors(), window_frame = scheme.window_frame() }
  end

    local scheme = require 'colors/catppuccin-latte'
  return { colors = scheme.colors(), window_frame = scheme.window_frame() }
end

local color_scheme = scheme_for_appearance(get_appearance())
config.colors = color_scheme.colors
config.command_palette_bg_color = color_scheme.colors.selection_bg
config.command_palette_fg_color = color_scheme.colors.foreground
config.window_frame = color_scheme.window_frame

config.font_size = 13
config.font = wezterm.font 'CaskaydiaCove Nerd Font'

return config

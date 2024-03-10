local wezterm = require 'wezterm'

local color_scheme = wezterm.color.get_builtin_schemes()['Catppuccin Mocha']

local M = {}

function M.colors()
  return color_scheme
end

function M.window_frame()
  return {
    active_titlebar_fg = color_scheme.foreground,
    active_titlebar_bg = color_scheme.background,
    inactive_titlebar_fg = color_scheme.foreground,
    inactive_titlebar_bg = color_scheme.background,
    button_fg = color_scheme.foreground,
    button_bg = color_scheme.background,
  }
end

return M

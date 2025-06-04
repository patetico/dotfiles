local wezterm = require 'wezterm'

local c = wezterm.config_builder()

local keybindings = require 'extra.keybindings'
keybindings.apply(c)

c.color_scheme = "Gooey (Gogh)" -- testar até 20/jun/24
-- c.color_scheme = "Solarized Dark (Gogh)" -- próximo teste

-- make sure to use a font you have installed
c.font = wezterm.font 'SauceCodePro Nerd Font Mono'
-- c.font = wezterm.font 'Source Code Pro'
c.font_size = 10
c.freetype_load_target = "HorizontalLcd"

-- scroll bar
c.enable_scroll_bar = true

-- Remove decorations but allow window resize
c.window_decorations = 'INTEGRATED_BUTTONS|RESIZE'
-- c.integrated_title_button_style = 'Gnome'

-- $TERM (tirar o padrão tá quebrando ssh)
-- c.term = 'wezterm'

c.cursor_blink_rate = 600
c.cursor_blink_ease_in = "Constant"
c.cursor_blink_ease_out = "Constant"
c.default_cursor_style = "BlinkingBlock"

wezterm.on(
  'new-tab-button-click',
  function(window, pane, button, default_action)
    -- just log the default action and allow wezterm to perform it
    wezterm.log_info('new-tab', window, pane, button, default_action)
  end
)

if true then
  return c
else
  return require 'gdanko.wezterm'
end

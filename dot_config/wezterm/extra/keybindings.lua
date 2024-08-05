local wezterm = require 'wezterm'
local themeSelectorAction = require 'extra.themeSelectorAction'

local act = wezterm.action

--- @alias SimpleKeyBind [string, string, unknown]
--- @alias KeyBind { key: string, mods: string, action: unknown }

---@generic T, U
---@param t T[]
---@param fn fun(v: T): U
---@return U[]
local function tableMap(t, fn)
  local res = {}
  for k, v in pairs(t) do
    res[k] = fn(v)
  end

  return res
end

--- @param simpleBind SimpleKeyBind[]
--- @return KeyBind
local function convertKeyBind(simpleBind)
  local mods, key, action = table.unpack(simpleBind)
  return { mods = mods, key = key, action = action }
end

local ThemePickerAction = wezterm.action_callback(function(window, pane)
  local picker = require 'theme_picker'
  picker.theme_switcher(window, pane)
end)

local _keys = {
  { 'CTRL',           'PageUp',     act.ActivateTabRelative(-1), },
  { 'CTRL|SHIFT',     'Tab',        act.ActivateTabRelative(-1), },
  { 'CTRL',           'PageDown',   act.ActivateTabRelative(1), },
  { 'CTRL',           'Tab',        act.ActivateTabRelative(1), },
  { 'CTRL|SHIFT',     'PageUp',     act.MoveTabRelative(-1), },
  { 'CTRL|SHIFT',     'PageDown',   act.MoveTabRelative(1), },

  { 'CTRL',           '1',          act.ActivateTab(0), },
  { 'CTRL',           '2',          act.ActivateTab(1), },
  { 'CTRL',           '3',          act.ActivateTab(2), },
  { 'CTRL',           '4',          act.ActivateTab(3), },
  { 'CTRL',           '5',          act.ActivateTab(4), },
  { 'CTRL',           '6',          act.ActivateTab(5), },
  { 'CTRL',           '7',          act.ActivateTab(6), },
  { 'CTRL',           '8',          act.ActivateTab(7), },
  { 'CTRL',           '9',          act.ActivateTab(8), },
  { 'CTRL',           '0',          act.ActivateTab(-1), },

  { 'CTRL|SHIFT',     'W',          act.CloseCurrentTab { confirm = true }, },

  { 'CTRL|ALT|SHIFT', '"',          act.SplitVertical { domain = 'CurrentPaneDomain' }, },
  { 'CTRL|ALT|SHIFT', '%',          act.SplitHorizontal { domain = 'CurrentPaneDomain' }, },

  { 'CTRL|SHIFT',     '+',          act.IncreaseFontSize, },
  { 'CTRL|SHIFT',     '_',          act.DecreaseFontSize, },
  { 'CTRL|SHIFT',     ')',          act.ResetFontSize, },

  { 'CTRL',           'Insert',     act.CopyTo 'PrimarySelection', },
  { 'CTRL|SHIFT',     'C',          act.CopyTo 'Clipboard', },
  { 'NONE',           'Copy',       act.CopyTo 'Clipboard', },
  { 'NONE',           'Paste',      act.PasteFrom 'Clipboard', },
  { 'CTRL|SHIFT',     'V',          act.PasteFrom 'Clipboard', },
  { 'SHIFT',          'Insert',     act.PasteFrom 'PrimarySelection', },

  { 'ALT',            'p',          themeSelectorAction },

  { 'ALT',            'Enter',      act.ToggleFullScreen, },
  { 'CTRL|SHIFT',     'F',          act.Search 'CurrentSelectionOrEmptyString', },
  { 'CTRL|SHIFT',     'K',          act.ClearScrollback 'ScrollbackOnly', },
  { 'CTRL|SHIFT',     'L',          act.ShowDebugOverlay, },
  { 'CTRL|SHIFT',     'M',          act.Hide, },
  { 'CTRL|SHIFT',     'N',          act.SpawnWindow, },
  { 'CTRL|SHIFT',     'P',          act.ActivateCommandPalette, },
  { 'CTRL|SHIFT',     'R',          act.ReloadConfiguration, },
  { 'CTRL|SHIFT',     'T',          act.SpawnTab 'CurrentPaneDomain', },
  { 'CTRL|ALT',       't',          act.ShowLauncher, },
  { 'CTRL|SHIFT',     'U',          act.CharSelect { copy_on_select = true, copy_to = 'ClipboardAndPrimarySelection' }, },
  { 'CTRL|SHIFT',     'X',          act.ActivateCopyMode, },
  { 'CTRL|SHIFT',     'Z',          act.TogglePaneZoomState, },
  { 'CTRL|SHIFT',     'phys:Space', act.QuickSelect, },

  { 'SHIFT',          'PageUp',     act.ScrollByPage(-1), },
  { 'SHIFT',          'PageDown',   act.ScrollByPage(1), },
  { 'SHIFT',          'UpArrow',     act.ScrollByLine(-1), },
  { 'SHIFT',          'DownArrow',   act.ScrollByLine(1), },

  { 'CTRL|SHIFT',     'LeftArrow',  act.ActivatePaneDirection 'Left', },
  { 'CTRL|SHIFT',     'RightArrow', act.ActivatePaneDirection 'Right', },
  { 'CTRL|SHIFT',     'UpArrow',    act.ActivatePaneDirection 'Up', },
  { 'CTRL|SHIFT',     'DownArrow',  act.ActivatePaneDirection 'Down', },

  { 'CTRL|ALT|SHIFT', 'LeftArrow',  act.AdjustPaneSize { 'Left', 1 }, },
  { 'CTRL|ALT|SHIFT', 'RightArrow', act.AdjustPaneSize { 'Right', 1 }, },
  { 'CTRL|ALT|SHIFT', 'UpArrow',    act.AdjustPaneSize { 'Up', 1 }, },
  { 'CTRL|ALT|SHIFT', 'DownArrow',  act.AdjustPaneSize { 'Down', 1 }, },
}

local _keyTables = {}

_keyTables.copy_mode = {
  { 'NONE',  'Tab',        act.CopyMode 'MoveForwardWord' },
  { 'SHIFT', 'Tab',        act.CopyMode 'MoveBackwardWord' },
  { 'NONE',  'Enter',      act.CopyMode 'MoveToStartOfNextLine' },
  { 'NONE',  'Escape',     act.CopyMode 'Close' },
  { 'NONE',  'Space',      act.CopyMode { SetSelectionMode = 'Cell' } },
  { 'NONE',  '$',          act.CopyMode 'MoveToEndOfLineContent' },
  { 'SHIFT', '$',          act.CopyMode 'MoveToEndOfLineContent' },
  { 'NONE',  ',',          act.CopyMode 'JumpReverse' },
  { 'NONE',  '0',          act.CopyMode 'MoveToStartOfLine' },
  { 'NONE',  ';',          act.CopyMode 'JumpAgain' },
  { 'NONE',  'F',          act.CopyMode { JumpBackward = { prev_char = false } } },
  { 'SHIFT', 'F',          act.CopyMode { JumpBackward = { prev_char = false } } },
  { 'NONE',  'G',          act.CopyMode 'MoveToScrollbackBottom' },
  { 'SHIFT', 'G',          act.CopyMode 'MoveToScrollbackBottom' },
  { 'NONE',  'H',          act.CopyMode 'MoveToViewportTop' },
  { 'SHIFT', 'H',          act.CopyMode 'MoveToViewportTop' },
  { 'NONE',  'L',          act.CopyMode 'MoveToViewportBottom' },
  { 'SHIFT', 'L',          act.CopyMode 'MoveToViewportBottom' },
  { 'NONE',  'M',          act.CopyMode 'MoveToViewportMiddle' },
  { 'SHIFT', 'M',          act.CopyMode 'MoveToViewportMiddle' },
  { 'NONE',  'O',          act.CopyMode 'MoveToSelectionOtherEndHoriz' },
  { 'SHIFT', 'O',          act.CopyMode 'MoveToSelectionOtherEndHoriz' },
  { 'NONE',  'T',          act.CopyMode { JumpBackward = { prev_char = true } } },
  { 'SHIFT', 'T',          act.CopyMode { JumpBackward = { prev_char = true } } },
  { 'NONE',  'V',          act.CopyMode { SetSelectionMode = 'Line' } },
  { 'SHIFT', 'V',          act.CopyMode { SetSelectionMode = 'Line' } },
  { 'NONE',  '^',          act.CopyMode 'MoveToStartOfLineContent' },
  { 'SHIFT', '^',          act.CopyMode 'MoveToStartOfLineContent' },
  { 'NONE',  'b',          act.CopyMode 'MoveBackwardWord' },
  { 'ALT',   'b',          act.CopyMode 'MoveBackwardWord' },
  { 'CTRL',  'b',          act.CopyMode 'PageUp' },
  { 'CTRL',  'c',          act.CopyMode 'Close' },
  { 'CTRL',  'd',          act.CopyMode { MoveByPage = (0.5) } },
  { 'NONE',  'e',          act.CopyMode 'MoveForwardWordEnd' },
  { 'NONE',  'f',          act.CopyMode { JumpForward = { prev_char = false } } },
  { 'ALT',   'f',          act.CopyMode 'MoveForwardWord' },
  { 'CTRL',  'f',          act.CopyMode 'PageDown' },
  { 'NONE',  'g',          act.CopyMode 'MoveToScrollbackTop' },
  { 'CTRL',  'g',          act.CopyMode 'Close' },
  { 'NONE',  'h',          act.CopyMode 'MoveLeft' },
  { 'NONE',  'j',          act.CopyMode 'MoveDown' },
  { 'NONE',  'k',          act.CopyMode 'MoveUp' },
  { 'NONE',  'l',          act.CopyMode 'MoveRight' },
  { 'ALT',   'm',          act.CopyMode 'MoveToStartOfLineContent' },
  { 'NONE',  'o',          act.CopyMode 'MoveToSelectionOtherEnd' },
  { 'NONE',  'q',          act.CopyMode 'Close' },
  { 'NONE',  't',          act.CopyMode { JumpForward = { prev_char = true } } },
  { 'CTRL',  'u',          act.CopyMode { MoveByPage = (-0.5) } },
  { 'NONE',  'v',          act.CopyMode { SetSelectionMode = 'Cell' } },
  { 'CTRL',  'v',          act.CopyMode { SetSelectionMode = 'Block' } },
  { 'NONE',  'w',          act.CopyMode 'MoveForwardWord' },
  { 'NONE',  'y',          act.Multiple { { CopyTo = 'ClipboardAndPrimarySelection' }, { CopyMode = 'Close' } } },
  { 'NONE',  'PageUp',     act.CopyMode 'PageUp' },
  { 'NONE',  'PageDown',   act.CopyMode 'PageDown' },
  { 'NONE',  'End',        act.CopyMode 'MoveToEndOfLineContent' },
  { 'NONE',  'Home',       act.CopyMode 'MoveToStartOfLine' },
  { 'NONE',  'LeftArrow',  act.CopyMode 'MoveLeft' },
  { 'ALT',   'LeftArrow',  act.CopyMode 'MoveBackwardWord' },
  { 'NONE',  'RightArrow', act.CopyMode 'MoveRight' },
  { 'ALT',   'RightArrow', act.CopyMode 'MoveForwardWord' },
  { 'NONE',  'UpArrow',    act.CopyMode 'MoveUp' },
  { 'NONE',  'DownArrow',  act.CopyMode 'MoveDown' },
}

_keyTables.search_mode = {
  { 'NONE', 'Enter',     act.CopyMode 'PriorMatch' },
  { 'NONE', 'Escape',    act.CopyMode 'Close' },
  { 'CTRL', 'n',         act.CopyMode 'NextMatch' },
  { 'CTRL', 'p',         act.CopyMode 'PriorMatch' },
  { 'CTRL', 'r',         act.CopyMode 'CycleMatchType' },
  { 'CTRL', 'u',         act.CopyMode 'ClearPattern' },
  { 'NONE', 'PageUp',    act.CopyMode 'PriorMatchPage' },
  { 'NONE', 'PageDown',  act.CopyMode 'NextMatchPage' },
  { 'NONE', 'UpArrow',   act.CopyMode 'PriorMatch' },
  { 'NONE', 'DownArrow', act.CopyMode 'NextMatch' },
}

local keys = tableMap(_keys, convertKeyBind)
local key_tables = tableMap(_keyTables, function(tbl)
  return tableMap(tbl, convertKeyBind)
end)

return {
  apply = function(config)
    config.disable_default_key_bindings = true
    config.keys = keys
    config.key_tables = key_tables
  end
}

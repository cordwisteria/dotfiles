local wezterm = require("wezterm")
local config = wezterm.config_builder()

-- ============================================================
-- Platform detection
-- ============================================================
local is_windows = wezterm.target_triple:find("windows") ~= nil

-- ============================================================
-- Font
-- ============================================================
config.font_size   = is_windows and 11.0 or 13.5
config.line_height = 1.2

-- ============================================================
-- Color scheme: Solarized Dark
-- ============================================================
config.color_scheme = "Solarized Dark (Gogh)"

-- ============================================================
-- Window
-- ============================================================
config.window_padding = {
  left = 8,
  right = 8,
  top = 8,
  bottom = 8,
}
config.window_decorations = "RESIZE"
config.initial_cols = 220
config.initial_rows = 50
config.window_background_opacity = 1.0

-- タブバー
config.use_fancy_tab_bar = false
config.tab_bar_at_bottom = true
config.hide_tab_bar_if_only_one_tab = true
config.tab_max_width = 32

-- ============================================================
-- Shell: WSL on Windows, zsh on Mac/Linux
-- ============================================================
if is_windows then
  config.default_prog = { "wsl.exe", "--cd", "~" }
  config.wsl_domains = {
    {
      name = "WSL:Ubuntu",
      distribution = "Ubuntu",
      default_cwd = "~",
    },
  }
  config.default_domain = "WSL:Ubuntu"
else
  config.default_prog = { "/bin/zsh", "-l" }
end

-- ============================================================
-- Key bindings
-- ============================================================
config.keys = {
  -- タブ操作
  { key = "t", mods = "SUPER",       action = wezterm.action.SpawnTab("CurrentPaneDomain") },
  { key = "w", mods = "SUPER",       action = wezterm.action.CloseCurrentTab({ confirm = false }) },
  { key = "1", mods = "SUPER",       action = wezterm.action.ActivateTab(0) },
  { key = "2", mods = "SUPER",       action = wezterm.action.ActivateTab(1) },
  { key = "3", mods = "SUPER",       action = wezterm.action.ActivateTab(2) },
  { key = "4", mods = "SUPER",       action = wezterm.action.ActivateTab(3) },
  { key = "5", mods = "SUPER",       action = wezterm.action.ActivateTab(4) },

  -- ペイン分割
  { key = "d", mods = "SUPER",       action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  { key = "d", mods = "SUPER|SHIFT", action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }) },

  -- ペイン移動
  { key = "h", mods = "SUPER",       action = wezterm.action.ActivatePaneDirection("Left") },
  { key = "l", mods = "SUPER",       action = wezterm.action.ActivatePaneDirection("Right") },
  { key = "k", mods = "SUPER",       action = wezterm.action.ActivatePaneDirection("Up") },
  { key = "j", mods = "SUPER",       action = wezterm.action.ActivatePaneDirection("Down") },

  -- コピーモード
  { key = "f", mods = "SUPER",       action = wezterm.action.Search({ CaseSensitiveString = "" }) },

  -- フォントサイズ
  { key = "=", mods = "SUPER",       action = wezterm.action.IncreaseFontSize },
  { key = "-", mods = "SUPER",       action = wezterm.action.DecreaseFontSize },
  { key = "0", mods = "SUPER",       action = wezterm.action.ResetFontSize },
}

-- Windows では CTRL+SHIFT をSUPERの代わりに使う
if is_windows then
  local win_keys = {}
  for _, k in ipairs(config.keys) do
    local new_k = {}
    for key, val in pairs(k) do
      new_k[key] = val
    end
    new_k.mods = k.mods:gsub("SUPER", "CTRL|SHIFT")
    table.insert(win_keys, new_k)
  end
  config.keys = win_keys
end

-- ============================================================
-- Misc
-- ============================================================
config.scrollback_lines = 10000
config.enable_scroll_bar = false
config.audible_bell = "Disabled"
config.cursor_blink_rate = 500

return config

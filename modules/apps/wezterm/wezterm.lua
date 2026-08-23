local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

-- =====================================================================
-- 1. VISUALS & NEUTRAL COMPLINE COLOR SCHEME
-- =====================================================================
config.colors = {
  foreground = "#d3d7dc",
  background = "#16181a",
  cursor_bg = "#8f99a3",
  cursor_fg = "#16181a",
  selection_bg = "#282c30",

  ansi = {
    "#16181a",
    "#8f99a3",
    "#a8b0b8",
    "#c0c7d0",
    "#8f99a3",
    "#a8b0b8",
    "#c0c7d0",
    "#d3d7dc",
  },
  brights = {
    "#282c30",
    "#8f99a3",
    "#a8b0b8",
    "#c0c7d0",
    "#8f99a3",
    "#a8b0b8",
    "#c0c7d0",
    "#ffffff",
  },
}

-- Window Transparency & Layout
config.window_background_opacity = 0.85
config.window_padding = { left = 10, right = 10, top = 10, bottom = 10 }
config.window_decorations = "NONE"
config.enable_tab_bar = false

-- Dim inactive panes for visual focus
config.inactive_pane_hsb = {
  saturation = 0.8,
  brightness = 0.6,
}

-- =====================================================================
-- 2. TYPOGRAPHY & LIGATURES (Iosevka Nerd Font)
-- =====================================================================
config.font = wezterm.font_with_fallback({
  { family = "Iosevka Nerd Font", weight = "Medium" },
  { family = "Noto Color Emoji" },
})
config.font_size = 11.0
config.line_height = 1.15

-- Enable font ligatures explicitly
config.harfbuzz_features = { "calt=1", "clig=1", "liga=1", "zero" }

-- Cursor Configuration
config.default_cursor_style = "BlinkingBar"
config.cursor_blink_rate = 600

-- =====================================================================
-- 3. PERFORMANCE & WAYLAND OPTIMIZATIONS
-- =====================================================================
config.enable_wayland = true
config.front_end = "OpenGL"
config.scrollback_lines = 10000
config.check_for_updates = false
config.audible_bell = "Disabled"

-- =====================================================================
-- 4. HYPERLINKS & QUICK-SELECT REGEX
-- =====================================================================
config.hyperlink_rules = wezterm.default_hyperlink_rules()

-- Highlight Git commit hashes as searchable links
table.insert(config.hyperlink_rules, {
  regex = [[\b[0-9a-f]{7,40}\b]],
  format = "https://github.com/search?q=$0",
})

-- Highlight IPv4 addresses
table.insert(config.hyperlink_rules, {
  regex = [[\b\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3}\b]],
  format = "https://ipinfo.io/$0",
})

-- =====================================================================
-- 5. KEYBINDINGS, LEADER KEY & MODES
-- =====================================================================
-- Leader key set to Ctrl + A (Tmux style)
config.leader = { key = "a", mods = "CTRL", timeout_milliseconds = 1000 }

config.keys = {
  -- --- Pane Splits ---
  -- Split horizontally (Leader + |)
  { key = "|", mods = "LEADER|SHIFT", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
  -- Split vertically (Leader + -)
  { key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },
  -- Close current pane (Leader + x)
  { key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = true }) },
  -- Toggle pane zoom (Leader + z)
  { key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

  -- --- Smart Navigation (ALT + hjkl) ---
  { key = "h", mods = "ALT", action = act.ActivatePaneDirection("Left") },
  { key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },
  { key = "k", mods = "ALT", action = act.ActivatePaneDirection("Up") },
  { key = "j", mods = "ALT", action = act.ActivatePaneDirection("Down") },

  -- --- Pane Resizing (Leader + hjkl) ---
  { key = "h", mods = "LEADER", action = act.AdjustPaneSize({ "Left", 5 }) },
  { key = "l", mods = "LEADER", action = act.AdjustPaneSize({ "Right", 5 }) },
  { key = "k", mods = "LEADER", action = act.AdjustPaneSize({ "Up", 5 }) },
  { key = "j", mods = "LEADER", action = act.AdjustPaneSize({ "Down", 5 }) },

  -- --- Tab Management ---
  { key = "c", mods = "LEADER", action = act.SpawnTab("CurrentPaneDomain") },
  { key = "1", mods = "ALT", action = act.ActivateTab(0) },
  { key = "2", mods = "ALT", action = act.ActivateTab(1) },
  { key = "3", mods = "ALT", action = act.ActivateTab(2) },
  { key = "4", mods = "ALT", action = act.ActivateTab(3) },
  { key = "5", mods = "ALT", action = act.ActivateTab(4) },

  -- --- Quick-Select Mode (Leader + Space) ---
  { key = "Space", mods = "LEADER", action = act.QuickSelect },

  -- --- Vi / Copy Mode (Leader + [) ---
  { key = "[", mods = "LEADER", action = act.ActivateCopyMode },

  -- --- Workspaces & Launchers ---
  { key = "w", mods = "LEADER", action = act.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
  { key = "/", mods = "LEADER", action = act.Search({ CaseSensitiveString = "" }) },

  -- --- Font Resizing ---
  { key = "=", mods = "CTRL", action = act.IncreaseFontSize },
  { key = "-", mods = "CTRL", action = act.DecreaseFontSize },
  { key = "0", mods = "CTRL", action = act.ResetFontSize },
}

-- Prevent Wayland from intercepting Super combinations
for i = 0, 9 do
  table.insert(config.keys, {
    key = tostring(i),
    mods = "SUPER",
    action = wezterm.action.Nop,
  })
end

config.enable_csi_u_key_encoding = true
config.send_composed_key_when_right_alt_is_pressed = false

-- =====================================================================
-- 6. CUSTOM STATUS BAR
-- =====================================================================
wezterm.on("update-right-status", function(window, pane)
  local cells = {}

  if window:leader_is_active() then
    table.insert(cells, "LEADER")
  end

  local stat = window:active_workspace()
  table.insert(cells, "󰖲 " .. stat)

  for _, b in ipairs(wezterm.battery_info()) do
    table.insert(cells, string.format("󰁹 %.0f%%", b.state_of_charge * 100))
  end

  local date = wezterm.strftime("󰃰 %H:%M")
  table.insert(cells, date)

  local formatted = {}
  for i, cell in ipairs(cells) do
    table.insert(formatted, { Foreground = { Color = "#d3d7dc" } })
    table.insert(formatted, { Text = " " .. cell .. " " })
    if i < #cells then
      table.insert(formatted, { Foreground = { Color = "#282c30" } })
      table.insert(formatted, { Text = "|" })
    end
  end

  window:set_right_status(wezterm.format(formatted))
end)

return config

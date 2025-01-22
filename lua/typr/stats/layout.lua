local dashboard = require "typr.stats.dashboard"
local keystrokes = require "typr.stats.keystrokes"
local voltui = require "volt.ui"
local state = require "typr.state"
local history = require "typr.stats.history"

local components = {
  ["  Dashboard"] = dashboard,
  Keystrokes = keystrokes,
  ["  History"] = history,
}

local divider = function()
  local result = {}

  for _ = 1, state.h do
    table.insert(result, { { "  │  ", "linenr" } })
  end

  return result
end

local horiz_layout = {
  {
    name = "typrStats",
    lines = function()
      return voltui.grid_col {
        { lines = dashboard(), w = state.w_with_pad - 2, pad = 2 },
        { lines = divider(), w = 1 },
        { lines = keystrokes(), w = state.w_with_pad },
      }
    end,
  },
}

local vertical_layout = {
  {
    lines = function()
      local data = { "  Dashboard", "Keystrokes", "_pad_", "  History" }
      return voltui.tabs(data, state.w_with_pad, { active = state.tab })
    end,
    name = "tabs",
  },

  {
    lines = function()
      return { {} }
    end,
    name = "emptyline",
  },

  { lines = function() return components[state.tab]() end, name = "typrStats" },
}

return {
  vertical = vertical_layout,
  horizontal = horiz_layout,
}

local base = require("seamless.adapters.terminal.base")
local config = require("seamless.config")

---@class seamless.adapters.terminal.wezterm : seamless.adapters.terminal.base
local wezterm = {}
setmetatable(wezterm, { __index = base })
wezterm.__name = "wezterm"
local wezterm_directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

function wezterm:is_running()
    return vim.env.WEZTERM_EXECUTABLE ~= nil
end

local function execute(cmd)
    local command = string.format("wezterm cli %s", cmd)
    local handle = assert(io.popen(command), string.format("unable to M.execute: [%s]", command))
    local result = handle:read("*a")
    handle:close()
    return result
end

function wezterm:has_neighbor(direction)
    local cmd = "get-pane-direction " .. wezterm_directions[direction]
    local result = execute(cmd)
    return result ~= ""
end

function wezterm:move(direction)
    local cmd = "activate-pane-direction " .. wezterm_directions[direction]
    execute(cmd)
end

function wezterm:resize(direction, not_last_window)
    local amount = (direction == "h" or direction == "l") and config.resize.step_x or config.resize.step_y
    local cmd = string.format("adjust-pane-size --amount %s %s", amount, wezterm_directions[direction])
    execute(cmd)
end

return wezterm

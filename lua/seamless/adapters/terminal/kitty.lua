local base = require("seamless.adapters.terminal.base")
local config = require("seamless.config")

---@class seamless.adapters.terminal.kitty : seamless.adapters.terminal.base
local kitty = {}
setmetatable(kitty, { __index = base })
kitty.__name = "kitty"
local kitty_directions = { h = "left", j = "bottom", k = "top", l = "right" }

function kitty:is_running()
    return vim.env.KITTY_LISTEN_ON ~= nil
end

local function execute(cmd)
    local command = string.format("kitty @ %s", cmd)
    local handle = assert(io.popen(command), string.format("unable to M.execute: [%s]", command))
    local result = handle:read("*a")
    handle:close()
    return result
end

function kitty:has_neighbor(direction)
    local cmd = { "kitten", "@", "ls", "--match", "neighbor:" .. kitty_directions[direction] }
    local obj = vim.system(cmd, { stdin = false, stdout = false, stderr = false }):wait()
    return obj.code == 0
end

function kitty:move(direction)
    local cmd = "focus-window --no-response --match neighbor:" .. kitty_directions[direction]
    execute(cmd)
end

function kitty:resize(direction, not_last_window)
    local amount = (direction == "h" or direction == "l") and config.resize.step_x or config.resize.step_y
    local cmd = ""
    if direction == "h" then
        cmd = string.format("resize-window --axis %s --increment %s%s", "horizontal", not_last_window and "-" or "+", amount)
    elseif direction == "j" then
        cmd = string.format("resize-window --axis %s --increment %s%s", "vertical", not_last_window and "+" or "-", amount)
    elseif direction == "k" then
        cmd = string.format("resize-window --axis %s --increment %s%s", "vertical", not_last_window and "-" or "+", amount)
    elseif direction == "l" then
        cmd = string.format("resize-window --axis %s --increment %s%s", "horizontal", not_last_window and "+" or "-", amount)
    end
    execute(cmd)
end

return kitty

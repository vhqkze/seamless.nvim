local base = require("seamless.adapters.multiplexer.base")
local config = require("seamless.config")

---@class seamless.adapters.multiplexer.tmux : seamless.adapters.multiplexer.base
local tmux = {}
setmetatable(tmux, { __index = base })
tmux.__name = "tmux_adapter"

local tmux_directions = { h = "L", j = "D", k = "U", l = "R" }

local function execute(arg, pre)
    local socket = vim.split(vim.env.TMUX, ",")[1]
    local command = string.format("%s tmux -S %s %s", pre or "", socket, arg)
    local handle = assert(io.popen(command), string.format("unable to M.execute: [%s]", command))
    local result = handle:read("*a")
    handle:close()
    return result
end

function tmux:is_running()
    return vim.env.TMUX ~= nil
end

function tmux:has_neighbor(direction)
    local result = execute("display-message -p '#{pane_at_left} #{pane_at_bottom} #{pane_at_top} #{pane_at_right}'")
    local m = vim.tbl_map(tonumber, vim.split(result, " "))
    local directions = { h = 1, j = 2, k = 3, l = 4 }
    return m[directions[direction]] == 0
end

function tmux:move(direction)
    execute(string.format("select-pane -%s", tmux_directions[direction]))
end

function tmux:resize(direction)
    local step = (direction == "h" or direction == "l") and config.resize.step_x or config.resize.step_y
    execute(string.format("resize-pane -%s %s", tmux_directions[direction], step))
end

return tmux

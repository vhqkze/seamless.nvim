---@diagnostic disable: unused-local
--- @class seamless.adapters.terminal.base
local M = {}

function M:is_running()
    return false
end

---@param direction Direction
---@return boolean
function M:has_neighbor(direction)
    error("Method 'has_neighbor' not implemented by terminal adapter.")
end

---@param direction Direction
function M:move(direction)
    error("Method 'move' not implemented by terminal adapter.")
end

---@param direction Direction
function M:resize(direction)
    error("Method 'resize' not implemented by terminal adapter.")
end

return M

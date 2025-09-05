---@diagnostic disable: unused-local
---@class seamless.adapters.multiplexer.base
local M = {}

---@return boolean
function M:is_running()
    return false
end

---@param direction Direction
---@return boolean
function M:has_neighbor(direction)
    error("Method 'has_neighbor' not implemented by multiplexer adapter.")
end

---@param direction Direction
function M:move(direction)
    error("Method 'move' not implemented by multiplexer adapter.")
end

---@param direction Direction
function M:resize(direction)
    error("Method 'resize' not implemented by multiplexer adapter.")
end

return M
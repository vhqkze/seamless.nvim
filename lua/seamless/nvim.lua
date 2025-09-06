local config = require("seamless.config")
local nvim = {}

---@param direction Direction
function nvim:has_neighbor(direction)
    return vim.fn.winnr() ~= vim.fn.winnr(direction)
end

---@param direction Direction
function nvim:move(direction)
    vim.cmd.wincmd(direction)
end

---@param direction Direction
---@param not_last_window boolean
function nvim:resize(direction, not_last_window)
    if direction == "h" then
        local size = (not_last_window and "-" or "+") .. config.resize.step_x
        vim.cmd.resize({ size, mods = { vertical = true } })
    elseif direction == "j" then
        local size = (not_last_window and "+" or "-") .. config.resize.step_y
        vim.cmd.resize({ size, mods = { vertical = false } })
    elseif direction == "k" then
        local size = (not_last_window and "-" or "+") .. config.resize.step_y
        vim.cmd.resize({ size, mods = { vertical = false } })
    elseif direction == "l" then
        local size = (not_last_window and "+" or "-") .. config.resize.step_x
        vim.cmd.resize({ size, mods = { vertical = true } })
    end
end

function nvim:close_window()
    vim.api.nvim_win_close(0, false)
end

return nvim

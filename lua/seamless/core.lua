local adapters = require("seamless.adapters")
local nvim = require("seamless.nvim")
local M = {}

---@param direction Direction
local function move(direction)
    local multiplexer = adapters.get_active_multiplexer_adapter()
    local terminal = adapters.get_active_terminal_adapter()
    if nvim:has_neighbor(direction) then
        nvim:move(direction)
        return
    elseif multiplexer and multiplexer:has_neighbor(direction) then
        multiplexer:move(direction)
        return
    elseif terminal and terminal:has_neighbor(direction) then
        terminal:move(direction)
        return
    end
end

function M.move_left()
    move("h")
end

function M.move_down()
    move("j")
end

function M.move_up()
    move("k")
end

function M.move_right()
    move("l")
end

---@param direction Direction
local function resize(direction)
    local multiplexer = adapters.get_active_multiplexer_adapter()
    local terminal = adapters.get_active_terminal_adapter()
    if direction == "h" or direction == "l" then
        if nvim:has_neighbor("l") then
            nvim:resize(direction, true)
            return
        elseif multiplexer and multiplexer:has_neighbor("l") then
            multiplexer:resize(direction)
            return
        elseif terminal and terminal:has_neighbor("l") then
            terminal:resize(direction, true)
            return
        elseif nvim:has_neighbor("h") then
            nvim:resize(direction, false)
            return
        elseif multiplexer and multiplexer:has_neighbor("h") then
            multiplexer:resize(direction)
            return
        elseif terminal and terminal:has_neighbor("h") then
            terminal:resize(direction, false)
            return
        end
    elseif direction == "j" or direction == "k" then
        if nvim:has_neighbor("j") then
            nvim:resize(direction, true)
            return
        elseif multiplexer and multiplexer:has_neighbor("j") then
            multiplexer:resize(direction)
            return
        elseif terminal and terminal:has_neighbor("j") then
            terminal:resize(direction, true)
            return
        elseif nvim:has_neighbor("k") then
            nvim:resize(direction, false)
            return
        elseif multiplexer and multiplexer:has_neighbor("k") then
            multiplexer:resize(direction)
            return
        elseif terminal and terminal:has_neighbor("k") then
            terminal:resize(direction, false)
            return
        end
    end
end

function M.resize_left()
    resize("h")
end

function M.resize_down()
    resize("j")
end

function M.resize_up()
    resize("k")
end

function M.resize_right()
    resize("l")
end

function M.close_window()
    nvim:close_window()
end

function M.set_move_keymaps()
    vim.keymap.set({ "n", "t" }, "<c-h>", M.move_left, {})
    vim.keymap.set({ "n", "t" }, "<c-j>", M.move_down, {})
    vim.keymap.set({ "n", "t" }, "<c-k>", M.move_up, {})
    vim.keymap.set({ "n", "t" }, "<c-l>", M.move_right, {})
end

function M.set_resize_keymaps()
    vim.keymap.set({ "n", "t" }, "<c-m-h>", M.resize_left, {})
    vim.keymap.set({ "n", "t" }, "<c-m-j>", M.resize_down, {})
    vim.keymap.set({ "n", "t" }, "<c-m-k>", M.resize_up, {})
    vim.keymap.set({ "n", "t" }, "<c-m-l>", M.resize_right, {})
end

function M.set_close_keymaps()
    vim.keymap.set({ "n", "t" }, "<m-ŵ>", M.close_window, {})
end

return M

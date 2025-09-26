if vim ~= nil then
    return
end
local wezterm = require("wezterm")
local action = wezterm.action
local M = {}
local directions = { h = "Left", j = "Down", k = "Up", l = "Right" }

local function table_extend(primary_table, ...)
    for _, current_table in ipairs({ ... }) do
        for _, iterm in ipairs(current_table) do
            table.insert(primary_table, iterm)
        end
    end
    return primary_table
end

---@param list table
---@param item any
---@return boolean
local function table_contain(list, item)
    for _, v in ipairs(list) do
        if v == item then
            return true
        end
    end
    return false
end

---@param direction "h" | "j" | "k" | "l"
local function focus_window(direction)
    return wezterm.action_callback(function(win, pane)
        local process = pane:get_foreground_process_info()
        if process and table_contain({ "tmux", "nvim" }, process.name) then
            win:perform_action(action.SendKey({ key = direction, mods = "CTRL" }), pane)
        else
            win:perform_action(action.ActivatePaneDirection(directions[direction]), pane)
        end
    end)
end

---@param direction "h" | "j" | "k" | "l"
local function resize_window(direction)
    return wezterm.action_callback(function(win, pane)
        local process = pane:get_foreground_process_info()
        if process and table_contain({ "tmux", "nvim" }, process.name) then
            win:perform_action(action.SendKey({ key = direction, mods = "CTRL|ALT" }), pane)
        else
            local step = (direction == "h" or direction == "l") and 3 or 1
            win:perform_action(action.AdjustPaneSize({ directions[direction], step }), pane)
        end
    end)
end

local function close_window()
    return wezterm.action_callback(function(win, pane)
        local process = pane:get_foreground_process_info()
        if process and table_contain({ "tmux", "nvim" }, process.name) then
            win:perform_action(action.SendKey({ key = "ŵ", mods = "ALT" }), pane)
        else
            win:perform_action(action.CloseCurrentPane({ confirm = true }), pane)
        end
    end)
end

local key_focus = {
    { key = "h", mods = "CTRL", action = focus_window("h") },
    { key = "j", mods = "CTRL", action = focus_window("j") },
    { key = "k", mods = "CTRL", action = focus_window("k") },
    { key = "l", mods = "CTRL", action = focus_window("l") },
}

local key_resize = {
    { key = "h", mods = "CTRL|ALT", action = resize_window("h") },
    { key = "j", mods = "CTRL|ALT", action = resize_window("j") },
    { key = "k", mods = "CTRL|ALT", action = resize_window("k") },
    { key = "l", mods = "CTRL|ALT", action = resize_window("l") },
}

local key_close = {
    { key = "w", mods = "CMD", action = close_window() },
}

function M.apply_to_config(config)
    config.keys = config.keys or {}
    table_extend(config.keys, key_focus, key_resize, key_close)
end

return M

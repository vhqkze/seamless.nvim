local M = {}

local MULTIPLEXER_ADAPTERS = {
    "seamless.adapters.multiplexer.tmux",
}

local TERMINAL_ADAPTERS = {
    "seamless.adapters.terminal.kitty",
}

local loaded_multiplexer_adapters = {}
local loaded_terminal_adapters = {}

local function load_adapters(adapter_paths, cache_table)
    for _, path in ipairs(adapter_paths) do
        local ok, adapter = pcall(require, path)
        if ok and adapter then
            table.insert(cache_table, adapter)
        else
            vim.notify(string.format("Failed to load adapter '%s': %s", path, adapter), vim.log.levels.WARN)
        end
    end
end

function M.init()
    loaded_multiplexer_adapters = {}
    loaded_terminal_adapters = {}
    load_adapters(MULTIPLEXER_ADAPTERS, loaded_multiplexer_adapters)
    load_adapters(TERMINAL_ADAPTERS, loaded_terminal_adapters)
end

---@return table?
function M.get_active_multiplexer_adapter()
    for _, adapter in ipairs(loaded_multiplexer_adapters) do
        if type(adapter.is_running) == "function" and adapter:is_running() then
            return adapter
        end
    end
    return nil
end

---@return table?
function M.get_active_terminal_adapter()
    for _, adapter in ipairs(loaded_terminal_adapters) do
        if type(adapter.is_running) == "function" and adapter:is_running() then
            return adapter
        end
    end
    return nil
end

return M

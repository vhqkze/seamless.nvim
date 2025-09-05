local config = require("seamless.config")
local core = require("seamless.core")
local adapters = require("seamless.adapters")

local M = {
    move_left = core.move_left,
    move_down = core.move_down,
    move_up = core.move_up,
    move_right = core.move_right,
    resize_left = core.resize_left,
    resize_down = core.resize_down,
    resize_up = core.resize_up,
    resize_right = core.resize_right,
}

function M.setup(args)
    local merged_config = vim.tbl_deep_extend("keep", args or {}, config)
    for k, v in pairs(merged_config) do
        config[k] = v
    end
    adapters.init()
    if config.move.enable_default_keymaps then
        core.set_move_keymaps()
    end
    if config.resize.enable_default_keymaps then
        core.set_resize_keymaps()
    end
end

return M

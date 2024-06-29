---@class InputConf
---@field switch_to_en? string
---@field switch_no_en? string
---@field comment? boolean

local M = {}

---@param opts InputConf
local function setup(opts)
    require("input-switch.config").setup(opts)

    require("input-switch.core").auto_cmds()
end

M.setup = setup

return M

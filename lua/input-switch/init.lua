---@class InputConf
---@field switch_to_en? string
---@field switch_no_en? string
---
local M = {}
if os.getenv("SSH_TTY") ~= nil then
    return
end

local os_name = vim.uv.os_uname().sysname
if
    (os_name == "Linux" or os_name == "Unix")
    and os.getenv("DISPLAY") == nil
    and os.getenv("WAYLAND_DISPLAY") == nil
then
    return
end

---@param opts InputConf
local function setup(opts)
    require("input-switch.config").setup(opts)

    require("input-switch.core").auto_cmds()
end

M.setup = setup

return M

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

local function setup(_config)
    require("input.core").auto_cmds()
end

return {
    setup = setup,
}

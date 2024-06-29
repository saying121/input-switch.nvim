local api, vfn = vim.api, vim.fn

local M = {}

local config = require("input-switch.config")

vim.b.insert_toggle_flag = false
vim.b.cmd_toggle_flag = false

local input_cmd = "fcitx5-remote"

local function switch_to_en()
    vfn.system(config.to_en())
end

local function switch_not_en()
    vfn.system(config.no_en())
end

local function is_no_en()
    local input_status = tonumber(vfn.system(input_cmd))
    return input_status == 2
end

local function switch_normal_do()
    local not_en = is_no_en()

    if not_en then
        switch_to_en()

        if not vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "comment") then
            vim.b.insert_toggle_flag = true
        end
    end
end
local function switch_normal_cmd()
    local not_en = is_no_en()

    if not_en then
        switch_to_en()

        vim.b.cmd_toggle_flag = true
    end
end

local function switch_insert()
    if config.enable_comment() and vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "comment") then
        switch_not_en()
    elseif vim.b.insert_toggle_flag then
        switch_not_en()
        vim.b.insert_toggle_flag = false
    end
end
local function switch_cmd()
    if vim.b.cmd_toggle_flag then
        switch_not_en()
        vim.b.cmd_toggle_flag = false
    end
end

function M.auto_cmds()
    local fcitx = api.nvim_create_augroup("FcitxSwitch", { clear = false })

    api.nvim_create_autocmd({ "InsertEnter" }, {
        group = fcitx,
        pattern = { "*" },
        callback = switch_insert,
    })
    api.nvim_create_autocmd({ "InsertLeave" }, {
        group = fcitx,
        pattern = { "*" },
        callback = switch_normal_do,
    })

    api.nvim_create_autocmd({ "CmdlineEnter" }, {
        group = fcitx,
        pattern = { "[/\\?]" },
        callback = switch_cmd,
    })
    api.nvim_create_autocmd({ "CmdlineLeave" }, {
        group = fcitx,
        pattern = { "[/\\?]" },
        callback = switch_normal_cmd,
    })
end

return M

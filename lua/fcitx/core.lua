local api, vfn = vim.api, vim.fn

vim.b.input_toggle_flag = false

local fcitx_cmd = ""
if vfn.executable("fcitx-remote") == 1 then
    fcitx_cmd = "fcitx-remote"
elseif vfn.executable("fcitx5-remote") == 1 then
    fcitx_cmd = "fcitx5-remote"
else
    return
end

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

local function switch_to_en()
    vfn.system(fcitx_cmd .. " -c")
end

local function switch_no_latin()
    vfn.system(fcitx_cmd .. " -o")
end

local function is_no_latin()
    local input_status = tonumber(vfn.system(fcitx_cmd))
    return input_status == 2
end

local function switch_normal_do()
    local no_latin = is_no_latin()

    local is_comment = vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "comment")
    if no_latin and is_comment then
        switch_to_en()
    elseif no_latin then
        switch_to_en()

        vim.b.input_toggle_flag = true
    end
end

local function switch_insert_do()
    local is_comment = vim.tbl_contains(vim.treesitter.get_captures_at_cursor(), "comment")
    if is_comment then
        switch_no_latin()
    elseif vim.b.input_toggle_flag == true then
        switch_no_latin()
        vim.b.input_toggle_flag = false
    end
end

local fc = api.nvim_create_augroup("fcitx", { clear = false })

api.nvim_create_autocmd({ "InsertEnter" }, {
    group = fc,
    pattern = { "*" },
    callback = switch_insert_do,
})
api.nvim_create_autocmd({ "InsertLeave" }, {
    group = fc,
    pattern = { "*" },
    callback = switch_normal_do,
})

api.nvim_create_autocmd({ "CmdlineEnter" }, {
    group = fc,
    pattern = { "[/\\?]" },
    callback = switch_insert_do,
})
api.nvim_create_autocmd({ "CmdlineLeave" }, {
    group = fc,
    pattern = { "[/\\?]" },
    callback = switch_normal_do,
})
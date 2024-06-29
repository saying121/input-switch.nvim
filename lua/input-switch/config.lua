local M = {}

---@type InputConf
M.opt = {
    switch_to_en = "fcitx5-remote -c",
    switch_no_en = "fcitx5-remote -o",
    comment = true,
}

---@param opts InputConf
function M.setup(opts)
    M.opt = vim.tbl_deep_extend("force", M.opt, opts or nil)
end

function M.to_en()
    return M.opt.switch_to_en
end

function M.no_en()
    return M.opt.switch_no_en
end

function M.enable_comment()
    return M.opt.comment
end

return M

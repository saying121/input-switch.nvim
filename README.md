# Introduct

- When cursor under is comment switch input method.
- Normal mode switch to en.

# Config

config with lazy.nvim

```lua
return {
    "saying121/input-switch.nvim",
    event = { "InsertEnter", "CmdlineEnter" },
    config = function()
        require("input-switch").setup({
            switch_to_en = "fcitx5-remote -c", -- cmd for switch to en
            switch_no_en = "fcitx5-remote -o", -- cmd for switch to no en
            comment = true, -- enable comment switch?
        })
    end,
}
```

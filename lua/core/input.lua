-- lua/core/input.lua
-- Clean, Centered Input Box using nui.nvim

local Input = require("nui.input")
local event = require("nui.utils.autocmd").event

local M = {}

function M.ask(prompt_text, default_value, on_submit)
    local input = Input({
        position = "50%",
        size = {
            width = "60%",
        },
        border = {
            style = "rounded",
            text = {
                top = " " .. prompt_text .. " ",
                top_align = "center",
            },
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
    }, {
        prompt = "> ",
        default_value = default_value or "",
        on_close = function()
            print("Input Cancelled")
        end,
        on_submit = function(value)
            if value and value ~= "" then
                on_submit(value)
            end
        end,
    })

    -- Mount the component
    input:mount()

    -- Close on <Esc> in Normal mode (Nui handles Insert mode Esc by default usually, but let's be safe)
    input:map("n", "<Esc>", function()
        input:unmount()
    end, { noremap = true })
    
    -- Ensure we start in insert mode
    vim.cmd("startinsert")
end

return M

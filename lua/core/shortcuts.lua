-- lua/core/shortcuts.lua
-- Displays a floating list of shortcuts

local Popup = require("nui.popup")
local event = require("nui.utils.autocmd").event

local M = {}

local current_popup = nil

function M.show()
    -- If already open, close it (Toggle behavior)
    if current_popup then
        current_popup:unmount()
        current_popup = nil
        return
    end

    local popup = Popup({
        enter = true,
        focusable = true,
        border = {
            style = "rounded",
            text = {
                top = " Shortcuts ",
                top_align = "center",
            },
        },
        position = "50%",
        size = {
            width = "60%",
            height = "60%",
        },
        win_options = {
            winhighlight = "Normal:Normal,FloatBorder:FloatBorder",
        },
    })

    -- mount/open the component
    popup:mount()
    current_popup = popup

    -- unmount component when cursor leaves buffer
    popup:on(event.BufLeave, function()
        popup:unmount()
        current_popup = nil
    end)
    
    -- Close on Esc and q
    popup:map("n", "<Esc>", function() 
        popup:unmount() 
        current_popup = nil
    end, { noremap = true })
    
    popup:map("n", "q", function() 
        popup:unmount() 
        current_popup = nil
    end, { noremap = true })

    -- Set content
    local lines = {
        "",
        "  Ctrl+S   Save File",
        "  Ctrl+O   Open Folder",
        "  Ctrl+Z   Undo",
        "  Ctrl+C   Copy / Stop Code",
        "  Ctrl+V   Paste",
        "  Ctrl+F   Find Files",
        "  Ctrl+H   Search Text",
        "  Ctrl+B   Toggle Sidebar",
        "  Ctrl+/   Toggle Comment",
        "  Ctrl+\\   Toggle Terminal",
        "  F5       Run Code",
        "",
        "  -- Sidebar Keys --",
        "  Enter    Open File",
        "  a        Add File/Folder",
        "  d        Delete",
        "  r        Rename",
        "  c        Copy",
        "  m        Move",
        "",
        "  [Esc] to Close",
    }
    
    vim.api.nvim_buf_set_lines(popup.bufnr, 0, 1, false, lines)
    
    -- Set buffer to readonly/nomodifiable
    vim.api.nvim_buf_set_option(popup.bufnr, "modifiable", false)
    vim.api.nvim_buf_set_option(popup.bufnr, "readonly", true)
end

return M

-- lua/core/keymaps.lua
-- EasyVim: 10 Essential Shortcuts

local map = vim.keymap.set

-- Commands for running different file types
-- Load runners from shared config to avoid duplication
local run_commands = {
    javascript = "node",
    typescript = "deno run",
    lua = "lua",
    go = "go run",
    php = "php",
    ruby = "ruby",
    dart = "dart run",
    java = "java",
}


-- Quick function to run current file
local function run_code()
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%:p")
    
    if file == "" or vim.bo.buftype ~= "" then
        vim.notify("Hey! Open a file first before running this", vim.log.levels.WARN)
        return
    end
    
    local cmd = run_commands[ft]
    if not cmd then
        vim.notify("Hmm, don't know how to run " .. ft .. " files yet", vim.log.levels.WARN)
        return
    end
    
    vim.cmd("write")
    
    -- Build full command
    local full_cmd
    if cmd:find("%%s") then
        full_cmd = string.format(cmd, file)
    else
        full_cmd = cmd .. " " .. file
    end
    
    -- Run in Native Terminal
    EasyTerminal.run(full_cmd)
end

-- Save shortcut
map({ "n", "i", "v" }, "<C-s>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    if vim.bo.buftype == "" then vim.cmd("write") end
end, { desc = "Save" })

-- Undo shortcut
map({ "n", "i" }, "<C-z>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    vim.cmd("undo")
end, { desc = "Undo" })

-- Copy shortcut (works in visual mode for selections like Ctrl+A)
map("v", "<C-c>", '"+y', { desc = "Copy" })

-- Paste shortcut
map({ "n", "i" }, "<C-v>", '"+p', { desc = "Paste" })
-- Terminal paste needs special handling
map("t", "<C-v>", '<C-\\><C-N>"+pi', { desc = "Paste" })

-- File search
map({ "n", "i" }, "<C-f>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    require("telescope.builtin").find_files()
end, { desc = "Find Files" })

-- Text search
map({ "n", "i" }, "<C-h>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    require("telescope.builtin").live_grep()
end, { desc = "Search in Files" })

-- Toggle sidebar
map({ "n", "i", "v" }, "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Sidebar" })

-- 8. Ctrl+/: Toggle Comment (handled by Comment.nvim)

-- Terminal toggle
map({ "n", "i", "t" }, "<C-\\>", function()
    EasyTerminal.toggle()
end, { desc = "Toggle Terminal" })

-- Run current file
map("n", "<F5>", run_code, { desc = "Run Code" })

-- Tab navigation
map("n", "<Tab>", "<cmd>BufferLineCycleNext<cr>", { desc = "Next Tab" })
map("n", "<S-Tab>", "<cmd>BufferLineCyclePrev<cr>", { desc = "Prev Tab" })

-- Esc: Clear search
map({ "n", "i" }, "<Esc>", "<cmd>nohlsearch<cr><Esc>", { desc = "Clear" })

-- Backspace in Normal Mode (behaves like an editor)
map("n", "<BS>", "i<BS><Esc>l", { desc = "Backspace" })

-- Enter in Normal Mode (behaves like an editor)
map("n", "<CR>", "i<CR><Esc>", { desc = "Enter Key" })

-- Select All (Ctrl+A) - enters visual mode to select, that's fine
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select All" })

-- Backspace in Visual Mode (Deletes selection)
map("v", "<BS>", '"_d', { desc = "Delete Selection" })

-- =====================================================
-- MOUSE VISUAL MODE DISABLED
-- Double-click/triple-click normally enters visual mode - disabled here
-- Keyboard v/V keys still work for power users who need them
-- =====================================================
map("n", "<2-LeftMouse>", "<LeftMouse>", { desc = "Double-click = single click" })
map("n", "<3-LeftMouse>", "<LeftMouse>", { desc = "Triple-click = single click" })
map("n", "<4-LeftMouse>", "<LeftMouse>", { desc = "Quad-click = single click" })
map("i", "<2-LeftMouse>", "<LeftMouse>", { desc = "Double-click = single click" })
map("i", "<3-LeftMouse>", "<LeftMouse>", { desc = "Triple-click = single click" })
map("i", "<4-LeftMouse>", "<LeftMouse>", { desc = "Quad-click = single click" })
map("v", "<LeftDrag>", "<Esc>", { desc = "Exit visual on mouse drag" })
map("v", "<LeftRelease>", "<Esc>", { desc = "Exit visual on mouse release" })

-- Some extra handy shortcuts I've been wanting
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Quick save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quick quit" })
map("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })

-- Sometimes I accidentally hit these, so disable them
map("", "<F1>", "<Nop>", { desc = "Disable help" })
map("i", "<F1>", "<Nop>", { desc = "Disable help in insert" })

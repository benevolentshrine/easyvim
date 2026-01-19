-- lua/core/keymaps.lua
-- EasyVim: 10 Essential Shortcuts

local map = vim.keymap.set

-- Run commands for each filetype
local run_commands = {
    python = "python3 " .. vim.fn.stdpath("config") .. "/lua/core/pyrunner.py",
    javascript = "node",
    typescript = "deno run",
    lua = "lua",
    go = "go run",
    rust = "rustc %s -o /tmp/rustout && /tmp/rustout",
    c = "gcc %s -o /tmp/cout && /tmp/cout",
    cpp = "g++ %s -o /tmp/cppout && /tmp/cppout",
    bash = "bash",
    sh = "sh",
    java = "java", -- Runs single file source code
    php = "php",
    ruby = "ruby",
    dart = "dart run",
    html = "xdg-open", -- Opens in browser
}

-- Simple Run Code function
local function run_code()
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%:p")
    
    if file == "" or vim.bo.buftype ~= "" then
        vim.notify("Open a file first!", vim.log.levels.WARN)
        return
    end
    
    local cmd = run_commands[ft]
    if not cmd then
        vim.notify("No runner for: " .. ft, vim.log.levels.WARN)
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

-- 1. Ctrl+S: Save
map({ "n", "i", "v" }, "<C-s>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    if vim.bo.buftype == "" then vim.cmd("write") end
end, { desc = "Save" })

-- 2. Ctrl+Z: Undo
map({ "n", "i" }, "<C-z>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    vim.cmd("undo")
end, { desc = "Undo" })

-- 3. Ctrl+C: Copy
map("v", "<C-c>", '"+y', { desc = "Copy" })

-- 4. Ctrl+V: Paste
map({ "n", "i" }, "<C-v>", '"+p', { desc = "Paste" })
-- Paste in Terminal Mode (Needs specific escape sequence)
map("t", "<C-v>", '<C-\\><C-N>"+pi', { desc = "Paste" })

-- 5. Ctrl+F: Find Files
map({ "n", "i" }, "<C-f>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    require("telescope.builtin").find_files()
end, { desc = "Find Files" })

-- 6. Ctrl+H: Search in Files
map({ "n", "i" }, "<C-h>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    require("telescope.builtin").live_grep()
end, { desc = "Search in Files" })

-- 7. Ctrl+B: Toggle Sidebar
map({ "n", "i", "v" }, "<C-b>", "<cmd>Neotree toggle<cr>", { desc = "Toggle Sidebar" })

-- 8. Ctrl+/: Toggle Comment (handled by Comment.nvim)

-- 9. Ctrl+\: Toggle Terminal
map({ "n", "i", "t" }, "<C-\\>", function()
    EasyTerminal.toggle()
end, { desc = "Toggle Terminal" })

-- 10. F5: Run Code
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

-- Select All (Ctrl+A)
map({ "n", "i", "v" }, "<C-a>", "<Esc>ggVG", { desc = "Select All" })

-- Backspace in Visual Mode (Deletes selection)
map("v", "<BS>", '"_d', { desc = "Delete Selection" })

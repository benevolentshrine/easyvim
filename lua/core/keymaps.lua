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
-- Global Actions Table (exposed for UI/Plugins)
_G.EasyVim = _G.EasyVim or {}

-- 1. Smart Save (Handles "Save As" for new files)
function EasyVim.smart_save()
    local current_file = vim.fn.expand("%:p")
    
    -- If file already exists and is a normal buffer, just save
    if current_file ~= "" and vim.bo.buftype == "" then
        vim.cmd("write")
        return
    end

    -- 1. Try Zenity (Linux GUI)
    if vim.fn.executable("zenity") == 1 then
        local handle = io.popen("zenity --file-selection --save --confirm-overwrite --title='Save As' 2>/dev/null")
        if handle then
            local new_path = handle:read("*a"):gsub("%s+$", "") -- trim whitespace
            handle:close()
            
            if new_path ~= "" then
                vim.cmd("write " .. vim.fn.fnameescape(new_path))
            end
            -- If cancelled (empty string), do nothing and return.
            return
        end
    end

    -- 2. Fallback to Text Input (if Zenity is missing)
    vim.ui.input({ prompt = "Save As: ", default = "./" }, function(input)
        if input and input ~= "" then
            vim.cmd("write " .. input)
        end
    end)
end

-- 2. New File (Handles "Creates New File" via GUI)
function EasyVim.new_file()
    -- 1. Try Zenity (Linux GUI)
    if vim.fn.executable("zenity") == 1 then
        local handle = io.popen("zenity --file-selection --save --confirm-overwrite --title='Create New File' 2>/dev/null")
        if handle then
            local new_path = handle:read("*a"):gsub("%s+$", "") -- trim whitespace
            handle:close()
            
            if new_path ~= "" then
                vim.cmd("edit " .. vim.fn.fnameescape(new_path))
                vim.cmd("write") -- Create the file on disk immediately
            end
            -- If cancelled, do nothing
            return
        end
    end

    -- 2. Fallback to Text Input
    vim.ui.input({ prompt = "New File Name: ", default = "./" }, function(input)
        if input and input ~= "" then
            vim.cmd("edit " .. input)
            vim.cmd("write") -- Create immediately
        end
    end)
end

-- 3. Open Folder (Handles UI vs Text Input)
function EasyVim.open_folder()
    -- Check if Zenity is available (Linux GUI)
    if vim.fn.executable("zenity") == 1 then
        local handle = io.popen("zenity --file-selection --directory --title='Open Folder' 2>/dev/null")
        if handle then
            local new_dir = handle:read("*a"):gsub("%s+$", "") -- trim whitespace
            handle:close()
            
            -- If user selected a directory, navigate to it
            if new_dir ~= "" and vim.fn.isdirectory(new_dir) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(new_dir))
                vim.cmd("Neotree show")
                vim.notify("Workspace: " .. new_dir)
            end
            -- If user cancelled (new_dir is empty), do NOTHING. 
            -- Do not fallback to text input.
            return
        end
    end

    -- Fallback: Use Text Input ONLY if Zenity is not installed
    vim.ui.input({ prompt = "Open Folder: ", default = vim.fn.getcwd() .. "/", completion = "dir" }, function(input)
        if input and input ~= "" then
            local new_dir = input
            -- Execute change if input valid
            if vim.fn.isdirectory(new_dir) == 1 then
                vim.cmd("cd " .. vim.fn.fnameescape(new_dir))
                vim.cmd("Neotree show")
                vim.notify("Workspace: " .. new_dir)
            else
                vim.notify("Not a valid directory", vim.log.levels.ERROR)
            end
        end
    end)
end

-- Save shortcut
map({ "n", "i", "v" }, "<C-s>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    EasyVim.smart_save()
end, { desc = "Save File" })

-- Open Folder shortcut
map({ "n", "i", "v" }, "<C-o>", function()
    if vim.fn.mode() ~= "n" then vim.cmd("stopinsert") end
    EasyVim.open_folder()
end, { desc = "Open Folder" })

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

-- Exit (like VS Code Ctrl+Q)
map({ "n", "i", "v" }, "<C-q>", "<cmd>qa<cr>", { desc = "Exit EasyVim" })

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
-- MOUSE VISUAL MODE DISABLED (except in terminal)
-- Double-click/triple-click normally enters visual mode - disabled here
-- Keyboard v/V keys still work for power users who need them
-- =====================================================
map("n", "<2-LeftMouse>", "<LeftMouse>", { desc = "Double-click = single click" })
map("n", "<3-LeftMouse>", "<LeftMouse>", { desc = "Triple-click = single click" })
map("n", "<4-LeftMouse>", "<LeftMouse>", { desc = "Quad-click = single click" })
map("i", "<2-LeftMouse>", "<LeftMouse>", { desc = "Double-click = single click" })
map("i", "<3-LeftMouse>", "<LeftMouse>", { desc = "Triple-click = single click" })
map("i", "<4-LeftMouse>", "<LeftMouse>", { desc = "Quad-click = single click" })
-- Note: Terminal mode (t) is NOT affected - mouse selection works there for copying output

-- F4: Exit (works reliably in SSH)
map({ "n", "i", "v" }, "<F4>", "<cmd>qa<cr>", { desc = "Exit" })

-- SSH-friendly exits using regular keys (these ALWAYS work)
map("n", "ZZ", "<cmd>wqa<cr>", { desc = "Save all and exit" })  -- Classic vim
map("n", "ZQ", "<cmd>qa!<cr>", { desc = "Force quit without saving" })
map("n", "qq", "<cmd>qa<cr>", { desc = "Quick exit (double tap q)" })

-- Leader shortcuts (Space + key)
map("n", "<leader>w", "<cmd>w<CR>", { desc = "Quick save" })
map("n", "<leader>q", "<cmd>q<CR>", { desc = "Quick quit" })
map("n", "<leader>so", "<cmd>source %<CR>", { desc = "Source current file" })

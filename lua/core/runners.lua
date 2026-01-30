-- Centralized runner commands - avoids duplication across keymaps and UI
-- TODO: Add more language support when needed

local M = {}

-- Store commands locally so we don't recreate this table every time
local commands = {
    javascript = "node",
    typescript = "deno run", 
    lua = "lua",
    go = "go run",
    php = "php",
    ruby = "ruby",
    dart = "dart run",
    java = "java",
}

-- Setup platform-specific commands
if vim.fn.has("win32") == 1 then
    -- Windows paths and commands
    local pyrunner_path = vim.fn.stdpath("config") .. "/lua/core/pyrunner.py"
    commands.python = vim.fn.filereadable(pyrunner_path) == 1 and "python " .. pyrunner_path or "python"
    commands.rust = "rustc %s -o main.exe && .\\main.exe"
    commands.c = "gcc %s -o main.exe && .\\main.exe" 
    commands.cpp = "g++ %s -o main.exe && .\\main.exe"
    commands.html = "explorer"
else
    -- Unix-like systems (Linux/Mac)
    local pyrunner_path = vim.fn.stdpath("config") .. "/lua/core/pyrunner.py"
    commands.python = vim.fn.filereadable(pyrunner_path) == 1 and "python3 " .. pyrunner_path or "python3"
    commands.rust = "rustc %s -o /tmp/rustout && /tmp/rustout"
    commands.c = "gcc %s -o /tmp/cout && /tmp/cout"
    commands.cpp = "g++ %s -o /tmp/cppout && /tmp/cppout"
    commands.html = "xdg-open"
end

function M.get_commands()
    return commands
end

function M.get_command(filetype)
    return commands[filetype]
end

-- Add a new command - useful for extending the system
function M.add_command(filetype, command)
    commands[filetype] = command
end

return M
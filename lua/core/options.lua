-- lua/core/options.lua
-- EasyVim Editor Settings

local opt=vim.opt

-- Mouse: Enable globally
opt.mouse="a"

-- Clipboard: Sync with system
opt.clipboard='unnamedplus'

-- Cursor Style: Line everywhere (VS Code style), no Block
opt.guicursor = "a:ver25"

-- Editor Defaults
opt.number=true
opt.relativenumber = false
opt.tabstop = 4
opt.shiftwidth = 4
opt.expandtab = true          -- Use spaces instead of tabs
opt.backspace = "indent,eol,start" -- Allow backspace over everything
opt.wrap = false              -- No wrapping by default
opt.ignorecase = true         -- Ignore case in search
opt.smartcase = true          -- ...unless uppercase is used
opt.termguicolors = true      -- True color support
opt.scrolloff = 8             -- Keep 8 lines visible above/below cursor
opt.signcolumn = "yes"        -- Always show sign column (prevents jumping)
opt.updatetime = 250          -- Faster completion
opt.timeoutlen = 300          -- Faster key sequence completion
opt.swapfile = false          -- No swap files (no annoying warnings)
opt.backup = false            -- No backup files
opt.writebackup = false       -- No write backup

-- UI Polish
opt.fillchars = { eob = " " } -- Remove "~" at end of buffer
opt.laststatus = 0            -- Hide Statusline (We will use the Top Bar instead)
opt.showtabline = 2           -- Always show Tabline (The Top Bar)
opt.ruler = false             -- Hide "Bot", "Top", "50%" at bottom right
opt.showcmd = false           -- Hide partial command characters at bottom right
opt.cmdheight = 0             -- Hide the command line when not typing
opt.showmode = false          -- Hide "-- INSERT --" etc (Lualine handles it)



-- TODO: Consider making some of these configurable
-- NOTE: Disabled swap files because they were annoying me personally
--       Might want to make this optional in the future

-- Personal preferences that might change
opt.cursorline = true  -- I like seeing current line
opt.foldmethod = "indent" -- Basic folding, might change later
opt.foldlevelstart = 99  -- Start unfolded

-- Might remove these later, testing for now
opt.title = true
opt.titlestring = "%t - EasyVim"

-- Auto Insert Mode: Always start in insert mode for real files
-- Makes EasyVim feel like a normal editor, not a modal one
vim.api.nvim_create_autocmd({"BufEnter", "BufWinEnter"}, {
    callback = function()
        local bt = vim.bo.buftype
        local ft = vim.bo.filetype
        
        -- Skip special buffers (sidebars, terminals, popups, etc.)
        local skip_types = {
            "neo-tree", "alpha", "TelescopePrompt", "lazy", "mason", 
            "help", "qf", "terminal", "nofile", "prompt"
        }
        
        for _, skip in ipairs(skip_types) do
            if ft == skip or bt == skip then return end
        end
        
        -- For normal file buffers (including new empty files with no filetype yet)
        if bt == "" then
            -- Use defer_fn with 0 delay for immediate but safe execution
            vim.defer_fn(function()
                if vim.fn.mode() == "n" and vim.bo.buftype == "" then
                    vim.cmd("startinsert")
                end
            end, 1)  -- 1ms delay, practically instant
        end
    end
})

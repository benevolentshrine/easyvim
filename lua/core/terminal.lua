-- lua/core/terminal.lua
-- EasyVim: Native Terminal Implementation (Refined)

local M = {}
local state = {
    buf = -1,
    win = -1,
}

local function ensure_term_buf()
    if state.buf ~= -1 and vim.api.nvim_buf_is_valid(state.buf) then
        return state.buf
    end
    state.buf = vim.api.nvim_create_buf(false, true)
    return state.buf
end

local function set_term_options(buf)
    vim.api.nvim_buf_set_option(buf, "buflisted", false)
    vim.api.nvim_buf_set_option(buf, "filetype", "terminal")
    vim.api.nvim_buf_set_option(buf, "buftype", "terminal")
    vim.api.nvim_buf_set_option(buf, "modifiable", true)
    vim.api.nvim_buf_set_option(buf, "number", false)
    vim.api.nvim_buf_set_option(buf, "relativenumber", false)
    vim.api.nvim_buf_set_option(buf, "signcolumn", "no")
    
    -- DISABLE PLUGINS IN TERMINAL
    vim.b[buf].cmp_enabled = false -- Disable nvim-cmp
    vim.b[buf].minicmp_disable = true -- Disable mini.completion
    
    -- FORCE INSERT MODE ON INTERACTIONS
    -- If user clicks inside, go to Insert Mode immediately
    vim.keymap.set("n", "<LeftRelease>", "<LeftRelease>i", { buffer = buf, silent = true })
    -- If user presses Enter in Normal mode, go to Insert Mode
    vim.keymap.set("n", "<CR>", "i", { buffer = buf, silent = true })
    -- Map 'i' and 'a' explicitly just in case
    vim.keymap.set("n", "i", "startinsert", { buffer = buf, silent = true })
    vim.keymap.set("n", "a", "startinsert", { buffer = buf, silent = true })
end

function M.toggle()
    if state.win ~= -1 and vim.api.nvim_win_is_valid(state.win) then
        vim.api.nvim_win_hide(state.win)
        state.win = -1
        return
    end

    local buf = ensure_term_buf()
    vim.cmd("botright 12split")
    local win = vim.api.nvim_get_current_win()
    state.win = win
    vim.api.nvim_win_set_buf(win, buf)
    
    if vim.fn.bufname(buf) == "" then
        vim.fn.termopen(vim.o.shell, {
            on_exit = function()
                state.buf = -1 
            end
        })
    end
    
    set_term_options(buf)
    -- 4. Force Insert Mode (CRITICAL for user interaction)
    vim.cmd("startinsert") 
    vim.defer_fn(function()
        vim.cmd("startinsert")
    end, 50) -- 50ms retry to catch any race conditions
end

function M.run(cmd)
    if state.win == -1 or not vim.api.nvim_win_is_valid(state.win) then
        M.toggle()
    else
        vim.api.nvim_set_current_win(state.win)
    end
    
    local buf = state.buf
    local chan = vim.b[buf].terminal_job_id
    
    if chan then
        vim.api.nvim_chan_send(chan, cmd .. "\n")
        vim.cmd("normal! G")
        
        -- Force Insert Mode with Retry
        vim.cmd("startinsert")
        vim.defer_fn(function()
            vim.cmd("startinsert")
        end, 50)
    else
        -- Retry toggle if job is dead
        M.toggle()
    end
end

-- Fix: Force modifiable and insert mode
vim.api.nvim_create_autocmd("TermOpen", {
    group = vim.api.nvim_create_augroup("EasyTermFix", { clear = true }),
    pattern = "*",
    callback = function()
        vim.opt_local.modifiable = true
        vim.opt_local.number = false
        vim.opt_local.signcolumn = "no"
        vim.cmd("startinsert") 
    end,
})

vim.api.nvim_create_autocmd("BufEnter", {
    group = vim.api.nvim_create_augroup("EasyTermFocus", { clear = true }),
    pattern = "term://*",
    callback = function()
        vim.cmd("startinsert")
    end,
})

_G.EasyTerminal = M -- New Global Name
return M

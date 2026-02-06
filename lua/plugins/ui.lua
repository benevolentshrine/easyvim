-- lua/plugins/ui.lua
-- EasyVim UI Configuration

return {
    -- 1. Color Schemes (5 Diverse Minimal Themes)
    {
        "rose-pine/neovim",
        name = "rose-pine",
        lazy = false,
        priority = 1000,
        config = function()
            require("rose-pine").setup({ styles = { italic = false } })
            
            -- Persistent Theme Loader
            local data_path = vim.fn.stdpath("data") .. "/theme.txt"
            if vim.fn.filereadable(data_path) == 1 then
                local saved_theme = vim.fn.readfile(data_path)[1]
                if saved_theme and saved_theme ~= "" then
                    -- Special handling for Everforest dark mode
                    if saved_theme == "everforest" then
                        vim.o.background = "dark"
                    end
                    
                    -- Try to load the saved theme, fallback to rose-pine if fails
                    local ok = pcall(vim.cmd, "colorscheme " .. saved_theme)
                    if not ok then
                        vim.cmd("colorscheme rose-pine")
                    end
                else
                   vim.cmd("colorscheme rose-pine")
                end
            else
                vim.cmd("colorscheme rose-pine")
            end
        end,
    },
    { "shaunsingh/nord.nvim", lazy = true },
    { "sainnhe/everforest", lazy = true },
    { "navarasu/onedark.nvim", lazy = true },
    { "EdenEast/nightfox.nvim", lazy = true },

    -- 2. File Explorer (Sidebar)
    {
        "nvim-neo-tree/neo-tree.nvim",

        branch = "v3.x",
        lazy = false,
        dependencies = {
            "nvim-lua/plenary.nvim",
            "nvim-tree/nvim-web-devicons",
            "MunifTanjim/nui.nvim",
        },
        opts = {
            close_if_last_window = true,
            enable_git_status = true,
            window = {
                position = "left",
                width = 30,
                auto_expand_width = false,  -- Don't auto-expand
                mappings = {
                    -- Navigation (Default vim keys j/k/arrows work automatically)
                    ["h"] = "close_node",           -- Collapse folder
                    ["l"] = "open",                 -- Expand folder / open file
                    ["<Left>"] = "close_node",
                    ["<Right>"] = "open",
                    
                    -- File operations
                    ["<CR>"] = "open",              -- Enter opens file
                    ["o"] = "open",                 -- o opens file  
                    ["<2-LeftMouse>"] = "open",     -- Double-click opens
                    ["a"] = "add",                  -- Add file/folder
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["c"] = "copy",
                    ["m"] = "move",
                    ["<"] = "prev_source",
                    [">"] = "next_source",
                    
                    -- Extra navigation
                    ["P"] = "navigate_up",          -- Go to parent
                    ["<BS>"] = "navigate_up",       -- Backspace = go up
                    
                    -- Global Search consistency
                    ["<C-f>"] = function() require("telescope.builtin").find_files() end,
                    ["<C-h>"] = function() require("telescope.builtin").live_grep() end,
                    ["<C-o>"] = function() _G.EasyVim.open_folder() end,
                },
            },
            filesystem = {
                follow_current_file = { enabled = true },
                hijack_netrw_behavior = "open_default",
            },
            event_handlers = {
                {
                    event = "neo_tree_buffer_enter",
                    handler = function()
                        vim.opt_local.signcolumn = "auto"
                    end,
                },
            },
        },
        config = function(_, opts)
            require("neo-tree").setup(opts)
            
            -- Auto-show on startup (if directory)
            vim.api.nvim_create_autocmd("VimEnter", {
                callback = function()
                    if vim.fn.argc() == 0 then
                        vim.cmd("Neotree show")
                    end
                end,
            })
            
            -- Hide Cursor but SHOW current line highlight in Sidebar
            local function set_sidebar_cursor()
                -- 1. Hide the cursor itself (invisible)
                vim.api.nvim_set_hl(0, "HiddenCursor", { fg = "bg", bg = "bg", blend = 100 })
                vim.opt_local.guicursor = "a:hor1-HiddenCursor"
                
                -- 2. ENABLE cursorline so user can see which item they're on!
                vim.opt_local.cursorline = true
            end
            
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "neo-tree",
                callback = set_sidebar_cursor,
            })
            
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*",
                callback = function()
                    if vim.bo.filetype == "neo-tree" then
                        set_sidebar_cursor()
                        
                        -- CRITICAL: Make sure we're in normal mode
                        vim.cmd("stopinsert")
                        
                        -- Disable ALL Visual Mode entry in Sidebar
                        vim.keymap.set("n", "v", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "V", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "<C-v>", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "gv", "<Nop>", { buffer = true, silent = true })
                        
                        -- Disable insert mode triggers
                        vim.keymap.set("n", "i", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "I", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "a", "add", { buffer = true, silent = true, remap = true })  -- 'a' is for add file
                        vim.keymap.set("n", "A", "<Nop>", { buffer = true, silent = true })
                        
                        -- If somehow in visual/insert mode, escape immediately
                        vim.keymap.set("v", "<Esc>", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "v", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "V", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "<C-v>", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = true, silent = true })
                        
                        -- Mouse events - just escape any mode
                        vim.keymap.set({"n", "v", "i"}, "<LeftRelease>", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set({"n", "v", "i"}, "<LeftDrag>", "<Nop>", { buffer = true, silent = true })
                    else
                        -- Restore to Line Cursor everywhere
                        vim.cmd("set guicursor=a:ver25")
                    end
                end,
            })
            
            -- Force exit insert/visual mode in neo-tree if somehow entered
            vim.api.nvim_create_autocmd("ModeChanged", {
                pattern = "*",
                callback = function()
                    if vim.bo.filetype == "neo-tree" then
                        local mode = vim.fn.mode()
                        -- If we're in insert or visual mode, escape immediately
                        if mode == "i" or mode == "v" or mode == "V" or mode == "\22" then
                            vim.schedule(function()
                                vim.cmd("stopinsert")
                                vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                            end)
                        end
                    end
                end,
            })
        end
    },

    -- 3. Tabs
    {
        "akinsho/bufferline.nvim",
        version = "*",
        dependencies = "nvim-tree/nvim-web-devicons",
        event = "VeryLazy",
        opts = {
            options = {
                mode = "buffers",
                separator_style = "slant",
                always_show_bufferline = true,
                show_buffer_close_icons = true,
                offsets = {
                    { filetype = "neo-tree", text = "Files", separator = true },
                },
            },
        },
    },

    -- 4. Find Files (Telescope)
    {
        "nvim-telescope/telescope.nvim",
        tag = "0.1.6",
        dependencies = { "nvim-lua/plenary.nvim" },
        cmd = "Telescope",
        keys = {
            { "<C-f>", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
            { "<C-h>", "<cmd>Telescope live_grep<cr>", desc = "Search in Files" },
        },
        opts = {
            defaults = {
                layout_strategy = "horizontal",
                layout_config = { prompt_position = "top" },
                sorting_strategy = "ascending",
            },
        },
    },

    -- 5. Mason (LSP Installer)
    {
        "williamboman/mason.nvim",
        cmd = "Mason",
        build = ":MasonUpdate",
        opts = {},
    },

    -- 6. Status Bar (Top)
    {
        "nvim-lualine/lualine.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            -- Helper: Safe Run (only if buffer is a real file)
            local function safe_run()
                local ft = vim.bo.filetype
                local file = vim.fn.expand("%:p")
                
                -- Check if on dashboard or special buffer
                if ft == "alpha" or ft == "neo-tree" or ft == "TelescopePrompt" then
                    vim.notify("Open a file first! Use Ctrl+F to find files.", vim.log.levels.WARN)
                    return
                end
                
                -- Check if no file is open
                if file == "" or vim.bo.buftype ~= "" then
                    vim.notify("Open a code file first!", vim.log.levels.WARN)
                    return
                end

                -- Get commands from shared module to avoid duplication
                local run_commands = require("core.runners").get_commands()

                
                local cmd = run_commands[ft]
                if not cmd then
                    vim.notify("Don't know how to run ." .. (vim.fn.expand("%:e") or ft) .. " files", vim.log.levels.WARN)
                    return
                end

                vim.cmd("write")
                
                local full_cmd
                if cmd:find("%%s") then
                    full_cmd = string.format(cmd, file)
                else
                    full_cmd = cmd .. " " .. file
                end
                
                -- Run in Native Terminal
                EasyTerminal.run(full_cmd)
            end

            -- Actions
            -- act_new, act_save, act_saveas, act_open_folder removed
            -- we now use global EasyVim functions defined in core/keymaps.lua
            
            -- act_open_folder removed; using global EasyVim.open_folder

            -- Global Keymap for Open Folder (Ctrl+O)
            -- Handled in core/keymaps.lua now

            local function act_theme()
                -- Use Telescope for a live preview of themes!
                -- This allows user to see the theme applied as they scroll.
                require("telescope.builtin").colorscheme({
                    enable_preview = true,
                    attach_mappings = function(prompt_bufnr, map)
                        local actions = require("telescope.actions")
                        local action_state = require("telescope.actions.state")
                        
                        -- On selection (Enter)
                        actions.select_default:replace(function()
                            actions.close(prompt_bufnr)
                            local selection = action_state.get_selected_entry()
                            local theme = selection.value
                            
                            -- Apply and Save
                            vim.cmd("colorscheme " .. theme)
                            
                            local data_path = vim.fn.stdpath("data")
                            vim.fn.writefile({theme}, data_path .. "/theme.txt")
                        end)
                        return true
                    end
                })
            end

            require("lualine").setup({
                options = {
                    theme = "auto",
                    section_separators = '',
                    component_separators = '',
                },
                sections = {},
                inactive_sections = {},
                tabline = {
                    lualine_a = { 'mode' },
                    lualine_b = { 'branch', 'diff' },
                    lualine_c = {
                        'filename',
                        { function() return "New" end, on_click = EasyVim.new_file, color = { fg = "#7aa2f7" } },
                        { function() return "Open" end, on_click = EasyVim.open_folder, color = { fg = "#ff9e64" } }, -- NEW
                        { function() return "Files" end, on_click = function() vim.cmd("Neotree toggle") end, color = { fg = "#e0af68" } },
                        { function() return "Save" end, on_click = EasyVim.smart_save, color = { fg = "#9ece6a" } },
                   },
                    lualine_x = {
                        { function() return "Shots" end, on_click = function() require("core.shortcuts").show() end, color = { fg = "#ff9e64" } },
                        { function() return "Theme" end, on_click = act_theme, color = { fg = "#bb9af7" } },
                        { function() return "Terminal" end, on_click = function() EasyTerminal.toggle() end },
                        { function() return "Run" end, on_click = safe_run, color = { fg = "#98be65" } },
                        { function() return "Exit" end, on_click = function() vim.cmd("qa") end, color = { fg = "#f7768e" } },
                    },
                    lualine_y = { 'progress' },
                    lualine_z = { 'location' }
                },
            })
        end,
    },

    -- 7. Dashboard
    {
        "goolord/alpha-nvim",
        dependencies = { 'nvim-tree/nvim-web-devicons' },
        config = function()
            local dashboard = require("alpha.themes.dashboard")
            dashboard.section.header.val = {
                [[███████╗ █████╗ ███████╗██╗   ██╗██╗   ██╗██╗███╗   ███╗]],
                [[██╔════╝██╔══██╗██╔════╝╚██╗ ██╔╝██║   ██║██║████╗ ████║]],
                [[█████╗  ███████║███████╗ ╚████╔╝ ██║   ██║██║██╔████╔██║]],
                [[██╔══╝  ██╔══██║╚════██║  ╚██╔╝  ╚██╗ ██╔╝██║██║╚██╔╝██║]],
                [[███████╗██║  ██║███████║   ██║    ╚████╔╝ ██║██║ ╚═╝ ██║]],
                [[╚══════╝╚═╝  ╚═╝╚══════╝   ╚═╝     ╚═══╝  ╚═╝╚═╝     ╚═╝]],
                "",
                "           Simplicity, Speed, Power           ",
            }
            dashboard.section.buttons.val = {
                dashboard.button("n", "  New File", ":enew<CR>"),
                dashboard.button("o", "  Open Folder (Ctrl+O)", "<cmd>lua vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-o>', true, false, true), 'm', true)<CR>"),
                dashboard.button("f", "  Find File   (Ctrl+F)", ":Telescope find_files<CR>"),
                dashboard.button("q", "  Quit", ":qa<CR>"),
            }
            -- Footer removed as requested
            dashboard.section.footer.val = {} 
            require("alpha").setup(dashboard.config)
            vim.api.nvim_create_autocmd("User", {
                pattern = "AlphaReady",
                callback = function()
                    -- Do not auto-show sidebar on dashboard to keep it clean
                    -- vim.cmd("Neotree show") 
                end,
            })
        end,
    },


}

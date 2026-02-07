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
            local data_path = vim.fn.stdpath("data") .. "/theme.txt"
            if vim.fn.filereadable(data_path) == 1 then
                local saved_theme = vim.fn.readfile(data_path)[1]
                if saved_theme == "Rose Pine" then vim.cmd("colorscheme rose-pine")
                elseif saved_theme == "Nord" then vim.cmd("colorscheme nord")
                elseif saved_theme == "Everforest" then 
                    vim.o.background = "dark"
                    vim.cmd("colorscheme everforest")
                elseif saved_theme == "One Dark" then vim.cmd("colorscheme onedark")
                elseif saved_theme == "Nightfox" then vim.cmd("colorscheme nightfox")
                else
                    vim.cmd("colorscheme rose-pine") 
                end
            else
                vim.cmd.colorscheme("rose-pine")
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
                width = 30,
                mappings = {
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
            
            -- Hide Cursor completely in Sidebar
            local function set_hidden_cursor()
                -- 1. definition of Invisible color (Match background)
                vim.api.nvim_set_hl(0, "HiddenCursor", { fg = "bg", bg = "bg", blend = 100 })
                -- 2. Set to tiny horizontal line (hor1) using that invisible color
                vim.opt_local.guicursor = "a:hor1-HiddenCursor"
            end
            
            vim.api.nvim_create_autocmd("FileType", {
                pattern = "neo-tree",
                callback = set_hidden_cursor,
            })
            
            vim.api.nvim_create_autocmd("BufEnter", {
                pattern = "*",
                callback = function()
                    if vim.bo.filetype == "neo-tree" then
                        set_hidden_cursor()
                        -- Disable ALL Visual Mode entry in Sidebar
                        vim.keymap.set("n", "v", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "V", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "<C-v>", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "gv", "<Nop>", { buffer = true, silent = true })
                        -- If somehow in visual mode, escape immediately
                        vim.keymap.set("v", "<Esc>", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "v", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "V", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "<C-v>", "<Esc>", { buffer = true, silent = true })
                        -- Mouse selection prevention
                        vim.keymap.set("v", "<LeftRelease>", "<Esc>", { buffer = true, silent = true })
                        vim.keymap.set("v", "<LeftDrag>", "<Esc>", { buffer = true, silent = true })
                        
                        -- DISABLE INSERT MODE COMPLETELY - THIS FIXES THE "TEXT" BUG!
                        vim.keymap.set("n", "i", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "I", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "a", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "A", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "o", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "O", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "s", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "S", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "c", "<Nop>", { buffer = true, silent = true })
                        vim.keymap.set("n", "C", "<Nop>", { buffer = true, silent = true })
                        
                        -- If somehow in insert mode, escape immediately
                        vim.keymap.set("i", "<Esc>", "<Esc>", { buffer = true, silent = true })
                    else
                        -- Restore to Line Cursor everywhere
                        vim.cmd("set guicursor=a:ver25")
                    end
                end,
            })
            
            -- Force exit ANY non-normal mode in neo-tree (visual, insert, etc)
            local function enforce_normal_mode()
                if vim.bo.filetype == "neo-tree" then
                    if vim.fn.mode() ~= 'n' then
                        vim.cmd("stopinsert")
                        vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
                    end
                end
            end
            
            vim.api.nvim_create_autocmd({"ModeChanged", "BufEnter", "WinEnter", "InsertEnter"}, {
                pattern = "*",
                callback = function()
                    vim.schedule(enforce_normal_mode)
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
            -- Pre-declare local functions to ensure they can see each other in scope
            local act_new, act_save, act_saveas, act_open_folder, act_theme, safe_run
            
            -- Helper: Safe Run (only if buffer is a real file)
            safe_run = function()
                local ft = vim.bo.filetype
                local file = vim.fn.expand("%:p")
                if ft == "alpha" or ft == "neo-tree" or ft == "TelescopePrompt" then
                    vim.notify("Open a file first! Use Ctrl+F to find files.", vim.log.levels.WARN)
                    return
                end
                if file == "" or vim.bo.buftype ~= "" then
                    vim.notify("Open a code file first!", vim.log.levels.WARN)
                    return
                end
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
                EasyTerminal.run(full_cmd)
            end

            -- Actions
            act_new = function()
                require("core.input").ask("New File Name", "", function(name)
                    vim.cmd("enew")
                    vim.cmd("file " .. name)
                end)
            end
            
            -- Save As with native file manager
            act_saveas = function()
                if vim.fn.executable("zenity") == 1 then
                    local current_dir = vim.fn.getcwd()
                    local handle = io.popen("zenity --file-selection --save --title='Save File' --filename='" .. current_dir .. "/untitled' 2>/dev/null")
                    if handle then
                        local filepath = handle:read("*a"):gsub("%s+$", "")
                        handle:close()
                        if filepath ~= "" then
                            vim.cmd("saveas " .. vim.fn.fnameescape(filepath))
                            vim.notify("Saved: " .. filepath)
                        end
                    end
                else
                    require("core.input").ask("Save As", "", function(name)
                        if name and name ~= "" then
                            vim.cmd("saveas " .. name)
                        end
                    end)
                end
            end
            
            act_save = function() 
                local current_file = vim.fn.expand("%")
                if current_file == "" or current_file == "[No Name]" then
                    act_saveas() -- If no name, use Save As with native picker
                elseif vim.bo.buftype == "" then 
                    vim.cmd("write") 
                    vim.notify("Saved!")
                end 
            end
            local function act_open_folder()
                local new_dir = ""
                
                -- Try zenity on Linux
                if vim.fn.executable("zenity") == 1 then
                    local handle = io.popen("zenity --file-selection --directory --title='Open Folder' 2>/dev/null")
                    if handle then
                        new_dir = handle:read("*a"):gsub("%s+$", "") -- trim whitespace
                        handle:close()
                    end
                end

                -- Fallback to text input if zenity not available or cancelled
                if new_dir == "" then
                    local current = vim.fn.getcwd()
                    new_dir = vim.fn.input("Open Folder: ", current .. "/", "dir")
                end

                if new_dir ~= "" and vim.fn.isdirectory(new_dir) == 1 then
                    vim.cmd("cd " .. vim.fn.fnameescape(new_dir))
                    vim.cmd("Neotree show")
                    vim.notify("Workspace: " .. new_dir)
                elseif new_dir ~= "" then
                    vim.notify("Not a valid directory: " .. new_dir, vim.log.levels.ERROR)
                end
            end

            -- Global Keymap for Open Folder (Ctrl+O)
            vim.keymap.set("n", "<C-o>", act_open_folder, { desc = "Open Folder" })

            local function act_theme() 
                vim.ui.select(
                    { "Rose Pine", "Nord", "Everforest", "One Dark", "Nightfox" },
                    { prompt = "Select Theme" },
                    function(choice)
                        if not choice then return end
                        
                        if choice == "Rose Pine" then 
                            vim.cmd("colorscheme rose-pine")
                        elseif choice == "Nord" then 
                            vim.cmd("colorscheme nord")
                        elseif choice == "Everforest" then 
                            vim.o.background = "dark"
                            vim.cmd("colorscheme everforest")
                        elseif choice == "One Dark" then 
                            vim.cmd("colorscheme onedark")
                        elseif choice == "Nightfox" then 
                            vim.cmd("colorscheme nightfox") 
                        end
                        
                        -- Save choice for persistent load
                        local data_path = vim.fn.stdpath("data")
                        vim.fn.writefile({choice}, data_path .. "/theme.txt")
                    end
                )
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
                        { function() return "New" end, on_click = act_new, color = { fg = "#7aa2f7" } },
                        { function() return "Open" end, on_click = act_open_folder, color = { fg = "#ff9e64" } }, -- NEW
                        { function() return "Files" end, on_click = function() vim.cmd("Neotree toggle") end, color = { fg = "#e0af68" } },
                        { function() return "Save" end, on_click = act_save, color = { fg = "#9ece6a" } },
                   },
                    lualine_x = {
                        { function() return "Shots" end, on_click = function() require("core.shortcuts").show() end, color = { fg = "#ff9e64" } },
                        { function() return "Theme" end, on_click = function() vim.cmd("Telescope colorscheme enable_preview=true") end, color = { fg = "#bb9af7" } },
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

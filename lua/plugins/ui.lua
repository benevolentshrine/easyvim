-- lua/plugins/ui.lua
-- EasyVim UI Configuration

return {
    -- 1. Color Schemes (Dark + Light options)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
        config = function()
            local data_path = vim.fn.stdpath("data") .. "/theme.txt"
            if vim.fn.filereadable(data_path) == 1 then
                local saved_theme = vim.fn.readfile(data_path)[1]
                if saved_theme == "Tokyo Night" then vim.cmd("colorscheme tokyonight-storm")
                elseif saved_theme == "Midnight (Black)" then vim.cmd("colorscheme tokyonight-night")
                elseif saved_theme == "Catppuccin (Mocha)" then vim.cmd("colorscheme catppuccin-mocha")
                elseif saved_theme == "Kanagawa (Zen)" then vim.cmd("colorscheme kanagawa")
                elseif saved_theme == "Gruvbox" then 
                     vim.o.background = "dark"
                     vim.cmd("colorscheme gruvbox")
                else
                     vim.cmd("colorscheme tokyonight-storm") 
                end
            else
                vim.cmd.colorscheme("tokyonight-storm")
            end
        end,
    },
    { "ellisonleao/gruvbox.nvim", lazy = true },
    { "catppuccin/nvim", name = "catppuccin", lazy = true },
    { "rebelot/kanagawa.nvim", lazy = true },

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
                    ["a"] = "add", -- Prompts for name
                    ["d"] = "delete",
                    ["r"] = "rename",
                    ["c"] = "copy",
                    ["m"] = "move",
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
                        -- Disable Visual Mode in Sidebar (User Request: "remove v-block fuss")
                        vim.keymap.set("n", "v", "<Nop>", { buffer = true })
                        vim.keymap.set("n", "V", "<Nop>", { buffer = true })
                        vim.keymap.set("n", "<C-v>", "<Nop>", { buffer = true })
                    else
                        -- Restore to Line Cursor everywhere
                        vim.cmd("set guicursor=a:ver25")
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
                
                if file == "" or vim.bo.buftype ~= "" then
                    vim.notify("Open a file first!", vim.log.levels.WARN)
                    return
                end

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

                if vim.fn.has("win32") == 1 then
                    -- Windows
                    run_commands.python = "python " .. vim.fn.stdpath("config") .. "/lua/core/pyrunner.py"
                    run_commands.rust = "rustc %s -o main.exe && .\\main.exe"
                    run_commands.c = "gcc %s -o main.exe && .\\main.exe"
                    run_commands.cpp = "g++ %s -o main.exe && .\\main.exe"
                    run_commands.html = "explorer"
                else
                    -- Linux / MacOS
                    run_commands.python = "python3 " .. vim.fn.stdpath("config") .. "/lua/core/pyrunner.py"
                    run_commands.rust = "rustc %s -o /tmp/rustout && /tmp/rustout"
                    run_commands.c = "gcc %s -o /tmp/cout && /tmp/cout"
                    run_commands.cpp = "g++ %s -o /tmp/cppout && /tmp/cppout"
                    run_commands.html = "xdg-open"
                end
                
                local cmd = run_commands[ft]
                if not cmd then
                    vim.notify("No runner for: " .. ft, vim.log.levels.WARN)
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
            local function act_new()
                require("core.input").ask("New File Name", "", function(name)
                    vim.cmd("enew")
                    vim.cmd("file " .. name)
                end)
            end
            local function act_save() 
                local current_file = vim.fn.expand("%")
                if current_file == "" then
                    act_saveas() -- If no name, treat as "Save As"
                elseif vim.bo.buftype == "" then 
                    vim.cmd("write") 
                end 
            end
            local function act_saveas()
                require("core.input").ask("Save As", "", function(name)
                    vim.cmd("saveas " .. name)
                end)
            end
            local function act_open_folder()
                local new_dir = ""
                
                -- OS-Specific GUI Pickers
                if vim.fn.has("win32") == 1 then
                    -- Windows (PowerShell)
                    local cmd = "powershell -NoProfile -Command \"Add-Type -AssemblyName System.Windows.Forms; $d = New-Object System.Windows.Forms.FolderBrowserDialog; $d.ShowNewFolderButton = $true; if ($d.ShowDialog() -eq 'OK') { Write-Host $d.SelectedPath }\""
                    local handle = io.popen(cmd)
                    if handle then
                        new_dir = handle:read("*a"):gsub("[\r\n]", "")
                        handle:close()
                    end
                elseif vim.fn.has("mac") == 1 then
                    -- MacOS (AppleScript)
                    local handle = io.popen("osascript -e 'POSIX path of (choose folder)'")
                    if handle then
                        new_dir = handle:read("*a"):gsub("[\r\n]", "")
                        handle:close()
                    end
                elseif vim.fn.executable("zenity") == 1 then
                    -- Linux (Zenity) - Silence GTK/Adwaita warnings
                    local handle = io.popen("zenity --file-selection --directory 2>/dev/null")
                    if handle then
                        new_dir = handle:read("*a"):gsub("[\r\n]", "")
                        handle:close()
                    end
                end

                -- Fallback to Text Input if GUI failed or cancelled
                if new_dir == "" then
                    -- If user cancelled GUI, do nothing. If GUI failed, ask via text.
                    -- Simple heuristic: if GUI tools missing, fallback.
                    if vim.fn.has("win32") == 0 and vim.fn.has("mac") == 0 and vim.fn.executable("zenity") == 0 then
                         local current = vim.fn.getcwd()
                         new_dir = vim.fn.input("Open Folder: ", current .. "/", "dir")
                    end
                end

                if new_dir ~= "" then
                    vim.cmd("cd " .. new_dir)
                    vim.cmd("Neotree show")
                    vim.notify("Workspace: " .. new_dir)
                end
            end

            -- Global Keymap for Open Folder (Ctrl+O)
            vim.keymap.set("n", "<C-o>", act_open_folder, { desc = "Open Folder" })

            local function act_theme() 
                vim.ui.select(
                    { "Tokyo Night", "Midnight (Black)", "Catppuccin (Mocha)", "Kanagawa (Zen)", "Gruvbox" },
                    { prompt = "Select Theme" },
                    function(choice)
                        if not choice then return end
                        
                        if choice == "Tokyo Night" then 
                            vim.cmd("colorscheme tokyonight-storm")
                        elseif choice == "Midnight (Black)" then 
                            vim.cmd("colorscheme tokyonight-night")
                        elseif choice == "Catppuccin (Mocha)" then 
                            vim.cmd("colorscheme catppuccin-mocha")
                        elseif choice == "Kanagawa (Zen)" then 
                            vim.cmd("colorscheme kanagawa")
                        elseif choice == "Gruvbox" then 
                            vim.o.background = "dark"
                            vim.cmd("colorscheme gruvbox") 
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

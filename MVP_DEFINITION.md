# TEMPLATE 5: MVP Definition Template

**Project Title:** EasyVim: The Zero-Friction Neovim config.  
**Team ID / Members:** SY1901 / Hrishikesh Kulkarni, Harsh Singh, Lucky, Sayan Ghoshal

---

## MVP (Minimum Viable Product) Features

List of essential, functional elements needed for validation:

| Feature | Purpose | Must Have / Good to Have |
| :--- | :--- | :--- |
| **Familiar Keybindings** (Ctrl+S, Ctrl+C, Ctrl+V, Ctrl+Z) | Makes Neovim usable for beginners without learning Vim commands. | Must Have |
| **File Explorer** (Neo-tree) | Allows users to browse and manage files visually. | Must Have |
| **LSP Autocompletion** | Provides code suggestions and error detection like a real IDE. | Must Have |
| **Syntax Highlighting** (Treesitter) | Makes code readable with proper colors for keywords, strings, etc. | Must Have |
| **One-Line Install Script** | Makes installation easy so users can try it quickly. | Must Have |
| **Theme Switcher** | Lets users pick their preferred color scheme. | Good to Have |
| **Status Bar** (Lualine) | Shows useful info like file name, git branch, and mode. | Good to Have |
| **Tab Bar** (Bufferline) | Helps manage multiple open files. | Good to Have |
| **Terminal Toggle** | Quick access to terminal without leaving the editor. | Good to Have |
| **Code Runner** (F5) | Run code files directly from the editor. | Good to Have |

---

## MVP Justification

**Why these features are selected for MVP?**

The "Must Have" features represent the core promise of EasyVim — making Neovim accessible to beginners. Without familiar keybindings (Ctrl+S to save, Ctrl+C to copy), users would be stuck in Vim's modal editing which is confusing for newcomers. The file explorer, autocompletion, and syntax highlighting are basic expectations from any modern code editor.

The "Good to Have" features improve the experience but aren't essential for the product to work. A user can still code effectively without themes or a status bar. We included these because they were relatively easy to add and make EasyVim feel more polished.

Our MVP goal was simple: **Can a VS Code user open EasyVim and start coding immediately without reading documentation?** The Must Have features make this possible.

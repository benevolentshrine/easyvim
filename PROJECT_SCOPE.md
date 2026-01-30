# TEMPLATE 4: Project Scope Document (SOW)

**Project Title:** EasyVim: The Zero-Friction Neovim config.  
**Team ID / Members:** SY1901 / Hrishikesh Kulkarni, Harsh Singh, Lucky, Sayan Ghoshal

---

## 1. Objective

To create a lightweight, beginner-friendly Neovim configuration that provides a modern IDE experience with familiar keyboard shortcuts (Ctrl+S, Ctrl+C, Ctrl+V), while using minimal system resources (~25MB RAM). The goal is to bridge the gap between powerful terminal editors and user-friendly code editors like VS Code.

---

## 2. In Scope

Features the team will definitely implement:

1. **Familiar Keybindings** — Ctrl+S (save), Ctrl+C (copy), Ctrl+V (paste), Ctrl+Z (undo), Ctrl+F (find file)
2. **File Explorer Sidebar** — Neo-tree integration with keyboard shortcuts for file operations
3. **LSP Support** — Autocompletion, error diagnostics, and go-to-definition via Mason + nvim-lspconfig
4. **Syntax Highlighting** — Treesitter-based highlighting for all major languages
5. **Theme Switcher** — Multiple color schemes (Tokyo Night, Catppuccin, Kanagawa, Gruvbox) with easy switching
6. **Status Bar** — Lualine showing file info, git branch, and mode
7. **Tab Bar** — Bufferline for managing open files
8. **Terminal Toggle** — Built-in terminal accessible via Ctrl+\
9. **Code Runner** — Run Python/JS/C++ files with F5
10. **One-Line Install** — Simple `install.sh` script for Linux/macOS

---

## 3. Out of Scope

Features intentionally excluded from v1:

- **Windows Native Support** — Installer is bash-based; Windows users need WSL
- **DAP Debugging** — Step-through debugging not included (may add in v2)
- **Remote Development** — SSH/container support not implemented
- **AI Copilot Integration** — No AI code completion plugins included
- **Custom Plugin Marketplace** — Users can add plugins manually, but no built-in marketplace

---

## 4. Deliverables (Sprint-wise)

| Sprint | Duration | Planned Deliverables |
| :--- | :--- | :--- |
| **Sprint 1** | Weeks 1–2 | Basic setup: `init.lua`, familiar keybindings (Ctrl+S/C/V/Z), lazy.nvim plugin manager, Neo-tree file explorer. |
| **Sprint 2** | Weeks 3–4 | LSP integration: Mason for language server installation, nvim-cmp for autocompletion, Treesitter for syntax highlighting. |
| **Sprint 3** | Weeks 5–7 | UI polish: Theme switcher with 4 themes, Lualine status bar, Bufferline tabs, terminal toggle, code runner (F5). |
| **Sprint 4** | Weeks 8–9 | Final testing, bug fixes, README documentation, installation script, GitHub release, community feedback collection. |

---

## Summary

EasyVim v1 focuses on delivering a complete, usable Neovim configuration that feels familiar to users coming from GUI editors. Advanced features like debugging and remote development are deferred to future versions to keep scope manageable within the 9-week timeline.

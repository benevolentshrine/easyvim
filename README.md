# ⚡ EasyVim
### The Missing Bridge to the Terminal

> **"Performance should not cost you your intuition."**

EasyVim is a specialized Neovim environment designed to solve the **Hardware Resource Crisis** (Electron Bloat) and the **Learning Curve** of terminal editors. It runs on **35MB of RAM** but behaves like VS Code out of the box.

| Feature | VS Code / Electron | EasyVim |
| :--- | :--- | :--- |
| **Idle RAM** | ~800MB+ | **~35MB** |
| **Startup Time** | ~2-5s | **~50ms** |
| **Ctrl+S / Ctrl+C** | ✅ Native | **✅ Native** (No setup) |
| **Learning Curve** | Flat | **Guided ("Silent Teacher")** |
| **Philosophy** | "Hide the Engine" | **"Teach the Engine"** |

---

## 🧠 The Philosophy

### 1. The Hardware Crisis
Modern editors have become operating systems. Running a simple text editor shouldn't require 1GB of RAM. EasyVim restores the **efficiency of the 90s** with the **UX of 2025**. It allows you to run a full development environment on a Raspberry Pi, a Chromebook, or a vintage ThinkPad without stutter.

### 2. The "Silent Teacher"
Vim is infamous for "trapping" users. EasyVim removes this fear.
- **Intuition First**: `Ctrl+S`, `Ctrl+C`, `Ctrl+Z` work exactly as you expect.
- **Gradual Exposure**: We don't force you to learn hjkl immediately. Use the mouse. Use the arrows. But when you are ready, the native power of Vim is lurking just beneath the surface, waiting for you to discover it.

---

## 📸 Screenshots

*(Add your screenshots to the `assets` folder and link them here)*
<!--
![Silent Teacher](assets/silent_teacher.png)
*The "Silent Teacher" notification guides you gently.*
-->

---

## 📥 Installation

### ⚠️ Prerequisite
We require **Neovim v0.9+**.
If you don't have it, our installers will try to tell you how to get it (or auto-install it on Windows).

### 🐧 Linux / 🍎 MacOS
**Note:** This script will automatically back up your existing `~/.config/nvim` to `~/.config/nvim.bak`.

```bash
git clone https://github.com/benevolentshrine/easyvim.git
cd easyvim
./install.sh
```

### 🪟 Windows (PowerShell)
**Note:** This script detects missing dependencies and can auto-download Neovim for you.

```powershell
cd Desktop
git clone https://github.com/benevolentshrine/easyvim.git
cd easyvim
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

---

## ⌨️ Cheat Sheet

Click the **Shots** button in the top bar to see this anytime.

| Key | Action |
| :--- | :--- |
| **Ctrl+S** | Save File |
| **Ctrl+F** | Find File |
| **Ctrl+Z** | Undo |
| **Ctrl+C** | Copy / Stop Code |
| **Ctrl+V** | Paste |
| **Ctrl+B** | Toggle Sidebar |
| **Ctrl+\** | Toggle Terminal |
| **F5** | Run Code |

---

## 📄 License
MIT License © 2026 benevolentshrine

# EasyVim

> **A lightweight, modern IDE experience built on Neovim where common shortcuts just work.**

EasyVim bridges the gap between the intuition of VS Code and the raw performance of the terminal. It runs on **<35MB of RAM** but behaves like a modern editor out of the box.

---

## ✨ Highlights

*   **🚀 Zero Learning Curve**: `Ctrl+S`, `Ctrl+C`, `Ctrl+V`, `Ctrl+Z` work instantly. No need to relearn muscle memory.
*   **⚡ Blazing Fast**: Startup time **<50ms**. Input latency is instant.
*   **🔋 Efficient**: Runs perfectly on old laptops, Raspberry Pis, or cloud shells (~25MB RAM).
*   **📦 Battery Included**: Comes with a File Explorer (Neo-tree), Terminal Toggles, and Auto-Language Support.

---

## ⚡ Performance Specs

| Metric | EasyVim (Measured) |
| :--- | :--- |
| **Idle RAM** | **~25 MB** |
| **Startup Time** | **< 50ms** |
| **Philosophy** | **"Teach the Engine"** |

---

## 🚀 Quick Start

**Install in 3 steps:**

### Linux / MacOS
```bash
git clone https://github.com/benevolentshrine/easyvim.git
cd easyvim
./install.sh
```

### Windows (PowerShell)
```powershell
cd Desktop
git clone https://github.com/benevolentshrine/easyvim.git
cd easyvim
powershell -ExecutionPolicy Bypass -File .\install.ps1
```

*(Restart your terminal or run `nvim` to start)*

---

## 🎮 Usage & Shortcuts

We map the keys you already know to Neovim's powerful backend.

| Key | Action |
| :--- | :--- |
| **Ctrl+S** | Save File |
| **Ctrl+C** | Copy / Stop Code |
| **Ctrl+V** | Paste |
| **Ctrl+Z** | Undo |
| **Ctrl+F** | Find File |
| **Ctrl+H** | Search Text |
| **Ctrl+B** | Toggle Sidebar |
| **Ctrl+\** | Toggle Terminal |
| **F5** | Run Code (Python, JS, C++, etc.) |

*Click the **Shots** button in the top bar to see this list inside the editor.*

---

## 🧠 The Manual

### **Files & Sidebar**
Press **Ctrl+B** to open the file explorer (Neo-tree).
- **a**: Add a file/folder
- **d**: Delete
- **r**: Rename
- **c**: Copy
- **m**: Move

### **Running Code**
EasyVim detects your language automatically.
- Open a Python/JS/C++ file.
- Press **F5**.
- It runs inside the native terminal.

---

## 📸 Screenshots

<!-- Upload screenshots to 'assets/' folder and uncomment these lines -->
<!-- 
![Dashboard](assets/dashboard.png)
![Sidebar](assets/sidebar.png)
-->

---

## 🧠 Philosophy

### 1. The Hardware Crisis
Modern editors often consume gigabytes of RAM. EasyVim restores the **efficiency of the 90s** with the **UX of 2025**. It allows you to run a full development environment on any hardware without stutter.

### 2. The "Silent Teacher"
Vim is infamous for "trapping" users. EasyVim removes this fear. We don't force you to learn modal editing immediately. Use the mouse, use the arrows. But when you are ready, the native power of Vim is lurking just beneath the surface.

---

## 📄 License

MIT License © 2026 benevolentshrine

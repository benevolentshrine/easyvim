# TEMPLATE 2: Operational & Execution Viability Template

**Project Title:** EasyVim: The Zero-Friction Neovim config.  
**Team ID / Members:** SY1901 / Hrishikesh Kulkarni, Harsh Singh, Lucky, Sayan Ghoshal

---

## 1. Team Structure & Roles

| Member Name | Role | Responsibilities |
| :--- | :--- | :--- |
| **Hrishikesh Kulkarni** | Technical Lead / Core Developer | Architecture design, core Lua module development (`init.lua`, `keymaps.lua`), LSP integration, plugin orchestration, and code reviews. |
| **Sayan Ghoshal** | Backend Developer / Research Lead | Plugin configuration (Telescope, Neo-tree, Treesitter), performance benchmarking, researching Neovim APIs, and testing automation. |
| **Lucky** | Documentation Lead / QA Engineer | Writing technical documentation (README, user guides), creating installation scripts, manual testing, and bug tracking. |
| **Harsh Singh** | UI/UX Developer / Community Manager | Theme development (color schemes, Lualine config), visual asset creation, managing GitHub issues, and gathering community feedback. |

---

## 2. Execution Timeline Feasibility

**Target Duration:** 4 Sprints (9 weeks)

| Sprint | Duration | Goals | Status |
| :--- | :--- | :--- | :--- |
| **Sprint 1** | Weeks 1-2 | Core setup: `init.lua`, basic keymaps (Ctrl+S, Ctrl+C, Ctrl+V), lazy.nvim integration, Neo-tree sidebar. | ✅ Complete |
| **Sprint 2** | Weeks 3-4 | LSP & Autocompletion: Mason setup, nvim-lspconfig, nvim-cmp, Treesitter for syntax highlighting. | ✅ Complete |
| **Sprint 3** | Weeks 5-7 | UX Polish: Theme switcher (Catppuccin, Kanagawa, Tokyonight), Lualine status bar, Bufferline tabs, terminal toggle. | ✅ Complete |
| **Sprint 4** | Weeks 8-9 | Final testing, documentation, GitHub release, community outreach (r/neovim post), bug fixes. | 🔄 In Progress |

### Justification:

> **Yes, the project can be completed in 4 sprints.**  
> The core functionality (keybindings, LSP, file explorer) is already implemented and tested. The remaining work involves documentation, visual polish, and community feedback integration. The modular nature of Neovim/Lua development allows parallel workstreams—technical members (Hrishikesh, Sayan) can handle code while non-technical members (Lucky, Harsh) focus on documentation and outreach simultaneously.

---

## 3. Resource Requirements

| Resource Type | Description | Availability | Cost | Alternatives |
| :--- | :--- | :--- | :--- | :--- |
| **Hardware** | Development machines (laptops with Linux/macOS). | ✅ Available (team-owned) | ₹0 | |
| **Software** | Neovim (>=0.9.0), Git, Terminal Emulator (Kitty/Alacritty). | ✅ Available (Open-source) | ₹0 | N/A – All software is free and open-source. |
| **Tools** | GitHub (version control, issues, releases), Antigravity IDE (AI-assisted coding), OpenWork Agentic Development (workflow automation), Strix Debugger (debugging). | ✅ Available (Free/Institutional) | ₹0 | GitLab, standard debuggers. |
| **Data** | EasyVim codebase itself (`lua/core/*.lua`, `init.lua`, `lua/plugins/*.lua`) for self-hosted testing; `generate_graph.py` and `pyrunner.py` for Python validation. | ✅ Available (project repo) | ₹0 | N/A – Uses own source code. |

---

## 4. Operational Constraints

| Constraint | Impact | Mitigation Strategy |
| :--- | :--- | :--- |
| **Learning Curve** | Some team members are new to Lua and Neovim, so understanding the codebase took extra time. | Started with simpler tasks first; used online tutorials and Neovim documentation to learn together. |
| **College Schedule** | Exams and assignments reduced the time we could spend on the project during certain weeks. | Planned sprints around exam schedules; worked more during breaks and weekends. |
| **Limited Devices** | We mostly have Linux laptops; couldn't test much on macOS. | Asked classmates with Macs to try the install script and report issues. |
| **Feature Requests** | Once we shared early demos, friends kept asking for more features which distracted from core work. | Made a list of "v2 ideas" to revisit later; focused only on essentials for now. |
| **Documentation** | Writing good docs is harder than expected and often got delayed. | Assigned one person (Lucky) to focus mainly on documentation so it doesn't fall behind. |

---

## Summary

The project is **operationally viable** with the current team structure. Technical work is concentrated with Hrishikesh and Sayan, while Lucky and Harsh contribute through documentation, testing, and community engagement. The 9-week timeline is achievable given that core features are already implemented. Resource requirements are minimal (all tools are free/open-source), and operational constraints have clear mitigation strategies.

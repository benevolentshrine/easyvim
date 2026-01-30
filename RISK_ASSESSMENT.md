# TEMPLATE 6: Risk Assessment Matrix

**Project Title:** EasyVim: The Zero-Friction Neovim config.  
**Team ID / Members:** SY1901 / Hrishikesh Kulkarni, Harsh Singh, Lucky, Sayan Ghoshal

---

## Risk Assessment Matrix

| Risk Category | Description | Probability | Impact | Mitigation Plan |
| :--- | :--- | :--- | :--- | :--- |
| **Technical Risk** | Neovim API changes could break plugin compatibility in future versions. | Low | Medium | Pin plugin versions in `lazy-lock.json`; test with stable Neovim releases only. |
| **Technical Risk** | LSP servers may not install correctly on all systems due to missing dependencies. | Medium | Medium | Use Mason which handles dependencies automatically; document common issues in README. |
| **Resource Risk** | Limited access to macOS devices for testing. | Medium | Low | Ask classmates with Macs to test; focus primarily on Linux where most team members work. |
| **Resource Risk** | Internet required for initial plugin download. | Low | Low | Document this requirement clearly; plugins are cached after first install. |
| **Team Risk** | Some members are new to Lua, may need time to understand codebase. | Medium | Low | Started with simpler tasks; shared learning resources and did informal code walkthroughs. |
| **Team Risk** | Exams and assignments could delay progress during certain weeks. | High | Medium | Planned sprints around academic calendar; set flexible internal deadlines. |
| **Timeline Risk** | Feature scope could expand if we keep adding "nice to have" features. | Medium | High | Created a strict v1 feature list; logged all extra ideas in a "v2 roadmap" document. |
| **Timeline Risk** | Documentation often gets delayed until the end. | High | Medium | Assigned Lucky as dedicated documentation person; wrote docs alongside development. |
| **External Dependency** | Dependent on third-party plugins (lazy.nvim, Telescope, etc.) being maintained. | Low | High | Chose only popular, actively maintained plugins with large communities. |
| **External Dependency** | GitHub could have outages affecting collaboration. | Low | Low | Used local Git commits; GitHub outages are rare and short. |

---

## Risk Summary

Most risks are **Low to Medium** probability. The highest impact risks are related to timeline (scope creep) and external dependencies (plugin maintenance), but both are well-mitigated. We chose stable, popular plugins and maintained a strict feature list to avoid delays. Team-related risks like exams were expected and planned around from the start.

Overall, the project has a **low risk profile** suitable for a student team working within a 9-week timeline.

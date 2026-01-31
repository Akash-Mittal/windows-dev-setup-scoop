# Windows Dev Setup with Scoop 🪄  
*(or: Because Windows Deserves Better)*

Welcome to the script that magically equips your Windows PC with developer tools using **Scoop** — the package manager that tries to keep popup dialogs and admin nags to a minimum. It’s like chocolate for your terminal — sweet, but way less messy than Chocolatey 🍫.

This PowerShell script automates your Windows dev environment setup using Scoop (which is like Homebrew for Windows nerds) — installing things you probably need and configuring stuff so you don’t have to say **“How do I install this again?”** ever.

---

## 🛠️ What It Does

- Installs Scoop if it’s not already present  
- Adds useful buckets (because `"main"` isn’t enough)  
- Installs a bunch of developer tools and utilities  
- Optionally does some environmental tweaks  
- Makes you wonder why you ever manually installed anything ever again  

📌 **Hint:** Scoop installs everything into your user folder and tries hard not to bother you with UAC prompts — it’s nice like that.

---

## 🚀 Quick Setup

Just open **PowerShell (not as Administrator)** and run:

```powershell
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
./windows-dev-env-setup-with-scoop.ps1


🧑‍💻 Development Tools
| Software                        | What It’s Used For                                                                  |
| ------------------------------- | ----------------------------------------------------------------------------------- |
| **Git**                         | Version control for tracking code changes and regrettable commits.                  |
| **OpenJDK 21**                  | Java Development Kit. Required to compile, run, and complain about Java apps.       |
| **Maven**                       | Java build and dependency management tool that downloads half the internet for you. |
| **Node.js (LTS)**               | Stable JavaScript runtime for frontend tools and backend services.                  |
| **NVM**                         | Node Version Manager — switch Node versions without uninstalling your soul.         |
| **IntelliJ IDEA Ultimate**      | Full-powered IDE for Java, Spring, and “this project is huge” moments.              |
| **Google Cloud SDK (`gcloud`)** | CLI for managing Google Cloud resources like a responsible adult.                   |

📊 APIs, Databases & Testing
| Software                      | What It’s Used For                                                    |
| ----------------------------- | --------------------------------------------------------------------- |
| **Yarn**                      | JavaScript package manager. Faster installs, fewer tantrums.          |
| **MongoDB Database Tools**    | CLI tools for backups, restores, imports, and exports.                |
| **MongoDB Shell (`mongosh`)** | Modern MongoDB shell for querying databases interactively.            |
| **MongoDB Compass**           | GUI for MongoDB — because sometimes you want to *see* the data.       |
| **Postman**                   | API testing tool for poking endpoints until they behave.              |
| **Insomnia**                  | Lightweight alternative to Postman, for people who prefer minimalism. |
| **Apache JMeter**             | Load and performance testing — find bottlenecks before users do.      |
☁️ DevOps & Cloud
| Software           | What It’s Used For                                                                        |
| ------------------ | ----------------------------------------------------------------------------------------- |
| **Docker Desktop** | Run containers locally so “works on my machine” actually means something.                 |
| **Terraform**      | Infrastructure as Code — break cloud environments predictably and repeatedly.             |
| **Cloudflared**    | Secure tunnels and Cloudflare access without exposing your machine to the internet chaos. |
🧰 Utilities & Productivity
| Software              | What It’s Used For                                                  |
| --------------------- | ------------------------------------------------------------------- |
| **GitHub CLI (`gh`)** | Manage GitHub repos, PRs, and issues without opening a browser tab. |
| **FileZilla**         | FTP/SFTP client for transferring files the old-school way.          |
| **AutoHotkey**        | Windows automation and hotkeys. Make your keyboard do tricks.       |
| **7-Zip**             | Compress and extract files of almost any format known to humanity.  |

🖥️ Everyday Apps (Because Devs Are Humans Too)
| Software             | What It’s Used For                                                              |
| -------------------- | ------------------------------------------------------------------------------- |
| **Google Chrome**    | Web browsing, debugging, and having 47 tabs open.                               |
| **ChatGPT**          | AI assistant for debugging, explaining errors, and rubber-ducking code.         |
| **Zoom**             | Meetings that could’ve been emails.                                             |
| **VLC Media Player** | Plays literally any media file you throw at it.                                 |
| **LibreOffice**      | Office suite for documents, spreadsheets, and pretending you like spreadsheets. |
| **OpenShot**         | Video editing for quick demos, tutorials, or accidental YouTube careers.        |

🪟 Windows Store Installations (via Winget)
| App                  | Purpose                                                 |
| -------------------- | ------------------------------------------------------- |
| **Docker Desktop**   | Installed via Winget for better Windows integration.    |
| **Windows Terminal** | Modern terminal experience that doesn’t feel like 2003. |

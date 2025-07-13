# Super Minimalistic Neovim UI Setup for C and JavaScript

## Features

- Lightweight and fast
- Pre-configured for C and JavaScript
- Essential keybindings for productivity
- Easy to install and run

## Keybindings (Normal Mode)

| Shortcut       | Action          |
|----------------|-----------------|
| `<space> + s`  | Save file       |
| `<space> + e`  | Exit Neovim     |
| `<space> + t`  | Toggle terminal |
| `<space> + f`  | File tree       |

> 🔧 Keybinding settings can be found in `./init.lua`.

## Plugin Setup

All plugin configurations are managed using [**Lazy.nvim**](https://github.com/folke/lazy.nvim).

> 📦 Plugin settings are located in `./lua/plugins.lua`.

## Installation

> **Note:** This setup is designed for Linux systems.

1. Clone the repo to your Neovim config directory:
    ```bash
    git clone <repo-url> ~/.config/nvim
    ```

2. Launch Neovim:
    ```bash
    nvim
    ```

3. The **Lazy.nvim** plugin manager will automatically pop up and install the required plugins.

4. You're ready to go!

## Supported Languages

- **C**
- **JavaScript**

> More languages can be added easily with minimal configuration.

---

Feel free to customize the keybindings or plugins further based on your needs.

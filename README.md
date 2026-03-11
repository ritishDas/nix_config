# nix_config

![Nix](https://img.shields.io/badge/Nix-43.3%25-informational)
![Lua](https://img.shields.io/badge/Lua-41.4%25-blue)
![CSS](https://img.shields.io/badge/CSS-15.3%25-orange)

My entire system configuration and dotfiles, built and refined over the years.

## Overview

This repository contains my complete NixOS system configuration, including all dotfiles and customizations that have been developed and improved incrementally over time. It's a fully declarative setup using NixOS, with extensive program configurations written in Lua and CSS styling.

## Repository Structure

```
.
├── configuration.nix          # Main NixOS system configuration
├── hardware-configuration.nix # Hardware-specific settings
├── home.nix                   # Home Manager configuration
├── flake.nix                  # Nix Flakes configuration
├── flake.lock                 # Flake dependencies lock file
├── core/                      # Core system modules and utilities
├── configs/                   # Application configuration files
├── programs/                  # Program-specific configurations
├── services/                  # System services configuration
├── fonts/                     # Custom fonts and font configurations
├── icons/                     # Icon theme and customizations
├── LICENSE                    # License file
```

### Directory Details

- **core/** - Contains core system modules and utilities used across configurations
- **configs/** - Application-specific configuration files and dotfiles
- **programs/** - Detailed configurations for various programs and applications
- **services/** - System services and daemon configurations
- **fonts/** - Custom fonts and font-related configurations
- **icons/** - Icon themes and icon set customizations

## Language Composition

This project uses:
- **Nix** (43.3%) - System configuration and package management
- **Lua** (41.4%) - Application configuration and scripting
- **CSS** (15.3%) - UI styling and theming

## Features

- ✅ Complete NixOS system configuration
- ✅ Home Manager integration for user environment
- ✅ Declarative package management
- ✅ Modular configuration structure
- ✅ Custom fonts and icon themes
- ✅ Service definitions and system utilities
- ✅ Lua-based program configurations

## Getting Started

### Prerequisites

- NixOS operating system
- Nix Flakes enabled
- Git

### Installation

1. Clone this repository:
   ```bash
   git clone https://github.com/ritishDas/nix_config.git
   cd nix_config
   ```

2. Adjust `hardware-configuration.nix` for your specific hardware

3. Rebuild your NixOS configuration:
   ```bash
   sudo nixos-rebuild switch --flake .#
   ```

4. For Home Manager setup:
   ```bash
   home-manager switch --flake .#
   ```

## Configuration

- Edit `configuration.nix` for system-wide settings
- Edit `home.nix` for user-specific configurations
- Modify files in `programs/`, `services/`, and `configs/` directories as needed
- Update `flake.nix` to manage dependencies

## License

See the [LICENSE](LICENSE) file for details.

## Author

[ritishDas](https://github.com/ritishDas)

---

**Note**: This configuration is tailored to my system setup. Feel free to adapt and customize it for your own use, but some paths and settings may need adjustment for your specific hardware and preferences.

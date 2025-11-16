# nix_config

This repository contains my Nix configuration (NixOS / Home Manager) managed via **Nix flakes**. It’s a modular, reproducible, and personal setup for my systems.

---

## 💡 Overview

* Uses **flake.nix** + **flake.lock** for reproducibility.
* Contains configurations for system, user/home, services, fonts, icons, and more.
* Fully modular: different parts of config are cleanly split into directories:

  * `configs/` — custom configuration fragments / modules
  * `core/` — core system-level definitions
  * `fonts/`, `icons/` — assets declarations
  * `programs/` — user programs / package definitions
  * `services/` — NixOS or user services
* Includes NixOS `configuration.nix`, `hardware-configuration.nix`, and a `home.nix` home-manager config.

---

## 📦 Prerequisites

To use this configuration, you need:

* **Nix** installed (version 2.4+ recommended).

* A Git clone of this repository on your machine.

---

## 🚀 Usage

Here are some common workflows you might use with this repo:
### Replace hardware-configuration.nix

Delete my hardware-configuration.nix and copy your system's hardware-configuration.nix in it's place, hardware-configuration.nix is in /etc/nixos directory on a nixos system.

### Rebuild / Switch NixOS Configuration

```bash
sudo nixos-rebuild switch --flake .#<hostname>
```

Replace `<hostname>` with your system name as configured in your `flake.nix` (or however you're naming your system configurations).



## 📁 Directory Structure

Here’s a high-level look at the main directories and files:

```
.
├── configs/                   # Modular Nix config fragments
├── core/                      # Core definitions (e.g. system-wide modules)
├── fonts/                     # Custom font declarations
├── icons/                     # Icon definitions / themes
├── programs/                  # Program-level package / config definitions
├── services/                  # Services (system or user)
├── configuration.nix          # NixOS system config
├── hardware-configuration.nix # Auto-generated hardware config
├── home.nix                    # Home Manager / user config
├── flake.nix                   # Flake entry point
└── flake.lock                  # Locked inputs for reproducibility
```

---

## ✅ Why This Setup

* **Reproducibility**: By using flakes, the entire environment is pinned and versioned. ([wiki.nixos.org][1])
* **Modularity**: Breaking the config into logical directories makes it easier to maintain and extend.
* **Portability**: You can use the same flake across multiple machines (if structured accordingly).
* **Customization**: Easily add or tweak packages, services, fonts, and more in a structured way.

---

## ⚠️ Caution / Notes

* Flakes are still **experimental**. Be aware of their limitations and changes in future Nix versions. ([wiki.nixos.org][1])
* Avoid putting **unencrypted secrets** in flake files, since they may be copied into the Nix store. ([wiki.nixos.org][1])
* Make sure all relevant files are **tracked by Git**; untracked files won’t be included when your flake is evaluated. ([Reddit][2])

---

## 🧪 Contributing / Extending

* Feel free to fork / clone this repository as a base for your own Nix config.
* To add a new service, create a file under `services/` and import it into your `flake.nix`.
* To add custom packages or overlays, use `programs/` or extend the `inputs` in `flake.nix`.

---

## 📚 Resources & References

* [NixOS Wiki: Flakes](https://nixos.wiki/wiki/Flakes) — Good overview of the flake concept, structure, and usage. ([nixos.wiki][3])
* [Beginner-friendly Flake Tutorial](https://mhwombat.codeberg.page/nix-book/) — Great for understanding flake basics and real-world usage. ([GitHub][4])
* [Nix.dev – Flakes chapter](https://nix.dev) — Deep dive into how flakes work under the hood. ([Nix][5])

---

## Thanks to 

I have refered to following repositories for writing this config Thank's to them 

* [Gaurav's Hyprland Config](https://github.com/gaurav23b/simple-hyprland)
* [Fufexan's Nixos Config](https://github.com/fufexan/nixos-config)

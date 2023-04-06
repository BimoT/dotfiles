# Dotfiles

![Screenshot](https://raw.githubusercontent.com/BimoT/dotfiles/main/.config/.dotfiles-github-assets/screenshot1.png)

This is my **personal configuration**! This is not intended to be copy-pasted and used as your own DE or something like that. Use at your own risk, I guess.

Also, this is a **work in progress**, continually.

## Dependencies

- [Awesome](https://github.com/awesomeWM/awesome) as the window manager
    - I use the version in the Arch Linux repository, *not* the newest version. I might update later. 
    - The configuration of Awesome is still unfinished. See the `todo.md` inside of the `.config/awesome/` folder for a list of things that still need to be done.
    - The configuration is highly inspired by [elenapan's](https://github.com/elenapan/dotfiles/) incredible dotfiles
- [Neovim](https://github.com/neovim/neovim) as my text editor
- [Rofi](https://github.com/davatorium/rofi) as the applauncher
- [Chicago95](https://github.com/grassmunk/Chicago95) for the icons, font, and gtk theme
    - Icons should be placed in `~/.icons/`, theme should be placed in `~/.themes/`, just follow the manual install instructions in the github page
    - **IMPORTANT**: one more icon is needed for the brightness, shown when Redshift is active. Create one yourself and refer to it in the awesome95.lua file
- [Nerd Fonts](https://github.com/ryanoasis/nerd-fonts) for other fonts
- [Alacritty](https://github.com/alacritty/alacritty) as my terminal emulator
- [Redshift](https://github.com/jonls/redshift) for blue light filtering
- [Brillo](https://github.com/CameronNemo/brillo) for smoother, natural brightness control
- [Thunar](https://docs.xfce.org/xfce/thunar/start) as the file manager
- [lf](https://github.com/gokcehan/lf) as terminal file manager
- [i3lock-color](https://github.com/Raymo111/i3lock-color) as lockscreen
- [Flameshot](https://github.com/flameshot-org/flameshot) for taking screenshots
- [Network-manager-applet](https://gitlab.gnome.org/GNOME/network-manager-applet) for wifi management

Most of these dependencies were installed through the Arch Linux repository, or the AUR.

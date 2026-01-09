#!/bin/bash

# Script de instalação do Hyprland no Arch Linux
# Autor: Auto-gerado
# Data: $(date)

# Cores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Função para imprimir mensagens coloridas
print_message() {
    echo -e "${GREEN}[+]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[ERROR]${NC} $1"
}

# Verificar se é root
if [[ $EUID -eq 0 ]]; then
    print_error "Não execute este script como root!"
    print_warning "Ele solicitará a senha de sudo quando necessário."
    exit 1
fi

# Verificar se estamos no Arch Linux
if ! grep -q "Arch Linux" /etc/os-release 2>/dev/null; then
    print_error "Este script é apenas para Arch Linux!"
    exit 1
fi

# Atualizar sistema
print_message "Atualizando o sistema..."
sudo pacman -Syu --noconfirm

# Instalar Hyprland e componentes básicos
print_message "Instalando Hyprland e componentes Wayland..."
sudo pacman -S --needed --noconfirm \
    hyprland \
    waybar \
    kitty \
    alacritty \
    tmux \
    neovim \
    dunst \
    xdg-desktop-portal-hyprland \
    xdg-desktop-portal-gtk \
    grim \
    slurp \
    wl-clipboard \
    swaybg \
    swaylock \
    wlogout \
    polkit-kde-agent

# Instalar fontes recomendadas
print_message "Instalando fontes..."
sudo pacman -S --noconfirm \
    ttf-font-awesome \
    ttf-jetbrains-mono \
    ttf-nerd-fonts-symbols \
    noto-fonts \
    noto-fonts-cjk \
    noto-fonts-emoji

# Instalar utilitários úteis
print_message "Instalando utilitários adicionais..."
sudo pacman -S --noconfirm \
    fish \
    zsh \
    bash \
    fzf \
    ripgrep \
    fd \
    bat \
    exa \
    htop \
    btop \
    fastfetch \
    git \
    curl \
    wget \
    rsync \
    unzip \
    zip

# Instalar gerenciador de exibição (opcional - escolha um)
print_message "Instalando gerenciador de exibição (SDDM)..."
sudo pacman -S --noconfirm sddm sddm-kcm

# Habilitar SDDM
print_message "Habilitando SDDM..."
sudo systemctl enable sddm

# Criar diretórios de configuração
print_message "Criando diretórios de configuração..."
mkdir -p ~/.config/hypr
mkdir -p ~/.config/waybar
mkdir -p ~/.config/kitty
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/dunst
mkdir -p ~/.config/nvim

# Criar configuração básica do Hyprland
print_message "Criando configuração básica do Hyprland..."
cat > ~/.config/hypr/hyprland.conf << 'EOF'
# Configuração básica do Hyprland

# Monitor (ajuste conforme seu hardware)
monitor=,preferred,auto,1

# Executar na inicialização
exec-once = waybar
exec-once = dunst
exec-once = /usr/lib/polkit-kde-authentication-agent-1
exec-once = swaybg -i ~/wallpaper.jpg

# Teclado
input {
    kb_layout = br
    follow_mouse = 1
    touchpad {
        natural_scroll = true
    }
}

# Geral
general {
    # gaps_in = 5
    gaps_in = 2
    # gaps_out = 10
    gaps_out = 2
    # border_size = 2
    # col.active_border = rgba(33ccffee) rgba(00ff99ee) 45deg
    # col.inactive_border = rgba(595959aa)
    border_size = 1
    col.active_border = rgba(888888ff)  # gray border when window is active
    col.inactive_border = rgba(444444ff)  # darker gray when inactive
    
    layout = dwindle
}

# Decorações
decoration {
    # rounding = 10
    rounding = 2
    blur = yes
    blur_size = 3
    blur_passes = 1
    drop_shadow = yes
    shadow_range = 4
    shadow_render_power = 3
    col.shadow = rgba(1a1a1aee)
}

# Animations
animations {
    enabled = yes
    bezier = myBezier, 0.05, 0.9, 0.1, 1.05
    animation = windows, 1, 7, myBezier
    animation = windowsOut, 1, 7, default, popin 80%
    animation = border, 1, 10, default
    animation = fade, 1, 7, default
    animation = workspaces, 1, 6, default
}

# Layout
dwindle {
    pseudotile = yes
    preserve_split = yes
}

master {
    new_is_master = true
}

# Gestures
gestures {
    workspace_swipe = on
}

# Janelas
windowrule = float,^(pavucontrol)$
windowrule = float,^(blueman-manager)$

# Atalhos
bind = SUPER,Shift, Q, killactive,
bind = SUPER, M, exit,
bind = SUPER, V, togglefloating,
bind = SUPER, Return, exec, kitty
# bind = SUPER, C, exec, code
bind = SUPER, B, exec, firefox
bind = SUPER, D, exec, wofi --show drun
bind = SUPER, P, exec, grim -g "$(slurp)" - | wl-copy

# Workspaces
bind = SUPER, 1, workspace, 1
bind = SUPER, 2, workspace, 2
bind = SUPER, 3, workspace, 3
bind = SUPER, 4, workspace, 4
bind = SUPER, 5, workspace, 5

# Movimentação entre workspaces
bind = SUPER SHIFT, 1, movetoworkspace, 1
bind = SUPER SHIFT, 2, movetoworkspace, 2
bind = SUPER SHIFT, 3, movetoworkspace, 3
bind = SUPER SHIFT, 4, movetoworkspace, 4
bind = SUPER SHIFT, 5, movetoworkspace, 5
EOF

# Configuração básica do Waybar
print_message "Criando configuração básica do Waybar..."
cat > ~/.config/waybar/config << 'EOF'
{
    "layer": "top",
    "position": "top",
    "height": 24,
    "spacing": 5,

    "modules-left": ["hyprland/workspaces"],
    "modules-center": ["clock"],
    "modules-right": ["wireplumber", "hyprland/language", "idle_inhibitor", "network", "tray"],

    "hyprland/workspaces": {
        "format": "<span size='larger'>{icon}</span>",
        "on-click": "activate",
        "format-icons": {
            "active": "\uf444",
            "default": "\uf4c3"
        },
        "icon-size": 10,
        "sort-by-number": true,
        "persistent-workspaces": {
            "1": [],
            "2": [],
            "3": [],
            "4": [],
            "5": [],
        }
    },

    "clock": {
        "format": "{:%d.%m | %H:%M}"
    },

    "wireplumber": {
        "format": "\udb81\udd7e  {volume}%",
        "max-volume": 100,
        "scroll-step": 5
    },

    "memory": {
        "interval": 30,
        "format": "\uf4bc  {used:0.1f}G"
    },

    "network": {
        "format": "",
        "format-ethernet": "\udb83\udc9d",
        "format-wifi": "{icon}",
        "format-disconnected": "\udb83\udc9c",
        "format-icons": ["\udb82\udd2f", "\udb82\udd1f", "\udb82\udd22", "\udb82\udd25", "\udb82\udd28"],
        "tooltip-format-wifi": "{essid} ({signalStrength}%)",
        "tooltip-format-ethernet": "{ifname}",
        "tooltip-format-disconnected": "Disconnected",
    },

    "bluetooth": {
        "format": "\udb80\udcaf",
        "format-disabled": "\udb80\udcb2",
        "format-connected": "\udb80\udcb1",
        "tooltip-format": "{controller_alias}\t{controller_address}",
        "tooltip-format-connected": "{controller_alias}\t{controller_address}\n\n{device_enumerate}",
        "tooltip-format-enumerate-connected": "{device_alias}\t{device_address}"
    },

    "hyprland/language": {
        "format": "{short}"
    },

    "tray": {
        "icon-size": 16,
        "spacing": 16
    },

    "custom/platform-profile": {
	"format": "{icon} ",
	"exec": "~/.config/waybar/platform_profile.sh",
	"return-type": "json",
	"restart-interval": 1,
	"format-icons": {
	    "quiet": "\udb80\udf2a",
	    "balanced": "\udb80\ude10",
	    "performance": "\uf427",
            "default": "?"
	},
    },

    "idle_inhibitor": {
        "format": "{icon}",
        "format-icons": {
            "activated": "\udb80\udd76",
            "deactivated": "\udb83\udfaa"
        }
    }
}
EOF

cat > ~/.config/waybar/style.css << 'EOF'
@define-color foreground #eeeeee;
@define-color foreground-inactive #aaaaaa;
@define-color background #000000;

* {
    font-family: "UbuntuMono Nerd Font", monospace;
    font-size: 17px;
    padding: 0;
    margin: 0;
}

#waybar {
    color: @foreground;
    background-color: @background;
}

#workspaces button {
    color: @foreground;
    padding-left: 0.7em;
}

#workspaces button.empty {
    color: @foreground-inactive;
}

#memory,
#custom-platform-profile {
    padding-left: 1em
}

#wireplumber,
#battery,
#idle_inhibitor,
#language,
#network,
#bluetooth,
#tray {
    padding-right: 1em 
}
EOF

# Configuração básica do Kitty
print_message "Criando configuração básica do Kitty..."
cat > ~/.config/kitty/kitty.conf << 'EOF'
font_family      JetBrains Mono
font_size        12
background_opacity 0.9
confirm_os_window_close 0
enable_audio_bell no
EOF

# Configuração básica do Dunst
print_message "Criando configuração básica do Dunst..."
cat > ~/.config/dunst/dunstrc << 'EOF'
[global]
    monitor = 0
    follow = keyboard
    geometry = "300x5-30+20"
    indicate_hidden = yes
    shrink = no
    transparency = 10
    notification_height = 0
    separator_height = 2
    padding = 8
    horizontal_padding = 8
    frame_width = 3
    sort = yes
    idle_threshold = 120
    font = JetBrains Mono 10
    line_height = 0
    markup = full
    format = "<b>%s</b>\n%b"
    alignment = left
    show_age_threshold = 60
    word_wrap = yes
    ellipsize = middle
    ignore_newline = no
    stack_duplicates = true
    hide_duplicate_count = false
    show_indicators = yes
    icon_position = left
    max_icon_size = 32
    sticky_history = yes
    history_length = 20
    browser = /usr/bin/firefox -new-tab
    always_run_script = true
    title = Dunst
    class = Dunst

[urgency_low]
    background = "#222222"
    foreground = "#888888"
    timeout = 10

[urgency_normal]
    background = "#285577"
    foreground = "#ffffff"
    timeout = 10

[urgency_critical]
    background = "#900000"
    foreground = "#ffffff"
    timeout = 0
EOF

# Instalar plugins básicos para Neovim
print_message "Configurando Neovim..."
cat > ~/.config/nvim/init.vim << 'EOF'
" Configuração básica do Neovim
-- Set leader key
vim.g.mapleader = " "

-- Enable line numbers and relative line numbers
vim.opt.number = true
vim.opt.relativenumber = true

-- Enable syntax highlighting and filetype detection
vim.cmd("syntax enable")
vim.cmd("filetype plugin indent on")

-- Better tab/indentation settings
vim.opt.tabstop = 4        -- Number of spaces a tab counts for
vim.opt.shiftwidth = 4     -- Size of an indent
vim.opt.expandtab = true   -- Use spaces instead of tabs
vim.opt.smartindent = true -- Smart autoindenting

-- UI enhancements
vim.opt.termguicolors = true -- Enable 24-bit RGB colors
vim.opt.cursorline = true    -- Highlight current line
vim.opt.scrolloff = 8        -- Keep lines above/below cursor
vim.opt.signcolumn = "yes"   -- Always show sign column

-- Disable swap and backup files
vim.opt.swapfile = false
vim.opt.backup = false

-- Enable mouse support
vim.opt.mouse = "a"

-- Set color scheme (you can change this to any installed theme)
vim.cmd("colorscheme wildcharm")  -- Built-in theme; replace with your favorite

-- Enable clipboard support (if system supports it)
vim.opt.clipboard = "unnamedplus"
vim.o.showtabline = 2
EOF

# Instalar yay (AUR helper) se não existir
if ! command -v yay &> /dev/null; then
    print_message "Instalando yay (AUR helper)..."
    sudo pacman -S --needed --noconfirm git base-devel
    git clone https://aur.archlinux.org/yay.git /tmp/yay
    cd /tmp/yay
    makepkg -si --noconfirm
    cd ~
fi

# Instalar alguns pacotes opcionais do AUR
print_message "Deseja instalar pacotes adicionais do AUR? (y/N)"
read -r response
if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]; then
    print_message "Instalando pacotes do AUR..."
    yay -S --noconfirm \
        hyprpaper \
        nvim-packer-git \
        visual-studio-code-bin \
        spotify
fi

# Configuração do tmux
print_message "Configurando tmux..."
cat > ~/.tmux.conf << 'EOF'
set -ga terminal-overrides ",screen-255color*:Tc"
set-option -g default-terminal "screen-256color"
set -s escape-time 0

unbind C-b
#set-option -g prefix C-a
#bind-key C-a send-prefix
#set-option -g prefix C-space
#bind-key C-space send-prefix
set-option -g prefix C-c
bind-key C-c send-prefix
set -g status-style 'bg=#1a1a1a fg=#cccccc'

bind r source-file ~/.config/tmux/tmux.conf
set -g base-index 1

set-window-option -g mode-keys vi
bind -T copy-mode-vi v send-keys -X begin-selection
bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel 'xclip -in -selection clipboard'

# vim-like pane switching
bind -r ^ last-window
bind -r k select-pane -U
bind -r j select-pane -D
bind -r h select-pane -L
bind -r l select-pane -R

# Horizontal pane - Ctrl+a " (default behavior)
bind '"' split-window -v

# Vertical pane - Ctrl+a v (your request)
bind v split-window -h

# ===== FUZZY FINDER PARA PROJETOS/PASTAS =====

# f - Buscar projetos/pastas e abrir na janela atual (Ctrl+a f)
bind f display-popup -h 70% -w 85% -E "\
  selected=\$(find ~/ ~/Documents ~/projetos ~/dev ~/workspace -type d -maxdepth 3 2>/dev/null \
    | fzf --reverse --height 100% \
    --preview='ls -la {}' \
    --header='󰝰  Projects and files' \
    --prompt='󰍉  Search > '); \
  if [ -n \"\$selected\" ]; then \
    tmux rename-window \"\$(basename \"\$selected\")\"; \
    tmux send-keys \"cd \\\"\$selected\\\"\" C-m C-l; \
  fi"

# s - Seu sessionizer original (se ainda quiser mantê-lo)
bind s display-popup -h 70% -w 85% -E "tmux neww ~/.local/bin/tmux-sessionizer"

# o - Apenas abrir pasta em nova janela (sem criar sessão)
#bind o display-popup -h 70% -w 85% -E "\
  selected=\$(find ~/ -type d 2>/dev/null | fzf --reverse --height 100% \
    --preview='ls -la {}' \
    --header='󰝰  Open in another tab'); \
  if [ -n \"\$selected\" ]; then \
    tmux new-window -c \"\$selected\"; \
  fi"

# o - Abrir pasta em nova janela E renomear a janela
bind o display-popup -h 70% -w 85% -E "\
  selected=\$(find ~/ -type d 2>/dev/null | fzf --reverse --height 100% \
    --preview='ls -la {}' \
    --header='󰝰  Open in another TAB'); \
  if [ -n \"\$selected\" ]; then \
    window_name=\$(basename \"\$selected\"); \
    tmux new-window -c \"\$selected\" -n \"\$window_name\"; \
  fi"
EOF

# Mensagem final
print_message "Instalação concluída!"
print_warning "Reinicie o sistema ou execute: sudo systemctl start sddm"
echo ""
print_message "Configurações criadas em:"
echo "  ~/.config/hypr/hyprland.conf"
echo "  ~/.config/waybar/"
echo "  ~/.config/kitty/"
echo "  ~/.config/dunst/"
echo "  ~/.config/nvim/"
echo ""
print_warning "Edite os arquivos de configuração conforme necessário!"
print_warning "Adicione um wallpaper em ~/wallpaper.jpg ou edite o hyprland.conf"

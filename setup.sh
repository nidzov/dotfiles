#!/usr/bin/env bash

sudo -v # sk for admin credentials

apps=(
    bat
    clang
    curl
    docker
    entr
    fd
    gcc-c++
    git
    git-delta
    lld
    mold
    neovim
    nodejs22
    pandoc
    python3-pip
    ripgrep
    ShellCheck
    shfmt
    translate-shell
    wg-info
    zsh
)

sudo zypper install -y "${apps[@]}" || true

# Install NordVPN

sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)
/usr/bin/nordvpn set notify off

#############################
## Install Python Packages ##

Check if pip3 is installed
if type "pip3" &>/dev/null; then
    pip3 install --break-system-packages --user yt-dlp
fi

##################
## Install Docker ##

sudo groupadd docker
sudo usermod -aG docker "$USER"
newgrp docker
sudo systemctl enable docker --now
sudo systemctl restart docker
docker run hello-world

##################
## Install font ##

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts || return
git sparse-checkout add patched-fonts/Hack
./install.sh Hack
cd "$HOME" || return
rm -rf nerd-fonts

#################
## Install fzf ##

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --all

####################
## Install nodejs ##

npm config set prefix "$HOME/.local"
npm i -g bash-language-server neovim

#####################
## Install VS Code ##

# Check if code is installed
if ! type "code" &>/dev/null; then
    sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
    sudo zypper addrepo https://packages.microsoft.com/yumrepos/vscode vscode
    sudo zypper refresh
    sudo zypper install code
fi

# Install VS Code extensions
if type "code" &>/dev/null; then
    extensions=(
        albert.tabout
        asvetliakov.vscode-neovim
        christian-kohler.path-intellisense
        davidanson.vscode-markdownlint
        dcasella.i3
        foxundermoon.shell-format
        james-yu.latex-workshop
        mads-hartmann.bash-ide-vscode
        ms-azuretools.vscode-docker
        ms-dotnettools.csdevkit
        ms-dotnettools.csharp
        ms-dotnettools.dotnet-maui
        ms-dotnettools.vscode-dotnet-runtime
        ms-python.debugpy
        ms-python.python
        ms-python.vscode-pylance
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        pkief.material-icon-theme
        redhat.vscode-yaml
        rogalmic.bash-debug
        rust-lang.rust-analyzer
        streetsidesoftware.code-spell-checker
        sumneko.lua
        tamasfe.even-better-toml
        timonwong.shellcheck
        tyriar.sort-lines
        usernamehw.errorlens
        valentjn.vscode-ltex
        vmsynkov.colonize
        yy0931.save-as-root
        yzhang.markdown-all-in-one
    )
    for extension in "${extensions[@]}"; do
        code --install-extension "$extension"
    done
fi

###########################
## Create symbolic links ##

dotfiles_dir="$HOME/.config/dotfiles"
config_dir="$HOME/.config"

# git
ln -sfn "$dotfiles_dir/git/.gitconfig" "$HOME/.gitconfig"

# yakuake
ln -sfn "$dotfiles_dir/yakuake/yakuake" "$config_dir/yakuake"

# wezterm
ln -sfn "$dotfiles_dir/wezterm/wezterm.lua" "$HOME/.wezterm.lua"

# i3
ln -sfn "$dotfiles_dir/i3" "$config_dir/i3"

# NeoVim
ln -sfn "$dotfiles_dir/nvim" "$config_dir/nvim"

# pip config
ln -sfn "$dotfiles_dir/pip" "$config_dir/pip"

# VS Code
ln -sfn "$dotfiles_dir/vscode/settings.json" "$config_dir/Code/User/settings.json"
ln -sfn "$dotfiles_dir/vscode/keybindings.json" "$config_dir/Code/User/keybindings.json"

# zsh
ln -sfn "$dotfiles_dir/zsh/.zshrc" "$HOME/.zshrc"

# cargo toml file
ln -sfn "$dotfiles_dir/cargo/config.toml" "$HOME/.cargo/config.toml"

# Change remote url of dotfiles
git remote set-url origin git@github.com:ndz-v/dotfiles.git

###################
## Install Chrome##

wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub >linux_signing_key.pub
sudo rpm --import linux_signing_key.pub
sudo zypper addrepo http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
sudo zypper refresh
sudo zypper install google-chrome-stable

#!/usr/bin/env bash

sudo -v # sk for admin credentials

apps=(
    ShellCheck
    alacritty
    bat
    clang
    curl
    entr
    fd
    gcc-c++
    git
    i3
    lld
    mold
    neovim
    nodejs21
    openssl-devel
    pandoc
    polybar
    python3-pip
    ripgrep
    sshpass
    thunderbird
    translate-shell
    vlc
    yakuake
    zsh
)

sudo zypper install -y "${apps[@]}" || true

# Install NordVPN

sh <(curl -sSf https://downloads.nordcdn.com/apps/linux/install.sh)

#############################
## Install Python Packages ##

Check if pip3 is installed
if type "pip3" &>/dev/null; then
    pip3 install --break-system-packages --user yt-dlp
fi

##################
## Install font ##

git clone --filter=blob:none --sparse https://github.com/ryanoasis/nerd-fonts.git
cd nerd-fonts || return
git sparse-checkout add patched-fonts/Hack
./install.sh Hack
cd "$HOME" || return
rm -r nerd-fonts

#################
## Install fzf ##

git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install

####################
## Install nodejs ##

npm config set prefix "$HOME/.local"
npm i -g bash-language-server

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
        albert.TabOut
        James-Yu.latex-workshop
        ms-azuretools.vscode-docker
        ms-vscode-remote.remote-ssh
        ms-vscode-remote.remote-ssh-edit
        ms-vscode.remote-explorer
        PKief.material-icon-theme
        redhat.ansible
        redhat.vscode-yaml
        rogalmic.bash-debug
        rust-lang.rust-analyzer
        tamasfe.even-better-toml
        timonwong.shellcheck
        usernamehw.errorlens
        vadimcn.vscode-lldb
        vmsynkov.colonize
        yy0931.save-as-root
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

# alacritty
mkdir "$config_dir/alacritty/"
ln -sfn "$dotfiles_dir/alacritty/alacritty.toml" "$config_dir/alacritty/alacritty.toml"

# VS Code
ln -sfn "$dotfiles_dir/vscode/settings.json" "$config_dir/Code/User/settings.json"
ln -sfn "$dotfiles_dir/vscode/keybindings.json" "$config_dir/Code/User/keybindings.json"

# zsh
ln -sfn "$dotfiles_dir/zsh/.zshrc" "$HOME/.zshrc"

# cargo toml file
ln -sfn "$dotfiles_dir/cargo/config.toml" "$HOME/.cargo/config.toml"

# Change remote url of dotfiles
git remote set-url origin git@github.com:ndz-v/dotfiles.git

########################
## Clone needed repos ##

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$dotfiles_dir/zsh/custom/zsh-syntax-highlighting"

git clone https://github.com/ndz-v/nvim.git "$config_dir/nvim"

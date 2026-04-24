setUpZShell() {
    sudo apt install zsh -y
    sudo chsh -s $(which zsh)
    touch ~/.zshrc
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
    curl -sSfL https://raw.githubusercontent.com/ajeetdsouza/zoxide/main/install.sh | sh

    git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
    git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
    git clone https://github.com/zsh-users/zsh-completions ${ZSH_CUSTOM:-${ZSH:-~/.oh-my-zsh}/custom}/plugins/zsh-completions
    git clone https://github.com/Aloxaf/fzf-tab ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/fzf-tab
    git clone https://github.com/MichaelAquilina/zsh-you-should-use.git $ZSH_CUSTOM/plugins/you-should-use
    git clone https://github.com/fdellwing/zsh-bat.git $ZSH_CUSTOM/plugins/zsh-bat
    git clone https://github.com/GeoLMg/apt-zsh-plugin.git $ZSH_CUSTOM/plugins/apt
    cp ./.zshrc ~/.zshrc

    source "$ZSH/oh-my-zsh.sh"

    echo "You'll need to download the powerlevel10k font from https://github.com/romkatv/powerlevel10k#meslo-nerd-font-patched-for-powerlevel10k"

    echo "After that run p10k configure"

    exec zsh

    curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/master/install.sh | bash

    source ~/.zshrc

    nvm install --lts
}

setUpCargoPackages() {
    if [ -x "$(command -v dust)" ]; then
        echo "dust exists"
    else
        curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y

        . "$HOME/.cargo/env"

        cargo install dust

        sudo cp /root/.cargo/bin/dust /usr/bin/dust
    fi
}

setUpBat() {
    if [ -x "$(command -v bat)" ]; then
        echo "bat exists"
    else
        sudo apt install bat -y

        mkdir -p ~/.local/bin
        ln -s /usr/bin/batcat ~/.local/bin/bat

        sudo mkdir -p /home/phaysik/.config/bat/

        sudo mv ./bat-config /home/phaysik/.config/bat/config

        sudo cp /root/.local/bin/bat /usr/bin/bat
    fi
}

setUpFzf() {
    if [ -x "$(command -v fzf)" ]; then
        echo "fzf exists"
    else
        sudo apt install fzf -y
    fi
}

main() {
    setUpCargoPackages

    setUpBat

    setUpFzf

    setUpZShell

    echo "deb [arch=$(dpkg --print-architecture) trusted=yes] https://eugene-babichenko.github.io/fixit/ppa ./" | sudo tee /etc/apt/sources.list.d/fixit.list > /dev/null
    sudo apt update
    sudo apt-get install ripgrep fixit -y
}

main "$@"

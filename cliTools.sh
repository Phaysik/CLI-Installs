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

setUpDust() {
    if [ -x "$(command -v dust)" ]; then
        echo "dust exists"
    else
        curl https://sh.rustup.rs -sSf | sh -s -- -y

        source $HOME/.cargo/env

        # Download the latest version of Tracy
        url=$(curl -s https://api.github.com/repos/bootandy/dust/releases/latest | grep -o '"tarball_url": *"[^"]*"' | cut -d '"' -f 4)
        curl -L -o dust-latest.tar.gz $url
        mkdir -p dust-latest
        tar -xvzf dust-latest.tar.gz -C dust-latest --strip-components=1
        sudo rm -rf dust-latest.tar.gz
        cd dust-latest

        cargo install du-dust

        cd ..

        rm -rf dust-latest
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
    setUpDust

    setUpBat

    setUpFzf

    setUpZShell
}

main "$@"

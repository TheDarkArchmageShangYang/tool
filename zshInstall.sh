#!/bin/bash

# 检查并安装 zsh
if ! command -v zsh &> /dev/null; then
    echo "Zsh is not installed. Installing..."
    if [ "$(uname)" == "Darwin" ]; then
        # macOS 系统
        brew install zsh
    elif [ -f /etc/debian_version ]; then
        # Debian/Ubuntu 系统
        sudo apt update && sudo apt install -y zsh
    elif [ -f /etc/redhat-release ]; then
        # CentOS/RHEL 系统
        sudo yum install -y zsh
    else
        echo "Unsupported system. Please install zsh manually."
        exit 1
    fi
else
    echo "Zsh is already installed."
fi

# 更改默认 shell 为 zsh
if [ "$SHELL" != "$(which zsh)" ]; then
    echo "Changing default shell to zsh..."
    chsh -s "$(which zsh)"
else
    echo "Zsh is already the default shell."
fi

# 安装 oh-my-zsh
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Installing oh-my-zsh..."
    sh -c "$(curl -fsSL https://gitee.com/pocmon/ohmyzsh/raw/master/tools/install.sh)"
else
    echo "oh-my-zsh already installed."
fi

# 插件列表
PLUGINS=(
    "zsh-users/zsh-autosuggestions"
    "zsh-users/zsh-syntax-highlighting"
    "agkozak/zsh-z"
)

# 下载插件
for PLUGIN in "${PLUGINS[@]}"; do
    PLUGIN_NAME=$(basename "$PLUGIN")
    if [ ! -d "$HOME/.oh-my-zsh/custom/plugins/$PLUGIN_NAME" ]; then
        echo "Installing $PLUGIN_NAME..."
        git clone "https://gitclone.com/github.com/$PLUGIN.git" "$HOME/.oh-my-zsh/custom/plugins/$PLUGIN_NAME"
    else
        echo "$PLUGIN_NAME already installed."
    fi
done

# # 安装 Powerlevel10k
# if [ ! -d "$HOME/.oh-my-zsh/custom/themes/powerlevel10k" ]; then
#     echo "Installing Powerlevel10k..."
#     git clone --depth=1 https://gitclone.com/github.com/romkatv/powerlevel10k.git ~/.oh-my-zsh/custom/themes/powerlevel10k
# else
#     echo "Powerlevel10k already installed."
# fi

# 配置 .zshrc
echo "Configuring .zshrc..."
sed -i '/^plugins=/c\plugins=(git zsh-autosuggestions zsh-syntax-highlighting zsh-z)' ~/.zshrc
# sed -i '/^ZSH_THEME=/c\ZSH_THEME="powerlevel10k/powerlevel10k"' ~/.zshrc
sed -i '/^ZSH_THEME=/c\ZSH_THEME="agnoster"' ~/.zshrc

# 刷新配置
echo "Reloading Zsh..."
source ~/.zshrc

echo "Installation complete! Please restart your terminal to use Zsh as default."

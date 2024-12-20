# данный скрипт должен находиться по пути roles/zsh_deploy/files/install_special.sh

#!/bin/bash

# Проверка наличия установленных пакетов
check_package() {
    dpkg -s "$1" > /dev/null 2>&1
    return $?
}

# Определение дистрибутива
distro=""
if [ -e "/etc/os-release" ]; then
    source "/etc/os-release"
    distro="$ID"
elif [ -e "/etc/redhat-release" ]; then
    distro="centos"
fi

if [ "$distro" == "amzn" ]; then
    distro="amazon"
fi

# Установка git, htop, nano
if ! check_package "git" || ! check_package "htop" || ! check_package "nano"; then
    echo "Установка git, htop, nano..."
    case "$distro" in
        "ubuntu" | "debian" | "pop")
            sudo apt-get update
            sudo apt-get install -y git htop nano
            ;;
        "fedora" | "amazon" | "centos" | "rhel")
            if command -v dnf > /dev/null; then
                sudo dnf install -y git htop nano
            else
                sudo yum install -y git htop nano
            fi
            ;;
        *)
            echo "Не удалось определить дистрибутив."
            exit 1
            ;;
    esac
else
    echo "git, htop, nano уже установлены."
fi

# Установка Powerline fonts, если не установлены
if ! check_package "fonts-powerline"; then
    echo "Установка Powerline fonts..."
    case "$distro" in
        "ubuntu" | "debian" | "pop")
            sudo apt-get install -y fonts-powerline
            ;;
        "fedora" | "amazon" | "centos" | "rhel")
            if command -v dnf > /dev/null; then
                sudo dnf install -y powerline-fonts
            else
                sudo yum install -y epel-release
                sudo yum install -y powerline-fonts
            fi
            ;;
        *)
            echo "Не удалось определить дистрибутив."
            exit 1
            ;;
    esac

    # Добавление настроек Powerline в конфигурацию Bash
    cat <<EOL >> ~/.bashrc

# Powerline configuration
if [ -f /usr/share/powerline/bindings/bash/powerline.sh ]; then
  powerline-daemon -q
  POWERLINE_BASH_CONTINUATION=1
  POWERLINE_BASH_SELECT=1
  source /usr/share/powerline/bindings/bash/powerline.sh
fi
EOL
else
    echo "Powerline fonts уже установлены."
fi

# Установка Zsh, если не установлен
if ! check_package "zsh"; then
    echo "Установка Zsh..."
    case "$distro" in
        "ubuntu" | "debian" | "pop")
            sudo apt-get install -y zsh
            ;;
        "fedora" | "amazon" | "centos" | "rhel")
            if command -v dnf > /dev/null; then
                sudo dnf install -y zsh
            else
                sudo yum install -y zsh
            fi
            ;;
        *)
            echo "Не удалось определить дистрибутив."
            exit 1
            ;;
    esac
else
    echo "Zsh уже установлен."
fi

# Назначение Zsh оболочкой по умолчанию
chsh -s $(which zsh)

# Вывод завершающего сообщения
cat << "EOF"
 ___   ________    ________   _________   ________   ___        ___
|\  \ |\   ___  \ |\   ____\ |\___   ___\|\   __  \ |\  \      |\  \
\ \  \\ \  \\ \  \\ \  \___|_\|___ \  \_|\ \  \|\  \\ \  \     \ \  \
 \ \  \\ \  \\ \  \\ \_____  \    \ \  \  \ \   __  \\ \  \     \ \  \
  \ \  \\ \  \\ \  \\|____|\  \    \ \  \  \ \  \ \  \\ \  \____ \ \  \____
   \ \__\\ \__\\ \__\ ____\_\  \    \ \__\  \ \__\ \__\\ \_______\\ \_______\
    \|__| \|__| \|__||\_________\    \|__|   \|__|\|__| \|_______| \|_______|
                     \|_________|


 ________   ________   _____ ______    ________   ___        _______   _________   _______
|\   ____\ |\   __  \ |\   _ \  _   \ |\   __  \ |\  \      |\  ___ \ |\___   ___\|\  ___ \
\ \  \___| \ \  \|\  \\ \  \\\__\ \  \\ \  \|\  \\ \  \     \ \   __/|\|___ \  \_|\ \   __/|
 \ \  \     \ \  \\\  \\ \  \\|__| \  \\ \   ____\\ \  \     \ \  \_|/__   \ \  \  \ \  \_|/__
  \ \  \____ \ \  \\\  \\ \  \    \ \  \\ \  \___| \ \  \____ \ \  \_|\ \   \ \  \  \ \  \_|\ \
   \ \_______\\ \_______\\ \__\    \ \__\\ \__\     \ \_______\\ \_______\   \ \__\  \ \_______\
    \|_______| \|_______| \|__|     \|__| \|__|      \|_______| \|_______|    \|__|   \|_______|
EOF

# Установка Oh My Zsh, если не установлен
if [ ! -d "$HOME/.oh-my-zsh" ]; then
    echo "Установка Oh My Zsh..."
    RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
    echo "Oh My Zsh уже установлен."
fi

# Установка темы agnoster для Zsh
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="agnoster"/' ~/.zshrc

# Установка плагинов zsh-autosuggestions, zsh-syntax-highlighting, dirhistory
sed -i '/^plugins=(git)/c plugins=(\
git\
zsh-autosuggestions\
zsh-syntax-highlighting\
dirhistory\
)' ~/.zshrc

git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions

#!/bin/bash

# 设置仓库链接
REPO_URL="https://github.com/aowei010/gokiteai-bot.git"
REPO_DIR="gokiteai-bot"

# 克隆仓库
if [ ! -d "$REPO_DIR" ]; then
  git clone "$REPO_URL"
fi

# 进入仓库目录
cd "$REPO_DIR" || exit

# 安装 nvm
if ! command -v nvm &> /dev/null; then
  echo "Installing nvm..."
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
  export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
fi

# 重新加载 nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"

# 安装指定版本的 Node.js
nvm install 18.20.5
nvm use 18.20.5

# 提示用户运行输入脚本
echo "请运行 'bash input.sh' 以输入账户信息。"

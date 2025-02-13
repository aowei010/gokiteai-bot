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

# 提示用户输入账户信息
addresses=()
privateKeys=()
proxies=()

echo "Please enter wallet addresses (one per line) and press Ctrl+D when done:"
while IFS= read -r line; do
  addresses+=("$line")
done

echo "Please enter private keys (one per line) corresponding to the addresses and press Ctrl+D when done:"
while IFS= read -r line; do
  privateKeys+=("$line")
done

echo "Please enter proxies (one per line) corresponding to the addresses (optional, press Enter to skip) and press Ctrl+D when done:"
while IFS= read -r line; do
  proxies+=("$line")
done

# 保存账户信息到 accounts.json 文件
accounts=()
for ((i=0; i<${#addresses[@]}; i++)); do
  accounts+=("{\"address\": \"${addresses[i]}\", \"privateKey\": \"${privateKeys[i]:-}\", \"proxy\": \"${proxies[i]:-}\"}")
done
accounts_json=$(printf ",\n" "${accounts[@]}")
accounts_json="[${accounts_json:1}]"

echo -e "$accounts_json" > accounts.json
echo "accounts.json has been saved."

# 启动新的 screen 会话并运行脚本
screen_name="gokiteai-bot"
screen -dmS "$screen_name" bash -c 'nvm use 18.20.5 && npm install && node .'

echo "Screen session '$screen_name' started."

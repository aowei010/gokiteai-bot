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

# 安装指定版本的 Node.js
nvm install 18.20.5
nvm use 18.20.5

# 创建 setup.js 脚本
cat << 'EOF' > setup.js
const fs = require('fs');
const readline = require('readline');
const { exec } = require('child_process');

// 创建 readline 接口
let rl = readline.createInterface({
  input: process.stdin,
  output: process.stdout,
  terminal: true
});

let addresses = [];
let privateKeys = [];
let proxies = [];

// 提示用户输入地址
function promptAddresses() {
  console.log('Please enter wallet addresses (one per line) and press Ctrl+D when done:');
  rl.on('line', (line) => {
    addresses.push(line.trim());
  });

  rl.on('close', () => {
    promptPrivateKeys();
  });
}

// 提示用户输入私钥
function promptPrivateKeys() {
  rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: true
  });

  console.log('Please enter private keys (one per line) corresponding to the addresses and press Ctrl+D when done:');
  rl.on('line', (line) => {
    privateKeys.push(line.trim());
  });

  rl.on('close', () => {
    promptProxies();
  });
}

// 提示用户输入代理信息
function promptProxies() {
  rl = readline.createInterface({
    input: process.stdin,
    output: process.stdout,
    terminal: true
  });

  console.log('Please enter proxies (one per line) corresponding to the addresses (optional, press Enter to skip) and press Ctrl+D when done:');
  rl.on('line', (line) => {
    proxies.push(line.trim());
  });

  rl.on('close', () => {
    saveAccounts();
  });
}

// 保存账户信息到 accounts.json 文件
function saveAccounts() {
  let accounts = [];
  for (let i = 0; i < addresses.length; i++) {
    accounts.push({
      address: addresses[i],
      privateKey: privateKeys[i] || '',
      proxy: proxies[i] || ''
    });
  }

  const jsonContent = JSON.stringify(accounts, null, 2);
  fs.writeFile('accounts.json', jsonContent, 'utf8', (err) => {
    if (err) {
      console.error('An error occurred while writing JSON Object to File.', err);
      process.exit(1);
    }

    console.log('accounts.json has been saved.');
    startScreenSession();
  });
}

// 启动新的 screen 会话并运行脚本
function startScreenSession() {
  const screenName = 'gokiteai-bot';
  const command = `screen -dmS ${screenName} bash -c 'nvm use 18.20.5 && npm install && node .'`;

  exec(command, (err, stdout, stderr) => {
    if (err) {
      console.error(`Error starting screen session: ${err}`);
      return;
    }
    console.log(`Screen session '${screenName}' started.`);
  });
}

promptAddresses();
EOF

# 提示用户输入账户信息
node setup.js

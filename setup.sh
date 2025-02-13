#!/bin/bash

# Load nvm
if [ -s "$NVM_DIR/nvm.sh" ]; then
  source "$NVM_DIR/nvm.sh"
else
  echo "NVM is not installed. Please install NVM first."
  exit 1
fi

# Clone the repository
git clone https://github.com/ahlulmukh/gokiteai-bot.git
cd gokiteai-bot

# Install the specified Node.js version using nvm
nvm install 18.20.5
nvm use 18.20.5

# Install the dependencies
npm install

# Create proxy.txt file with example content
cat <<EOL > proxy.txt
socks5://user1:password1@host1:port1
socks5://user2:password2@host2:port2
EOL

# Create accounts.json file with example content
cat <<EOL > accounts.json
[
  {
    "address": "0xYourAddress1",
    "privateKey": "0xYourPrivateKey1"
  },
  {
    "address": "0xYourAddress2",
    "privateKey": "0xYourPrivateKey2"
  }
]
EOL

echo "Setup completed. You can now run the bot using 'node .'"

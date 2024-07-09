#!/bin/bash

clear
echo "Enter your full name exactly as you entered it on Github settings:"
read -p "> " STUDENT_NAME
echo -e "\nEnter email address you used for Github:"
read -p "> " EMAIL_ADDRESS
echo -e "\nEnter your Github account name:"
read -p "> " GH_USERNAME

PUBLIC_KEY=$HOME/.ssh/id_nss.pub
if [ ! -f "$PUBLIC_KEY" ]; then
  echo -e "\n\nGenerating an SSH key so you can backup your code to Github..."
  echo "yes" | ssh-keygen -t ed25519 -f ~/.ssh/id_nss -N "" -b 4096 -C $EMAIL_ADDRESS
  eval $(ssh-agent)
  ssh-add ~/.ssh/id_nss
  echo -e "Host *\n\tAddKeysToAgent yes\n\tIdentityFile ~/.ssh/id_nss" >>~/.ssh/config
fi

echo -e "\n\nAdding your SSH key to your Github account..."
PUBLIC_KEY_CONTENT=$(cat $HOME/.ssh/id_nss.pub)

STATUS_CODE=$(curl \
  -s \
  --write-out %{http_code} \
  -X POST \
  -H "Accept: application/vnd.github+json" \
  -H "Authorization: Bearer $PERSONAL_ACCESS_TOKEN" \
  -H "X-GitHub-Api-Version: 2022-11-28" \
  https://api.github.com/user/keys \
  -d "{\"key\":\"$PUBLIC_KEY_CONTENT\",\"title\":\"NSS Automated Key\"}" >>/dev/null)

if [ ! $STATUS_CODE == 200 ]; then
  echo -e "POST for SSH key returned status code $STATUS_CODE" >>progress.log
fi

git config --global user.name "$STUDENT_NAME" >>/dev/null
git config --global user.email "$EMAIL_ADDRESS" >>/dev/null

#!/bin/bash

echo -e "\n\n\n\n"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo "@@                                                             @@"
echo "@@                   VERIFYING INSTALLS                        @@"
echo "@@                                                             @@"
echo "@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@"
echo ""

if ! type brew &>/dev/null; then
  echo "ERROR: Brew not installed"
else
  echo "Brew installed"
fi

if ! type node &>/dev/null; then
  echo "ERROR: Node not installed"
else
  echo "Node installed"
fi

if ! type serve &>/dev/null; then
  echo "ERROR: serve not installed"
else
  echo "serve installed"
fi

if ! type json-server &>/dev/null; then
  echo "ERROR: json-server not installed"
else
  echo "json-server installed"
fi

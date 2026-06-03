#!/bin/bash

# Vérifier si lancé en sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[38;5;196m[-] Erreur : Ce script doit être lancé avec sudo.\033[0m" 
   exit 1
fi

echo -e "\033[38;5;202m[*]\033[0m Mise à jour et installation des dépendances (adb, nmap, aapt)..."
apt-get update -y
apt-get install -y adb nmap android-sdk-platform-tools-common

# Correction : Vérifier le nom du fichier réel (votre capture montre 'adb-pair.sh')
FILE_NAME="adb-pair.sh" 

if [ ! -f "$FILE_NAME" ]; then
    echo -e "\033[38;5;196m[-] Erreur : Le fichier '$FILE_NAME' est introuvable.\033[0m"
    exit 1
fi

echo -e "\033[38;5;202m[*]\033[0m Déploiement de l'exécutable dans /usr/local/bin/adb-pair..."
cp "$FILE_NAME" /usr/local/bin/adb-pair
chmod +x /usr/local/bin/adb-pair

echo -e "\033[38;5;202m[+]\033[0m Installation terminée avec succès."
echo -e "\033[38;5;202m[*]\033[0m Tapez \033[38;5;255madb-pair\033[0m dans n'importe quel terminal pour lancer l'outil.\n"

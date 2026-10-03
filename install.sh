#!/bin/bash

# Vérifier si lancé en sudo
if [[ $EUID -ne 0 ]]; then
   echo -e "\033[38;5;196m[-] Erreur : Ce script doit être lancé avec sudo.\033[0m"
   exit 1
fi

if ! command -v apt-get &>/dev/null; then
   echo -e "\033[38;5;196m[-] Erreur : apt-get introuvable. Installez adb et aapt manuellement.\033[0m"
   exit 1
fi

echo -e "\033[38;5;202m[*]\033[0m Mise à jour et installation des dépendances (adb, aapt, scrcpy)..."
apt-get update -y
apt-get install -y adb aapt || exit 1
apt-get install -y scrcpy || echo -e "\033[38;5;208m[!]\033[0m scrcpy indisponible : l'option 27 (miroir) sera desactivee."

# Chemin du script, indépendant du répertoire courant
FILE_NAME="$(cd "$(dirname "$0")" && pwd)/adb-pair.sh"

if [ ! -f "$FILE_NAME" ]; then
    echo -e "\033[38;5;196m[-] Erreur : Le fichier '$FILE_NAME' est introuvable.\033[0m"
    exit 1
fi

echo -e "\033[38;5;202m[*]\033[0m Déploiement de l'exécutable dans /usr/local/bin/adb-pair..."
install -m 755 "$FILE_NAME" /usr/local/bin/adb-pair

echo -e "\033[38;5;202m[+]\033[0m Installation terminée avec succès."
echo -e "\033[38;5;202m[*]\033[0m Tapez \033[38;5;255madb-pair\033[0m dans n'importe quel terminal pour lancer l'outil.\n"

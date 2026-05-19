#!/bin/bash

NC='\033[0m'
G4='\033[38;5;196m'
G5='\033[38;5;202m'
WHITE='\033[38;5;255m'

if [ "$EUID" -ne 0 ]; then
    echo -e "${G4}[-] Erreur : Ce script nécessite les privilèges root. Exécutez-le avec 'sudo ./install.sh'.${NC}"
    exit 1
fi

echo -e "\n${G5}[*]${NC} Mise à jour des dépôts et installation des dépendances (adb, aapt)..."
apt-get update -y
apt-get install -y adb aapt

if [ ! -f "adb-pair-advanced.sh" ]; then
    echo -e "\n${G4}[-] Erreur : Le fichier 'adb-pair-advanced.sh' est introuvable dans le répertoire courant.${NC}"
    exit 1
fi

echo -e "\n${G5}[*]${NC} Déploiement de l'exécutable dans /usr/local/bin/adb-pair..."
cp adb-pair-advanced.sh /usr/local/bin/adb-pair
chmod +x /usr/local/bin/adb-pair

echo -e "\n${G5}[+]${NC} Installation terminée avec succès."
echo -e "${G5}[*]${NC} Tapez ${WHITE}adb-pair${NC} dans n'importe quel terminal pour lancer l'interface.\n"

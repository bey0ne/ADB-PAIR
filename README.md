# ADB-PAIR Tools

Interface TUI (Text User Interface) avancée en Bash pour l'administration, le débogage et le contrôle d'appareils Android via l'Android Debug Bridge (ADB). Ce script automatise l'exécution de commandes complexes à travers un panneau console à triple colonne.

## ⚠️ Disclaimer !

Ce logiciel est fourni "en l'état", sans aucune garantie d'aucune sorte. Les opérations via ADB impliquant des modifications du système de fichiers ou la gestion des paquets (désinstallation d'applications, nettoyage de répertoires système) comportent des risques de perte de données ou de dysfonctionnement logiciel du périphérique cible (brick). L'auteur décline toute responsabilité en cas de dommages matériels, logiciels ou de pertes d'informations induits par l'utilisation de cet outil. L'exécution de ce script relève de la seule responsabilité de l'opérateur.

## ⚙️ Fonctionnalités

* **Initialisation réseau sécurisée :** Séquence d'interrogation des interfaces (`ap0`, `wlan1`, `wlan0`) pour le basculement TCP/IP automatique (sans fil). Intègre un mécanisme de vérification de connectivité par boucles itératives avec un délai d'attente maximum (`timeout`) de 30 secondes pour interdire le blocage du shell hôte. Maintien automatique du mode USB strict en cas d'échec de routage local.
* **Gestion dynamique des applications (Option 13) :** Interrogation en temps réel de la couche de gestion des paquets Android (`pm list packages -3`) pour extraire exclusivement les applications tierces. Permet l'arrêt forcé, la purge des données applicatives, la désinstallation ou le lancement via sélection numérique avec traitement automatique par troncature (limite à 51 caractères) pour préserver l'intégrité visuelle du menu.
* **Matrices Push/Pull (Options 21/22) :** Transferts de fichiers basés sur des tableaux de correspondances absolues statiques (`/sdcard/Download`, `/sdcard/DCIM`, `/data/local/tmp`) contournant la latence des balayages récursifs de l'OS Android.
* **Outils d'extraction multimédia :** Captures d'écran directes via `exec-out screencap` et enregistrements vidéo temporels (`screenrecord`) avec rapatriement automatisé dans les sous-répertoires locaux `./screenshots` et `./videos`.

## Prérequis et Environnement

Le script a été développé, calibré et validé sur la distribution **Ubuntu** au sein de l'émulateur de terminal standard **GNOME Terminal**.

L'hôte d'exécution doit disposer des paquets suivants :
* Un environnement système de type GNU/Linux ou macOS.
* Le paquet **`android-tools-adb`** opérationnel dans les variables d'environnement (`$PATH`).
* Le paquet **`aapt`** (Android Asset Packaging Tool), requis pour l'analyse des APK et l'extraction de la *Launchable Activity* (Option 12).
* L'interpréteur **`bash`** en version 4.0 ou supérieure.

Commande d'installation des dépendances sous Ubuntu / Debian :
```bash
sudo apt update
sudo apt install adb aapt

```
## 📥 Installation
Le déploiement s'effectue via un script automatisé qui installe les dépendances manquantes, configure les droits d'exécution et lie le binaire au répertoire système global.
 1. Cloner le dépôt distant :
```bash
git clone [https://github.com/votre-nom-utilisateur/ADB-PAIR.git](https://github.com/votre-nom-utilisateur/ADB-PAIR.git)
cd ADB-PAIR

```
 2. Exécuter le script d'installation avec les privilèges root :
```bash
chmod +x install.sh
sudo ./install.sh

```
## Utilisation
L'outil étant enregistré globalement dans le $PATH, l'accès au panel s'exécute depuis n'importe quel emplacement du système via la commande :
```bash
adb-pair

```
### Modes de liaison à l'initialisation
 * **[1] USB → Wi-Fi auto :** Requiert l'interconnexion physique initiale. Le script ouvre le port TCP 5555 sur le démon adbd du téléphone, extrait l'adresse IP locale de l'appareil et valide la connexion sans fil. Le câble USB peut être déconnecté dès l'apparition du message de confirmation.
 * **[2] IP directe :** Établit la liaison directe via l'adresse de socket (IP:Port) fournie manuellement si le démon de la cible est déjà configuré en mode d'écoute réseau.
L'interruption du processus et la fermeture du panneau s'exécutent par les commandes exit ou quit dans le prompt de saisie, ou par l'envoi du signal d'interruption standard Ctrl+C.

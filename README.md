# ADB-PAIR Tools

Interface TUI (Text User Interface) avancée en Bash pour l'administration, le débogage et le contrôle d'appareils Android via l'Android Debug Bridge (ADB). Ce script automatise l'exécution de commandes complexes à travers un panneau console à triple colonne.

## ⚠️ Disclaimer !

Ce logiciel est fourni "en l'état", sans aucune garantie d'aucune sorte. Les opérations via ADB impliquant des modifications du système de fichiers ou la gestion des paquets (désinstallation d'applications, nettoyage de répertoires système) comportent des risques de perte de données ou de dysfonctionnement logiciel du périphérique cible (brick). L'auteur décline toute responsabilité en cas de dommages matériels, logiciels ou de pertes d'informations induits par l'utilisation de cet outil. L'exécution de ce script relève de la seule responsabilité de l'opérateur.

## ⚙️ Fonctionnalités

* **Initialisation réseau sécurisée :** Séquence d'interrogation des interfaces (`ap0`, `wlan1`, `wlan0`) pour le basculement TCP/IP automatique (sans fil). Intègre un mécanisme de vérification de connectivité par tentatives successives bornées par `timeout` pour éviter le blocage du shell hôte. Maintien automatique du mode USB strict en cas d'échec de routage local.
* **Appairage sans fil Android 11+ (mode [3] / option 07) :** Association via `adb pair` avec le code affiché dans *Options développeur > Débogage sans fil*, sans câble USB.
* **Gestion dynamique des applications (Option 13) :** Interrogation en temps réel de la couche de gestion des paquets Android (`pm list packages -3`) pour extraire exclusivement les applications tierces. Permet l'arrêt forcé, la purge des données applicatives, la désinstallation ou le lancement via sélection numérique avec traitement automatique par troncature (limite à 51 caractères) pour préserver l'intégrité visuelle du menu.
* **Matrices Push/Pull (Options 21/22) :** Transferts de fichiers basés sur des tableaux de correspondances absolues statiques (`/sdcard/Download`, `/sdcard/DCIM`, `/data/local/tmp`) contournant la latence des balayages récursifs de l'OS Android.
* **Outils d'extraction multimédia :** Captures d'écran directes via `exec-out screencap` et enregistrements vidéo temporels (`screenrecord`) avec rapatriement automatisé dans les sous-répertoires locaux `./screenshots` et `./videos`. L'enregistrement peut être arrêté avant la fin par Ctrl+C.
* **Appareils mémorisés (mode [4] / option 08) :** Les 10 derniers appareils Wi-Fi sont enregistrés dans `~/.config/adb-pair/appareils` et proposés au démarrage, avec les appareils déjà connectés.
* **Fermeture du port 5555 (option 09) :** Repasse le téléphone en mode USB (`adb usb`). Le script le propose aussi en quittant si c'est lui qui a ouvert le port.
* **Sauvegarde des APK (option 17 / menu Apps [6]) :** Récupère les APK d'une application, split APK compris, dans `./apks/<package>/`.
* **Logcat d'une application (option 18 / menu Apps [7]) :** Journal en direct filtré sur le processus de l'application.
* **Recherche d'applications :** Dans le menu 13, `/texte` filtre la liste et `*` l'affiche en entier.
* **Miroir d'écran (option 27) :** Lance `scrcpy` dans une fenêtre séparée.
* **Clavier distant (option 33) :** Envoi de texte et des touches Accueil, Retour, Applications récentes, Marche, Volume et Entrée.
* **Écran Info (I) :** Modèle, version Android, batterie, stockage libre et présence de `su`.

## Prérequis et Environnement

Le script a été développé, calibré et validé sur la distribution **Ubuntu** au sein de l'émulateur de terminal standard **GNOME Terminal**.

L'hôte d'exécution doit disposer des paquets suivants :
* Un environnement système de type GNU/Linux (sous macOS : installer `bash` 4+ et `coreutils` via Homebrew, la commande `timeout` n'étant pas fournie par défaut).
* Le paquet **`adb`** (Android platform-tools) opérationnel dans les variables d'environnement (`$PATH`).
* Le paquet **`aapt`** (Android Asset Packaging Tool), requis pour l'analyse des APK et l'extraction de la *Launchable Activity* (Option 12).
* Optionnel : **`scrcpy`** pour le miroir d'écran (Option 27).
* L'interpréteur **`bash`** en version 4.0 ou supérieure.

Commande d'installation des dépendances sous Ubuntu / Debian :
```bash
sudo apt update
sudo apt install adb aapt scrcpy

```
## 📥 Installation
Le déploiement s'effectue via un script automatisé qui installe les dépendances manquantes, configure les droits d'exécution et lie le binaire au répertoire système global.
 1. Cloner le dépôt distant :
```bash
git clone https://github.com/bey0ne/adb-pair.git
cd adb-pair

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
Options de la ligne de commande :
```bash
adb-pair --help              # aide
adb-pair --version           # version
adb-pair 192.168.1.10        # connexion directe (port 5555 par défaut)
adb-pair 192.168.1.10:41234  # connexion directe sur un port précis
```
### Modes de liaison à l'initialisation
 * **[1] USB → Wi-Fi auto :** Requiert l'interconnexion physique initiale. Le script ouvre le port TCP 5555 sur le démon adbd du téléphone, extrait l'adresse IP locale de l'appareil et valide la connexion sans fil. Le câble USB peut être déconnecté dès l'apparition du message de confirmation.
 * **[2] IP directe :** Établit la liaison directe via l'adresse de socket (IP:Port) fournie manuellement si le démon de la cible est déjà configuré en mode d'écoute réseau. Sans port précisé, `5555` est utilisé.
 * **[3] Appairage (Android 11+) :** Saisir l'IP:Port et le code d'association affichés par *Débogage sans fil > Associer avec un code*, puis l'IP:Port de connexion affiché sur l'écran principal du débogage sans fil.

> ⚠️ Le mode [1] laisse adbd en écoute sur le port TCP 5555 jusqu'au prochain redémarrage du téléphone. Sur un réseau non maîtrisé, redémarrez l'appareil ou exécutez `adb usb` après usage.

Les numéros du menu peuvent être saisis avec ou sans zéro initial (`1` ou `01`). L'interruption du processus et la fermeture du panneau s'exécutent par `q`, `exit` ou `quit` dans le prompt de saisie, ou par Ctrl+C depuis le menu principal.

## Versions

Le numéro de version est affiché dans le menu et par `adb-pair --version`. L'historique des changements se trouve dans [CHANGELOG.md](CHANGELOG.md).
Pour revenir à une version précédente, utilisez les tags Git, par exemple `git checkout v1.0.0`.

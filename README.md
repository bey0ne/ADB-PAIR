# ADB-PAIR Tools

Interface TUI (Text User Interface) avancée en Bash pour l'administration, le débogage et le contrôle d'appareils Android via l'Android Debug Bridge (ADB). Ce script automatise les commandes complexes à travers un panneau console structuré en 3 colonnes.

## ⚠️ Avertissement (Disclaimer)

Cet outil est fourni "tel quel" (as is), sans aucune garantie explicite ou implicite. L'exécution de commandes ADB avec des privilèges de débogage (désinstallation de paquets, manipulation du système de fichiers, etc.) peut entraîner une perte de données, une instabilité de l'OS Android, ou rendre le périphérique inopérant (brick). L'auteur décline toute responsabilité concernant d'éventuels dommages matériels, logiciels ou pertes de données. L'utilisation de ce script se fait sous votre entière responsabilité.

## ⚙️ Fonctionnalités

* **Initialisation réseau sécurisée :** Recherche séquentielle des interfaces réseau (`ap0`, `wlan1`, `wlan0`) pour la bascule TCP/IP (sans fil) avec un mécanisme de détection de connectivité et un `timeout` de 30 secondes pour empêcher le blocage du terminal. En cas d'échec, le script maintient la liaison USB.
* **Gestion dynamique des applications (Option 13) :** Extraction automatique de la liste des paquets tiers installés sur l'appareil (flag `-3`). Permet la désinstallation, le nettoyage des données, l'arrêt forcé ou le lancement d'une application via une sélection numérique avec gestion automatique de la troncature des noms longs.
* **Transferts Push/Pull (Options 21/22) :** Menus de sélection basés sur des matrices de chemins absolus standards Android (`/sdcard/Download`, `/sdcard/DCIM`, `/data/local/tmp`, etc.) pour éliminer la latence des recherches récursives.
* **Captures et diagnostics :** Outils d'extraction de captures d'écran, d'enregistrements vidéo avec paramétrage de la durée, et récupération des flux de logs (`logcat`, `dumpsys`).

## 🛠 Prérequis et Environnement

Le script a été développé, calibré visuellement et validé spécifiquement sur la distribution **Ubuntu** (environnement de bureau GNOME, utilisation de GNOME Terminal).

L'hôte cible doit disposer des composants suivants :
* Un environnement système GNU/Linux ou macOS.
* **`android-tools-adb`** (accessible dans la variable d'environnement PATH).
* **`aapt`** (Android Asset Packaging Tool) : requis exclusivement pour l'option `[12] Inject+Exec` afin d'extraire la composante d'activité principale des paquets APK.
* **`bash`** : version 4.0 ou supérieure.

Installation des dépendances sous environnement Debian/Ubuntu :
```bash
sudo apt update
sudo apt install adb aapt

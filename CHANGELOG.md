# Changelog

Toutes les évolutions notables du projet sont listées ici.
Le format suit [Keep a Changelog](https://keepachangelog.com/fr/1.1.0/) et le projet respecte le [versionnage sémantique](https://semver.org/lang/fr/).

## [2.0.0]

### Ajouté
- Option `--help`, option `--version` et connexion directe `adb-pair IP[:PORT]`.
- Numéro de version affiché dans le menu.
- Appairage sans fil Android 11+ (`adb pair`) : mode [3] et option 07.
- Historique des 10 derniers appareils Wi-Fi, mode [4] au démarrage et option 08 pour choisir l'appareil.
- Option 09 et proposition à la sortie pour fermer le port 5555 (`adb usb`).
- Option 17 et menu Apps [6] : sauvegarde des APK (split APK compris).
- Option 18 et menu Apps [7] : logcat en direct d'une application.
- Recherche dans la liste des applications (`/texte`).
- Option 27 : miroir d'écran avec `scrcpy`.
- Option 33 : envoi de texte et de touches.
- Écran Info : batterie, stockage libre, root.
- Ctrl+C pendant l'enregistrement d'écran ou le logcat revient au menu ; dans le menu, il quitte proprement.
- Vérification ShellCheck automatique (GitHub Actions).

### Corrigé
- Vérification exacte de l'état de la cible, ajout automatique du port 5555.
- Mode USB → Wi-Fi : plus de faux « Liaison établie » quand la connexion n'est pas autorisée ; gestion de plusieurs appareils USB.
- Échappement des saisies envoyées au shell du téléphone.
- `read -r`, chemins avec `~` et glisser-déposer.
- Screenrecord et pull : erreurs signalées.
- `install.sh` installe `aapt`.

## [1.0.0]

Version initiale (commit `4f91311`).

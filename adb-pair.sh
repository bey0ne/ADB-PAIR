#!/bin/bash

#couleurs
NC='\033[0m'

C1='\033[38;5;196m'
C2='\033[38;5;203m'
C3='\033[38;5;210m'
C4='\033[38;5;217m'
C5='\033[38;5;224m'
C6='\033[38;5;231m'

# Couleurs UI
G1='\033[38;5;88m'
G2='\033[38;5;124m'
G3='\033[38;5;160m'
G4='\033[38;5;196m'
G5='\033[38;5;202m'
G6='\033[38;5;208m'
GRAY='\033[38;5;240m'
LGRAY='\033[38;5;245m'
WHITE='\033[38;5;255m'

TARGET=""

# cleanup
cleanup() { [ -n "$TARGET" ] && adb disconnect "${TARGET}" > /dev/null 2>&1; }
trap cleanup EXIT

# Verification de la cible
check_target() {
    if [ -z "$TARGET" ]; then
        echo -e "${G4}[-] Erreur : Aucune cible definie.${NC}"; sleep 2; return 1
    fi
    if ! adb devices | grep -F "${TARGET}" | awk '{print $2}' | grep -q "^device$"; then
        echo -e "${G4}[-] Erreur : Cible '${TARGET}' hors ligne.${NC}"; sleep 2; return 1
    fi
    return 0
}

# Banniere
afficher_banniere() {
    clear
    printf "${C1}%s\n" ' _____/\\\\\\\\\_____/\\\\\\\\\\\\_____/\\\\\\\\\\\\\___'
    printf "${C1}%s\n" '  ___/\\\\\\\\\\\\\__\/\\\////////\\\__\/\\\/////////\\\_'
    printf "${C1}%s\n" '   __/\\\/////////\\\_\/\\\______\//\\\_\/\\\_______\/\\\_'
    printf "${C2}%s\n" '    _\/\\\_______\/\\\_\/\\\_______\/\\\_\/\\\\\\\\\\\\\\__'
    printf "${C2}%s\n" '     _\/\\\\\\\\\\\\\\\_\/\\\_______\/\\\_\/\\\/////////\\\_'
    printf "${C2}%s\n" '      _\/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_   BY B3Y0NE'
    printf "${C3}%s\n" '       _\/\\\_______\/\\\_\/\\\_______/\\\__\/\\\_______\/\\\_'
    printf "${C3}%s\n" '        _\/\\\_______\/\\\_\/\\\\\\\\\\\\/___\/\\\\\\\\\\\\\/__'
    printf "${C3}%s\n" '         _\///________\///__\////////////_____\/////////////____'
    printf "${C4}%s\n" '          __/\\\\\\\\\\\\\_______/\\\\\\\\\_____/\\\\\\\\\\\____/\\\\\\\\\_____'
    printf "${C4}%s\n" '           _\/\\\/////////\\\___/\\\\\\\\\\\\\__\/////\\\///___/\\\///////\\\___'
    printf "${C4}%s\n" '            _\/\\\_______\/\\\__/\\\/////////\\\_____\/\\\_____\/\\\_____\/\\\___'
    printf "${C5}%s\n" '             _\/\\\\\\\\\\\\\/__\/\\\_______\/\\\_____\/\\\_____\/\\\\\\\\\\\/____'
    printf "${C5}%s\n" '              _\/\\\/////////____\/\\\\\\\\\\\\\\\_____\/\\\_____\/\\\//////\\\____'
    printf "${C5}%s\n" '               _\/\\\_____________\/\\\/////////\\\_____\/\\\_____\/\\\____\//\\\___'
    printf "${C6}%s\n" '                _\/\\\_____________\/\\\_______\/\\\_____\/\\\_____\/\\\_____\//\\\__'
    printf "${C6}%s\n" '                 _\/\\\_____________\/\\\_______\/\\\__/\\\\\\\\\\\_\/\\\______\//\\\_'
    printf "${C6}%s\n" '                  _\///______________\///________\///__\///////////__\///________\///__'
    echo ""
}

# Menu principal
afficher_menu() {
    echo -e "                                 ${WHITE}ADB-PAIR-Tools${NC}\n"
    
    echo -e "${G4}┌─${NC} ${G4}[${WHITE}I${G4}]${NC} ${WHITE}Info${NC}                                                   ${G4}[${WHITE}31${G4}]${NC} ${WHITE}Open URL${NC} ${G4}─┐${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}S${G4}]${NC} ${WHITE}Status${NC}                                                 ${G4}[${WHITE}32${G4}]${NC} ${WHITE}Shell   ${NC} ${G4}─┤${NC}"
    echo -e "${G4}│${NC}                                                                            ${G4}│${NC}"
    echo -e "${G4}├───[${NC} ${WHITE}Device & Network${NC} ${G4}]───┬───[${NC} ${WHITE}App Management${NC} ${G4}]───┬───[${NC} ${WHITE}File & System${NC} ${G4}]────┘${NC}"
    echo -e "${G4}│${NC}                          ${G4}│${NC}                        ${G4}│${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}01${G4}]${NC} ${WHITE}Changer Cible      ${G4}├─${NC} ${G4}[${WHITE}11${G4}]${NC} ${WHITE}Inject APK       ${G4}├─${NC} ${G4}[${WHITE}21${G4}]${NC} ${WHITE}Push File${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}02${G4}]${NC} ${WHITE}Reinit TCP/IP      ${G4}├─${NC} ${G4}[${WHITE}12${G4}]${NC} ${WHITE}Inject+Exec      ${G4}├─${NC} ${G4}[${WHITE}22${G4}]${NC} ${WHITE}Pull File${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}03${G4}]${NC} ${WHITE}List Devices       ${G4}├─${NC} ${G4}[${WHITE}13${G4}]${NC} ${WHITE}Gerer Apps       ${G4}├─${NC} ${G4}[${WHITE}23${G4}]${NC} ${WHITE}Screenshot${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}04${G4}]${NC} ${WHITE}Reboot Sys         ${G4}├─${NC} ${G4}[${WHITE}14${G4}]${NC} ${WHITE}Clear Data       ${G4}├─${NC} ${G4}[${WHITE}24${G4}]${NC} ${WHITE}Screenrecord${NC}"
    echo -e "${G4}├─${NC} ${G4}[${WHITE}05${G4}]${NC} ${WHITE}Reboot Recov       ${G4}├─${NC} ${G4}[${WHITE}15${G4}]${NC} ${WHITE}List Apps        ${G4}├─${NC} ${G4}[${WHITE}25${G4}]${NC} ${WHITE}Logcat Dump${NC}"
    echo -e "${G4}└─${NC} ${G4}[${WHITE}06${G4}]${NC} ${WHITE}Status Tunnel      ${G4}└─${NC} ${G4}[${WHITE}16${G4}]${NC} ${WHITE}Force Stop       ${G4}└─${NC} ${G4}[${WHITE}26${G4}]${NC} ${WHITE}Dumpsys${NC}"
    echo ""
}

# Menu Apps
menu_apps() {
    while true; do
        afficher_banniere
        echo -e "${G4}  ▼ App Management — Applications de l'appareil${NC}\n"
        printf "  ${G5}[*]${NC} Chargement...\r"

        mapfile -t APPS < <(
            adb -s "${TARGET}" shell pm list packages -3 2>/dev/null \
            | sed 's/package://' | sort | tr -d '\r'
        )

        if [ ${#APPS[@]} -eq 0 ]; then
            echo -e "  ${G4}[-] Aucune application tierce trouvee.${NC}"
            read -p "  Entree..."; return
        fi

        echo -e "  ${G4}┌────────────────────────────────────────────────────────┐${NC}"
        for i in "${!APPS[@]}"; do
            printf "  ${G4}│${NC} ${WHITE}[%2d]${NC} %-51s ${G4}│${NC}\n" \
                "$((i+1))" "${APPS[$i]:0:51}"
        done
        printf "  ${G4}│${NC} ${WHITE}[%2s]${NC} %-51s ${G4}│${NC}\n" "0" "Retour"
        echo -e "  ${G4}└────────────────────────────────────────────────────────┘${NC}"

        printf "  ${G4}─►${NC} "
        read sel
        [ "$sel" == "0" ] || [ "$sel" == "b" ] && return
        if ! [[ "$sel" =~ ^[0-9]+$ ]] || \
            [ "$sel" -lt 1 ] || [ "$sel" -gt "${#APPS[@]}" ]; then
            continue
        fi

        PKG="${APPS[$((sel-1))]}"

        while true; do
            echo -e "\n  ${G5}Package :${NC} ${WHITE}${PKG}${NC}"
            echo -e "${G4}  ┌──────────────────────────────┐${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[1]${NC} Desinstaller              ${G4}│${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[2]${NC} Vider les donnees         ${G4}│${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[3]${NC} Forcer l'arret            ${G4}│${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[4]${NC} Infos detaillees          ${G4}│${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[5]${NC} Lancer l'application      ${G4}│${NC}"
            echo -e "${G4}  │${NC} ${WHITE}[0]${NC} Retour a la liste         ${G4}│${NC}"
            echo -e "${G4}  └──────────────────────────────┘${NC}"
            printf "  ${G4}─►${NC} "
            read action
            case $action in
                1)
                    printf "\n  ${G6}[!]${NC} Confirmer ? [o/N] : "
                    read c; [[ "$c" =~ ^[oO]$ ]] && \
                        adb -s "${TARGET}" shell pm uninstall "${PKG}" && break
                    ;;
                2) adb -s "${TARGET}" shell pm clear "${PKG}"; sleep 1 ;;
                3) adb -s "${TARGET}" shell am force-stop "${PKG}"
                   echo -e "  ${G5}[+]${NC} Arrete."; sleep 1 ;;
                4) echo ""
                   adb -s "${TARGET}" shell dumpsys package "${PKG}" \
                   | grep -E "versionName|versionCode|firstInstallTime|dataDir|codePath"
                   ;;
                5) adb -s "${TARGET}" shell monkey -p "${PKG}" \
                       -c android.intent.category.LAUNCHER 1 > /dev/null 2>&1
                   echo -e "  ${G5}[+]${NC} Lance." ;;
                0|b|"") break ;;
                *) echo -e "  ${G4}[?]${NC} Choix invalide." ;;
            esac
            read -p "  Entree..."
        done
    done
}

# Menu Push
menu_push() {
    while true; do
        afficher_banniere
        echo -e "${G4}  ▲ Push File — Destination sur l'appareil${NC}\n"
        echo -e "  ${G4}┌────────────────────────────────────────────────────────┐${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[1]${NC} Downloads           ${LGRAY}/sdcard/Download${NC}           ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[2]${NC} DCIM / Photos        ${LGRAY}/sdcard/DCIM${NC}              ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[3]${NC} Pictures             ${LGRAY}/sdcard/Pictures${NC}          ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[4]${NC} Musique              ${LGRAY}/sdcard/Music${NC}             ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[5]${NC} Documents            ${LGRAY}/sdcard/Documents${NC}         ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[6]${NC} WhatsApp Media       ${LGRAY}.../WhatsApp/Media${NC}        ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[7]${NC} Repertoire temp      ${LGRAY}/data/local/tmp${NC}           ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[8]${NC} Saisie manuelle      ${LGRAY}chemin absolu${NC}             ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[0]${NC} Retour                                            ${G4}│${NC}"
        echo -e "  ${G4}└────────────────────────────────────────────────────────┘${NC}"
        printf "  ${G4}─►${NC} "
        read sel

        case $sel in
            1) DEST="/sdcard/Download" ;;
            2) DEST="/sdcard/DCIM" ;;
            3) DEST="/sdcard/Pictures" ;;
            4) DEST="/sdcard/Music" ;;
            5) DEST="/sdcard/Documents" ;;
            6) DEST="/sdcard/Android/media/com.whatsapp/WhatsApp/Media" ;;
            7) DEST="/data/local/tmp" ;;
            8) printf "\n  ${G5}[*]${NC} Chemin absolu : "; read DEST
               [ -z "$DEST" ] && continue ;;
            0|b) return ;;
            *) continue ;;
        esac

        printf "\n  ${G5}[*]${NC} Fichier source (PC) : "
        read src
        [ -z "$src" ] || [ "$src" == "b" ] && continue
        if [ ! -e "$src" ]; then
            echo -e "  ${G4}[-] Introuvable.${NC}"; sleep 1; continue
        fi
        echo -e "  ${G5}[*]${NC} Transfert..."
        adb -s "${TARGET}" push "$src" "${DEST}/" && \
            echo -e "  ${G5}[+]${NC} ${WHITE}$(basename "$src")${NC} → ${DEST}"
        read -p "  Entree..."
    done
}

# Menu Pull
menu_pull() {
    while true; do
        afficher_banniere
        echo -e "${G4}  ▼ Pull File — Extraire des donnees de l'appareil${NC}\n"
        echo -e "  ${G4}┌────────────────────────────────────────────────────────┐${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[1]${NC} Camera               ${LGRAY}/sdcard/DCIM/Camera${NC}       ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[2]${NC} Downloads            ${LGRAY}/sdcard/Download${NC}          ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[3]${NC} Screenshots          ${LGRAY}/sdcard/Pictures/Screenshots${NC}${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[4]${NC} Musique              ${LGRAY}/sdcard/Music${NC}             ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[5]${NC} WhatsApp Media       ${LGRAY}.../WhatsApp/Media${NC}        ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[6]${NC} Telegram             ${LGRAY}/sdcard/Telegram${NC}          ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[7]${NC} Racine SD            ${LGRAY}/sdcard/${NC}                  ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[8]${NC} Saisie manuelle      ${LGRAY}chemin absolu${NC}             ${G4}│${NC}"
        echo -e "  ${G4}│${NC} ${WHITE}[0]${NC} Retour                                            ${G4}│${NC}"
        echo -e "  ${G4}└────────────────────────────────────────────────────────┘${NC}"
        printf "  ${G4}─►${NC} "
        read sel

        case $sel in
            1) SRC="/sdcard/DCIM/Camera" ;;
            2) SRC="/sdcard/Download" ;;
            3) SRC="/sdcard/Pictures/Screenshots" ;;
            4) SRC="/sdcard/Music" ;;
            5) SRC="/sdcard/Android/media/com.whatsapp/WhatsApp/Media" ;;
            6) SRC="/sdcard/Telegram" ;;
            7) SRC="/sdcard/" ;;
            8) printf "\n  ${G5}[*]${NC} Chemin absolu : "; read SRC
               [ -z "$SRC" ] && continue ;;
            0|b) return ;;
            *) continue ;;
        esac

        printf "\n  ${G5}[*]${NC} Destination PC [./] : "
        read dst; dst="${dst:-.}"
        mkdir -p "$dst" 2>/dev/null
        echo -e "  ${G5}[*]${NC} Telechargement depuis ${WHITE}${SRC}${NC}..."
        adb -s "${TARGET}" pull "$SRC" "$dst"
        echo -e "  ${G5}[+]${NC} Termine."
        read -p "  Entree..."
    done
}

# Initialisation
clear
afficher_banniere
printf "${G4}  ═══ SEQUENCE D INITIALISATION ═══${NC}\n\n"
adb disconnect > /dev/null 2>&1

echo -e "  ${WHITE}[1]${NC} USB → Wi-Fi auto   ${WHITE}[2]${NC} IP directe"
printf "  ${G4}─►${NC} "
read MODE_CONN

if [ "$MODE_CONN" = "2" ]; then
    printf "  ${G5}[*]${NC} IP (ex: 192.168.1.10:5555) : "
    read IP_D
    CONNECT_RESULT=$(timeout 15 adb connect "${IP_D}" 2>&1)
    if echo "${CONNECT_RESULT}" | grep -qi "connected\|already"; then
        TARGET="${IP_D}"
        echo -e "  ${G5}[+]${NC} Connecte : ${WHITE}${TARGET}${NC}"
    else
        echo -e "  ${G4}[-]${NC} Echec : ${CONNECT_RESULT:-Timeout}"; exit 1
    fi
else
    echo -e "  ${G5}[*]${NC} Branchez l'USB et autorisez le debogage..."
    while true; do
        DEVICES=$(adb devices | tail -n +2 | grep -v '^$')
        [ -z "$DEVICES" ] && sleep 1 && continue
        [[ "$DEVICES" =~ "unauthorized" ]] && \
            printf "  ${G6}[!]${NC} Acceptez la cle RSA sur le telephone.\r" && \
            sleep 3 && continue
        [[ "$DEVICES" =~ $'\tdevice' ]] && \
            echo -e "\n  ${G5}[+]${NC} Peripherique USB detecte." && break
        sleep 1
    done

    IP_C=""
    for IFACE in ap0 wlan1 wlan0; do
        IP_C=$(adb -d shell ip addr show $IFACE 2>/dev/null \
            | grep -oE 'inet [0-9.]+' | awk '{print $2}' | tr -d '\r')
        [ -n "$IP_C" ] && break
    done

    if [ -n "$IP_C" ]; then
        echo -e "  ${G5}[+]${NC} IP detectee : ${WHITE}${IP_C}${NC}"
        echo -e "  ${G5}[*]${NC} Activation TCP/IP sur port 5555..."
        adb -d tcpip 5555 > /dev/null 2>&1

        CONNECTED=0
        for attempt in 1 2 3 4 5; do
            printf "  ${G6}[~]${NC} Tentative %d/5 dans 3s...\r" "$attempt"
            sleep 3
            CONNECT_OUT=$(timeout 8 adb connect "${IP_C}:5555" 2>&1)
            if echo "$CONNECT_OUT" | grep -qi "connected\|already"; then
                CONNECTED=1; break
            fi
        done
        printf "\n"

        if [ "$CONNECTED" -eq 1 ]; then
            WAIT=0
            while adb devices | grep -F "${IP_C}" | grep -q "unauthorized"; do
                printf "  ${G6}[!]${NC} Autorisez la connexion Wi-Fi sur le telephone...\r"
                sleep 3
                timeout 8 adb connect "${IP_C}:5555" > /dev/null 2>&1
                WAIT=$((WAIT+1))
                [ "$WAIT" -gt 10 ] && break
            done
            printf "\n"
            TARGET="${IP_C}:5555"
            echo -e "  ${G5}[+]${NC} ${WHITE}Liaison Wi-Fi etablie.${NC} Cable USB debrayable."
        else
            echo -e "  ${G4}[-]${NC} Wi-Fi inaccessible apres 5 tentatives."
            echo -e "  ${G6}[!]${NC} Maintien en mode USB strict."
            TARGET=$(adb devices | tail -n +2 | awk '$2=="device"{print $1; exit}')
        fi
    else
        echo -e "  ${G6}[!]${NC} Aucune IP locale detectee — mode USB strict."
        TARGET=$(adb devices | tail -n +2 | awk '$2=="device"{print $1; exit}')
    fi
fi

read -p $'\n  [*] Entree pour acceder au panel...'

# Boucles principale
while true; do
    afficher_banniere
    afficher_menu

    printf "${G4}┌─(${NC}${WHITE}adb@pair${NC}${G4})-[${NC}${WHITE}%s${NC}${G4}]\n└─\$${NC} " \
        "${TARGET:-AUCUNE}"
    read choix

    case $choix in
        exit|quit) exit 0 ;;

        01)
            printf "  Cible : "; read it
            [ -z "$it" ] || [ "$it" == "b" ] && continue
            CONNECT_RESULT=$(timeout 15 adb connect "$it" 2>&1)
            if echo "${CONNECT_RESULT}" | grep -qi "connected\|already"; then
                TARGET="$it"
                echo -e "  ${G5}[+]${NC} Cible : ${WHITE}${TARGET}${NC}"
            else
                echo -e "  ${G4}[-]${NC} Echec : ${CONNECT_RESULT}"
            fi; sleep 1
            ;;
        02)
            if check_target; then
                if echo "${TARGET}" | grep -q ":"; then
                    IP_ONLY=$(echo "${TARGET}" | cut -d: -f1)
                    adb -s "${TARGET}" tcpip 5555 > /dev/null 2>&1
                    sleep 3
                    timeout 8 adb connect "${IP_ONLY}:5555" > /dev/null 2>&1
                    TARGET="${IP_ONLY}:5555"
                else
                    adb -s "${TARGET}" tcpip 5555 > /dev/null 2>&1
                fi
                echo -e "  ${G5}[+]${NC} TCP/IP reinitialise."; sleep 1
            fi
            ;;
        03) adb devices -l; read -p "  Entree..." ;;
        04) if check_target; then
                printf "  ${G6}[!]${NC} Confirmer reboot ? [o/N] : "
                read c; [[ "$c" =~ ^[oO]$ ]] && adb -s "${TARGET}" reboot
            fi ;;
        05) if check_target; then
                printf "  ${G6}[!]${NC} Confirmer reboot recovery ? [o/N] : "
                read c; [[ "$c" =~ ^[oO]$ ]] && adb -s "${TARGET}" reboot recovery
            fi ;;
        06) adb devices -l | grep -F "${TARGET}"; read -p "  Entree..." ;;

        11) if check_target; then
                printf "  APK : "; read ap
                [ -z "$ap" ] || [ "$ap" == "b" ] && continue
                [ ! -f "$ap" ] && echo -e "  ${G4}[-] Introuvable.${NC}" && \
                    read -p "  Entree..." && continue
                adb -s "${TARGET}" install -r "$ap"; read -p "  Entree..."
            fi ;;
        12) if check_target; then
                printf "  APK : "; read ap
                [ -z "$ap" ] || [ "$ap" == "b" ] && continue
                [ ! -f "$ap" ] && echo -e "  ${G4}[-] Introuvable.${NC}" && \
                    read -p "  Entree..." && continue
                if ! command -v aapt &>/dev/null; then
                    echo -e "  ${G4}[-] aapt manquant (sudo apt install aapt).${NC}"
                    read -p "  Entree..."; continue
                fi
                PKG=$(aapt dump badging "$ap" 2>/dev/null \
                    | awk -F"'" '/^package: name/{print $2}')
                ACT=$(aapt dump badging "$ap" 2>/dev/null \
                    | awk -F"'" '/launchable-activity: name/{print $2}')
                [ -z "$PKG" ] || [ -z "$ACT" ] && \
                    echo -e "  ${G4}[-] Impossible d extraire package/activite.${NC}" && \
                    read -p "  Entree..." && continue
                adb -s "${TARGET}" install -r "$ap" && \
                    adb -s "${TARGET}" shell am start -n "${PKG}/${ACT}"
                read -p "  Entree..."
            fi ;;
        13) if check_target; then menu_apps; fi ;;
        14) if check_target; then
                printf "  Package : "; read p
                [ -z "$p" ] || [ "$p" == "b" ] && continue
                printf "  ${G6}[!]${NC} Vider donnees de '${p}' ? [o/N] : "
                read c; [[ "$c" =~ ^[oO]$ ]] && adb -s "${TARGET}" shell pm clear "$p"
                sleep 1
            fi ;;
        15) if check_target; then
                adb -s "${TARGET}" shell pm list packages -3; read -p "  Entree..."
            fi ;;
        16) if check_target; then
                printf "  Package : "; read p
                [ -z "$p" ] || [ "$p" == "b" ] && continue
                adb -s "${TARGET}" shell am force-stop "$p"
                echo -e "  ${G5}[+]${NC} Arrete."; sleep 1
            fi ;;

        21) if check_target; then menu_push; fi ;;
        22) if check_target; then menu_pull; fi ;;
        23) if check_target; then
                mkdir -p ./screenshots
                TS=$(date +%s); OUT="./screenshots/sc_${TS}.png"
                adb -s "${TARGET}" exec-out screencap -p > "$OUT"
                if [ -s "$OUT" ]; then
                    echo -e "  ${G5}[+]${NC} ${WHITE}${OUT}${NC}"
                else
                    rm -f "$OUT"
                    echo -e "  ${G4}[-] Echec de capture.${NC}"
                fi; sleep 1
            fi ;;
        24) if check_target; then
                mkdir -p ./videos
                printf "  Duree (s) : "; read rt
                [ -z "$rt" ] || [ "$rt" == "b" ] && continue
                TS=$(date +%s); OUT="./videos/rec_${TS}.mp4"
                echo -e "  ${G5}[*]${NC} Enregistrement (${rt}s)..."
                adb -s "${TARGET}" shell screenrecord --time-limit "$rt" /sdcard/v_tmp.mp4
                adb -s "${TARGET}" pull /sdcard/v_tmp.mp4 "$OUT"
                adb -s "${TARGET}" shell rm /sdcard/v_tmp.mp4
                echo -e "  ${G5}[+]${NC} ${WHITE}${OUT}${NC}"; sleep 1
            fi ;;
        25) if check_target; then
                LOG="./logcat_$(date +%s).txt"
                adb -s "${TARGET}" logcat -d > "$LOG"
                echo -e "  ${G5}[+]${NC} ${WHITE}${LOG}${NC}"; sleep 1
            fi ;;
        26) if check_target; then
                printf "  Service (vide = battery) : "; read svc
                [ "$svc" == "b" ] && continue
                svc="${svc:-battery}"
                adb -s "${TARGET}" shell dumpsys "$svc" | head -60
                read -p "  Entree..."
            fi ;;

        31) if check_target; then
                printf "  URL : "; read u
                [ -z "$u" ] || [ "$u" == "b" ] && continue
                adb -s "${TARGET}" shell \
                    "am start -a android.intent.action.VIEW -d \"$u\""
            fi ;;
        32) if check_target; then adb -s "${TARGET}" shell; fi ;;

        i|I) if check_target; then
                echo ""
                printf "  ${LGRAY}%-13s${NC}: %s\n" "Modele" \
                    "$(adb -s "${TARGET}" shell getprop ro.product.model 2>/dev/null | tr -d '\r')"
                printf "  ${LGRAY}%-13s${NC}: %s\n" "Android" \
                    "$(adb -s "${TARGET}" shell getprop ro.build.version.release 2>/dev/null | tr -d '\r')"
                printf "  ${LGRAY}%-13s${NC}: %s\n" "SDK" \
                    "$(adb -s "${TARGET}" shell getprop ro.build.version.sdk 2>/dev/null | tr -d '\r')"
                printf "  ${LGRAY}%-13s${NC}: %s\n" "Serie" \
                    "$(adb -s "${TARGET}" shell getprop ro.serialno 2>/dev/null | tr -d '\r')"
                printf "  ${LGRAY}%-13s${NC}: %s\n" "IP Wi-Fi" \
                    "$(adb -s "${TARGET}" shell ip addr show wlan0 2>/dev/null \
                    | grep -oE 'inet [0-9.]+' | awk '{print $2}' | tr -d '\r')"
                read -p "  Entree..."
            fi ;;
        s|S) adb devices -l; read -p "  Entree..." ;;
        *) sleep 1 ;;
    esac
done

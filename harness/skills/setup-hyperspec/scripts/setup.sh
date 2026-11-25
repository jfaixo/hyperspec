#!/usr/bin/env sh
# POSIX shell deterministic setup script for Hyperspec
set -e

WORKSPACE_ROOT="$(pwd)"
HYPERSPEC_DIR="${WORKSPACE_ROOT}/.hyperspec"
SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
STANDARDS_DIR="${SCRIPT_DIR}/../assets/standards"
SELECTED_STANDARD=""

while [ $# -gt 0 ]; do
    case "$1" in
        -s|--standard)
            if [ -z "${2:-}" ]; then
                echo '{"status":"FAILED","error":"Missing value for --standard"}'
                exit 1
            fi
            SELECTED_STANDARD="$2"
            shift 2
            ;;
        --standard=*)
            SELECTED_STANDARD="${1#--standard=}"
            shift
            ;;
        -*)
            echo "{\"status\":\"FAILED\",\"error\":\"Unknown option: $1\"}"
            exit 1
            ;;
        *)
            if [ -n "$SELECTED_STANDARD" ]; then
                echo "{\"status\":\"FAILED\",\"error\":\"Unexpected argument: $1\"}"
                exit 1
            fi
            SELECTED_STANDARD="$1"
            shift
            ;;
    esac
done

echo "[setup-hyperspec] Initializing Hyperspec..."

if [ ! -d "${STANDARDS_DIR}" ]; then
    echo "{\"status\":\"FAILED\",\"error\":\"Standards directory not found at ${STANDARDS_DIR}\"}"
    exit 1
fi

STANDARD_COUNT=0
HAS_DEFAULT=0
for dir in "${STANDARDS_DIR}"/*; do
    if [ -d "$dir" ]; then
        STANDARD_COUNT=$((STANDARD_COUNT + 1))
        if [ "$(basename "$dir")" = "default" ]; then
            HAS_DEFAULT=1
        fi
    fi
done

if [ "$STANDARD_COUNT" -eq 0 ]; then
    echo "{\"status\":\"FAILED\",\"error\":\"No standards found in ${STANDARDS_DIR}\"}"
    exit 1
fi

if [ -n "$SELECTED_STANDARD" ]; then
    case "$SELECTED_STANDARD" in
        */*)
            echo "{\"status\":\"FAILED\",\"error\":\"Invalid standard name: ${SELECTED_STANDARD}\"}"
            exit 1
            ;;
    esac
    if [ ! -d "${STANDARDS_DIR}/${SELECTED_STANDARD}" ]; then
        echo "{\"status\":\"FAILED\",\"error\":\"Standard '${SELECTED_STANDARD}' not found in ${STANDARDS_DIR}\"}"
        exit 1
    fi
elif [ "$STANDARD_COUNT" -eq 1 ] && [ "$HAS_DEFAULT" -eq 1 ]; then
    SELECTED_STANDARD="default"
else
    echo "Available standards:"
    idx=0
    for dir in "${STANDARDS_DIR}"/*; do
        if [ -d "$dir" ]; then
            idx=$((idx + 1))
            echo "  ${idx}) $(basename "$dir")"
        fi
    done

    while [ -z "$SELECTED_STANDARD" ]; do
        if [ "$HAS_DEFAULT" -eq 1 ]; then
            printf "Select a standard (number or name) [default]: "
        else
            printf "Select a standard (number or name): "
        fi

        if ! IFS= read -r choice; then
            echo ""
            echo '{"status":"FAILED","error":"No standard selected in non-interactive mode. Pass a standard name as an argument."}'
            exit 1
        fi

        if [ -z "$choice" ] && [ "$HAS_DEFAULT" -eq 1 ]; then
            SELECTED_STANDARD="default"
            break
        fi

        case "$choice" in
            *[!0-9]*|"")
                case "$choice" in
                    */*) ;;
                    *)
                        if [ -n "$choice" ] && [ -d "${STANDARDS_DIR}/${choice}" ]; then
                            SELECTED_STANDARD="$choice"
                            break
                        fi
                        ;;
                esac
                ;;
            *)
                idx=0
                for dir in "${STANDARDS_DIR}"/*; do
                    if [ -d "$dir" ]; then
                        idx=$((idx + 1))
                        if [ "$idx" -eq "$choice" ]; then
                            SELECTED_STANDARD="$(basename "$dir")"
                            break
                        fi
                    fi
                done
                if [ -n "$SELECTED_STANDARD" ]; then
                    break
                fi
                ;;
        esac

        echo "Invalid selection: '${choice}'" >&2
        if [ ! -t 0 ]; then
            echo "{\"status\":\"FAILED\",\"error\":\"Invalid standard selection: ${choice}\"}"
            exit 1
        fi
    done
fi

SOURCE_ASSETS_DIR="${STANDARDS_DIR}/${SELECTED_STANDARD}"

mkdir -p "${HYPERSPEC_DIR}"
cp -R "${SOURCE_ASSETS_DIR}"/. "${HYPERSPEC_DIR}/"
echo "[setup-hyperspec] Installed standard '${SELECTED_STANDARD}' to ${HYPERSPEC_DIR}"

echo "{\"status\":\"SUCCESS\",\"version\":\"0.3.0\",\"standard\":\"${SELECTED_STANDARD}\"}"


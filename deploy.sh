#!/usr/bin/env bash
# ==============================================================================
# Interactive Terraform Environment & Folder Selector Script (Bash)
# ==============================================================================

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ENVS_DIR="${SCRIPT_DIR}/environment"

if [ ! -d "${ENVS_DIR}" ]; then
  ENVS_DIR="${SCRIPT_DIR}/environments"
fi

if [ ! -d "${ENVS_DIR}" ]; then
  echo "Error: Environment directory not found."
  exit 1
fi

mapfile -t AVAILABLE_ENVS < <(find "${ENVS_DIR}" -mindepth 1 -maxdepth 1 -type d -exec basename {} \; | sort)

if [ ${#AVAILABLE_ENVS[@]} -eq 0 ]; then
  echo "Error: No environment folders found in ${ENVS_DIR}"
  exit 1
fi

echo "=========================================================="
echo "         TERRAFORM ENVIRONMENT / FOLDER SELECTOR          "
echo "=========================================================="
echo "Available environment folders:"

PS3="Select folder number (or Ctrl+C to cancel): "
select ENV_CHOICE in "${AVAILABLE_ENVS[@]}"; do
  if [ -n "${ENV_CHOICE}" ]; then
    SELECTED_ENV="${ENV_CHOICE}"
    break
  else
    echo "Invalid option. Please try again."
  fi
done

echo ""
echo "Selected Folder: environment/${SELECTED_ENV}"
echo "----------------------------------------------------------"
echo "Select Terraform action:"

select ACTION in "init" "validate" "plan" "apply" "destroy" "quit"; do
  case ${ACTION} in
    "quit")
      echo "Exiting..."
      exit 0
      ;;
    "init"|"validate"|"plan"|"apply"|"destroy")
      SELECTED_ACTION="${ACTION}"
      break
      ;;
    *)
      echo "Invalid action. Try again."
      ;;
  esac
done

TARGET_DIR="${ENVS_DIR}/${SELECTED_ENV}"
echo ""
echo ">>> Executing: terraform -chdir=\"${TARGET_DIR}\" ${SELECTED_ACTION}"
echo "=========================================================="

terraform -chdir="${TARGET_DIR}" "${SELECTED_ACTION}"


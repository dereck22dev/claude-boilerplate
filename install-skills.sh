#!/usr/bin/env bash
# Reads claude-boilerplate/skills.txt, filters by --categories, installs into ./.claude/.
# Works on macOS, Linux, Git Bash on Windows, WSL.
#
# Usage:
#   ./install-skills.sh                              # default: core,dev,design
#   ./install-skills.sh --categories all
#   ./install-skills.sh --categories core,mobile

set -euo pipefail

categories="core,dev,design"
while [ "$#" -gt 0 ]; do
    case "$1" in
        --categories) categories="$2"; shift 2 ;;
        --categories=*) categories="${1#*=}"; shift ;;
        *) echo "Unknown arg: $1" >&2; exit 1 ;;
    esac
done

script_dir="$(cd "$(dirname "$0")" && pwd)"
skills_file="$script_dir/skills.txt"

if [ ! -f "$skills_file" ]; then
    echo "skills.txt not found at $skills_file" >&2
    exit 1
fi

# Normalise to a space-padded list for substring match (e.g. " core dev design ")
cat_set=" $(echo "$categories" | tr ',' ' ' | xargs) "
install_all=0
case "$cat_set" in *" all "*) install_all=1 ;; esac

if [ -t 1 ]; then
    CYAN='\033[36m'; YELLOW='\033[33m'; MAGENTA='\033[35m'; GREEN='\033[32m'; GREY='\033[90m'; RESET='\033[0m'
else
    CYAN=''; YELLOW=''; MAGENTA=''; GREEN=''; GREY=''; RESET=''
fi

# Parse: drop comments + blank lines; keep "<cat> <kind> <name>"
mapfile -t lines < <(sed -E 's/#.*$//' "$skills_file" | awk 'NF >= 3')

skills=(); agents=(); seen_cats=""
for line in "${lines[@]}"; do
    read -r cat kind name <<<"$line"
    case " $seen_cats " in *" $cat "*) ;; *) seen_cats="$seen_cats $cat" ;; esac

    match=0
    case "$cat_set" in *" $cat "*) match=1 ;; esac
    if [ "$install_all" -eq 1 ] || [ "$match" -eq 1 ]; then
        case "$kind" in
            skill) skills+=("$name") ;;
            agent) agents+=("$name") ;;
            *)     echo "Unknown kind '$kind' in skills.txt" >&2; exit 1 ;;
        esac
    fi
done

echo
printf "${GREY}Categories : %s${RESET}\n" "$(echo "$cat_set" | xargs)"
printf "${GREY}Source     : %s${RESET}\n" "$skills_file"
printf "${GREY}Working dir: %s${RESET}\n" "$(pwd)"
printf "${CYAN}Installing %d skills + %d agents into .claude/${RESET}\n" "${#skills[@]}" "${#agents[@]}"
echo

if [ "${#skills[@]}" -eq 0 ] && [ "${#agents[@]}" -eq 0 ]; then
    echo "No skills/agents matched categories: $(echo "$cat_set" | xargs)" >&2
    echo "Available categories:$seen_cats" >&2
    exit 1
fi

for s in "${skills[@]}"; do
    printf "${YELLOW}[skill] %s${RESET}\n" "$s"
    npx --yes claude-code-templates@latest --skill "$s"
done

for a in "${agents[@]}"; do
    printf "${MAGENTA}[agent] %s${RESET}\n" "$a"
    npx --yes claude-code-templates@latest --agent "$a"
done

echo
printf "${GREEN}Done. Open Claude Code in this directory and type / to see the new commands.${RESET}\n"

#!/usr/bin/env bash
# Bootstrap a new Claude Code project from this boilerplate.
# Works on macOS, Linux, Git Bash on Windows, WSL.
#
# Usage:
#   ./new-project.sh <path> <name>
#   ./new-project.sh <path> <name> --categories core,mobile --init-git
#   ./new-project.sh <path> <name> --skip-skills

set -euo pipefail

if [ "$#" -lt 2 ]; then
    cat <<'EOF' >&2
Usage: new-project.sh <path> <name> [--categories LIST] [--skip-skills] [--init-git]

  --categories  Comma-separated install categories (default: core,dev,design)
                Use "all" to install everything.
EOF
    exit 1
fi

target_path="$1"
project_name="$2"
shift 2

categories="core,dev,design"
skip_skills=0
init_git=0
while [ "$#" -gt 0 ]; do
    case "$1" in
        --skip-skills)   skip_skills=1; shift ;;
        --init-git)      init_git=1; shift ;;
        --categories)    categories="$2"; shift 2 ;;
        --categories=*)  categories="${1#*=}"; shift ;;
        *) echo "Unknown flag: $1" >&2; exit 1 ;;
    esac
done

boilerplate="$(cd "$(dirname "$0")" && pwd)"
templates="$boilerplate/templates"

mkdir -p "$target_path"
resolved="$(cd "$target_path" && pwd)"

if [ -t 1 ]; then
    CYAN='\033[36m'; YELLOW='\033[33m'; GREEN='\033[32m'; GREY='\033[90m'; RESET='\033[0m'
else
    CYAN=''; YELLOW=''; GREEN=''; GREY=''; RESET=''
fi

printf "${CYAN}Bootstrapping project at %s${RESET}\n" "$resolved"

# --- Root-level files (with templating) ---
sed "s/{{PROJECT_NAME}}/${project_name//\//\\/}/g" "$boilerplate/CLAUDE.md" > "$resolved/CLAUDE.md"
sed "s/{{PROJECT_NAME}}/${project_name//\//\\/}/g" "$templates/CLAUDE.local.md" > "$resolved/CLAUDE.local.md"

cp "$boilerplate/WORKFLOW.md"   "$resolved/WORKFLOW.md"
cp "$boilerplate/plugins.txt"   "$resolved/plugins.txt"
cp "$templates/.gitignore"      "$resolved/.gitignore"

# --- docs/ scaffolding ---
mkdir -p "$resolved/docs/solutions" "$resolved/docs/specs"
cp "$templates/docs/solutions/INDEX.md" "$resolved/docs/solutions/INDEX.md"

# --- .claude/ ---
mkdir -p "$resolved/.claude/commands"
cp "$templates/settings.json"       "$resolved/.claude/settings.json"
cp "$templates/settings.local.json" "$resolved/.claude/settings.local.json"
cp "$templates/commands/"*.md       "$resolved/.claude/commands/"

# --- Optional: git init ---
if [ "$init_git" -eq 1 ]; then
    (cd "$resolved" && git init -q)
    printf "${GREY}Initialized git repo${RESET}\n"
fi

# --- Skills install (filtered by categories) ---
if [ "$skip_skills" -eq 0 ]; then
    echo
    printf "${CYAN}Installing skills + agents (categories: %s)...${RESET}\n" "$categories"
    (cd "$resolved" && bash "$boilerplate/install-skills.sh" --categories "$categories")
fi

echo
printf "${GREEN}Project ready at %s${RESET}\n" "$resolved"
echo
printf "${YELLOW}Next steps:${RESET}\n"
echo "  1. Edit CLAUDE.md - fill in stack, verification commands, gotchas"
echo "  2. Edit CLAUDE.local.md (gitignored) - your personal context"
echo "  3. Open Claude Code in $resolved"
echo "  4. Paste the /plugin commands from plugins.txt"
echo "  5. Run: /start-feature <feature-slug>  (or /fast for trivial fixes)"

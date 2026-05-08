# Claude Code project boilerplate

Bootstrap any new project with the **gstack + Superpowers + Compound Engineering + claude-code-templates + alirezarezvani/claude-skills** stack, the 11-step workflow (with a fast lane for trivial changes), and the optimisations from the [official best practices](https://code.claude.com/docs/fr/best-practices).

## Layout

```text
claude-boilerplate/
├── README.md             # this file
├── new-project.ps1       # PowerShell bootstrap (Windows)
├── new-project.sh        # Bash bootstrap (macOS / Linux / Git Bash / WSL)
├── install-skills.ps1    # PowerShell installer — reads skills.txt, filters by --categories
├── install-skills.sh     # Bash installer — reads skills.txt, filters by --categories
├── skills.txt            # SINGLE SOURCE — categorised list of skills + agents
├── plugins.txt           # /plugin commands (annotated by use-case)
├── CLAUDE.md             # SLIM project template (best-practice compliant)
├── WORKFLOW.md           # 11-step process + fast-lane reference
└── templates/
    ├── settings.json         # committed: ENABLE_PLUGINS + safe-command allowlist
    ├── settings.local.json   # local-only: personal permissions
    ├── CLAUDE.local.md       # personal notes (gitignored)
    ├── .gitignore            # excludes settings.local, CLAUDE.local, secrets
    ├── docs/solutions/
    │   └── INDEX.md          # tag-indexed solutions table (read by /ce-plan)
    └── commands/
        ├── start-feature.md  # /start-feature — full 11-step lane
        └── fast.md           # /fast — trivial-change lane (skips gates + parallel reviews)
```

## Install profiles (categories)

Each installed skill/agent loads its description into context at session start. Fewer skills = leaner ambient context = more room for real work. `skills.txt` groups them so you only install what your project uses.

| Category       | Items | Use when                                                                           |
| -------------- | ----- | ---------------------------------------------------------------------------------- |
| `core`         | 5     | Always. Code review, clean code, brainstorming, architect, security-auditor agent. |
| `dev`          | 7     | Any code project. Senior FE/BE/fullstack/security skills + FE/BE/DB agents.        |
| `design`       | 3     | UI-heavy work. frontend-design + ui-ux-pro-max skills + ui-ux-designer agent.      |
| `mobile`       | 2     | Mobile apps. mobile-design skill + mobile-developer agent.                         |
| `marketing`    | 1     | Public sites with SEO/content needs.                                               |
| `advanced`     | 4     | Multi-team / long-context / doc-heavy.                                             |
| `design-extra` | 1     | canvas-design (large font payload — opt-in only).                                  |
| `all`          | 23    | Everything.                                                                        |

**Default profile when bootstrapping:** `core,dev,design` = 15 items (typical web/SaaS project).

Token-cost rule of thumb: each skill/agent ≈ 200–500 tokens of description loaded per session. Going from `all` (23) to `core` (5) saves an estimated 4–9k tokens per session. Default profile (`core,dev,design` = 15) saves ~2–4k vs `all`.

## What you get when you bootstrap a project

| File / dir                          | Purpose                                                             |
| ----------------------------------- | ------------------------------------------------------------------- |
| `CLAUDE.md`                         | Slim project rules (stack, verification, token discipline, gotchas) |
| `CLAUDE.local.md`                   | Your personal context, gitignored                                   |
| `WORKFLOW.md`                       | 11-step process + fast lane                                         |
| `plugins.txt`                       | Annotated `/plugin` commands                                        |
| `.gitignore`                        | Pre-configured                                                      |
| `.claude/settings.json`             | Marketplaces + plugins pre-declared + safe-command allowlist        |
| `.claude/settings.local.json`       | Empty stub for personal permission additions                        |
| `.claude/commands/start-feature.md` | `/start-feature <name>` — Phase 1 (95% prompt + spec)               |
| `.claude/commands/fast.md`          | `/fast <description>` — fast-lane for trivial changes               |
| `.claude/skills/`                   | Skills filtered by your install profile                             |
| `.claude/agents/`                   | Agents filtered by your install profile                             |
| `docs/specs/`                       | Output of `/start-feature` and `/ce-brainstorm`                     |
| `docs/solutions/INDEX.md`           | Tag-indexed table of `/ce-compound` learnings                       |
| `docs/solutions/*.md`               | Full solution docs (one per merged feature)                         |

## Prerequisites — once per machine

### 1. Update Claude Code (so `/plugin` works)

```powershell
npm i -g @anthropic-ai/claude-code@latest
```

### 2. Install gstack globally (it's NOT a plugin)

From Git Bash (Laragon ships it):

```bash
git clone --single-branch --depth 1 https://github.com/garrytan/gstack.git ~/.claude/skills/gstack
cd ~/.claude/skills/gstack && ./setup
```

## Bootstrap a new project

### Windows (PowerShell)

```powershell
cd \path\to\claude-boilerplate
.\new-project.ps1 -Path my-app -Name "My App" -InitGit
# minimal install (5 items):
.\new-project.ps1 -Path my-app -Name "My App" -Categories core
# everything (23 items):
.\new-project.ps1 -Path my-app -Name "My App" -Categories all
# mobile project:
.\new-project.ps1 -Path my-app -Name "My App" -Categories core,dev,mobile
```

Flags: `-Categories <list>` (default `core,dev,design`), `-SkipSkills`, `-InitGit`.

### macOS / Linux / Git Bash on Windows / WSL

```bash
cd /path/to/claude-boilerplate
./new-project.sh ~/dev/my-app "My App" --init-git
./new-project.sh ~/dev/my-app "My App" --categories core
./new-project.sh ~/dev/my-app "My App" --categories all
./new-project.sh ~/dev/my-app "My App" --categories core,dev,mobile
```

If the scripts aren't executable yet: `chmod +x new-project.sh install-skills.sh`.

## Bootstrap an existing project

```powershell
cd \path\to\my-existing-app
& claude-boilerplate\install-skills.ps1 -Categories core,dev
copy claude-boilerplate\CLAUDE.md .
copy claude-boilerplate\WORKFLOW.md .
copy claude-boilerplate\templates\settings.json .claude\
copy claude-boilerplate\templates\commands\*.md .claude\commands\
```

```bash
cd ~/path/to/my-existing-app
bash /path/to/claude-boilerplate/install-skills.sh --categories core,dev
cp /path/to/claude-boilerplate/CLAUDE.md .
cp /path/to/claude-boilerplate/WORKFLOW.md .
mkdir -p .claude/commands
cp /path/to/claude-boilerplate/templates/settings.json .claude/
cp /path/to/claude-boilerplate/templates/commands/*.md .claude/commands/
```

## Token-cost optimisations applied

Per [code.claude.com/docs/fr/best-practices](https://code.claude.com/docs/fr/best-practices):

- **Profiled skill install** — `skills.txt` is categorised; default install ≈ 13 items vs 23. Saves ~4–9k tokens of session-start ambient context.
- **Slim CLAUDE.md** — only non-deductible facts. Token-discipline rules built in (`/clear`, subagents, `/btw`, Plan Mode).
- **Fast lane (`/fast`)** — trivial changes skip gates and parallel reviewers entirely. Hard stops on security-sensitive paths.
- **`docs/solutions/INDEX.md`** — `/ce-plan` reads the tag index instead of the full directory. Prevents `/ce-compound` exhaust from polluting future plans.
- **Annotated `plugins.txt`** — only core plugins uncommented. Business/marketing/content plugins commented for opt-in.
- **`@WORKFLOW.md` import** — workflow referenced, not duplicated. Loads on demand.
- **Permissions allowlist** — Read/Glob/Grep + safe Bash pre-approved → fewer permission prompts (which themselves consume turns).
- **Local vs committed config** — `settings.json` shared, `settings.local.json` personal. `CLAUDE.local.md` personal context.
- **Custom commands** — `/start-feature` and `/fast` encode the routing rules so they don't need to live in CLAUDE.md.
- **Subagent guidance** — explicit "delegate `>3 file reads` to a subagent" rule. Investigations don't pollute the main context.

## Customise

- **Add/remove skills**: edit [skills.txt](./skills.txt). Format `<category> <kind> <name>`. Both installers pick it up.
- **Add a category**: just use a new label in column 1, then bootstrap with `--categories your-new-cat`.
- **Add commands**: drop `.md` files in `templates/commands/`. They land in `.claude/commands/` of every new project.
- **Edit `CLAUDE.md` per project**: keep `Verification`, `Workflow`, `Token discipline`, and `Specialized agents` sections — that's what makes the workflow durable.

## Verify the boilerplate is working

After bootstrap, in Claude Code, type `/` — you should see:

- `/start-feature`, `/fast` (custom)
- `/ce-brainstorm`, `/ce-plan`, `/ce-work`, `/ce-code-review`, `/ce-compound` (after `/plugin install compound-engineering`)
- `/office-hours`, `/plan-ceo-review`, `/plan-eng-review`, `/qa` (after gstack install)

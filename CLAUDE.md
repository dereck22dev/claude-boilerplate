# {{PROJECT_NAME}}

{{ONE-LINE PROJECT DESCRIPTION}}

## Stack

- {{Language / framework}}
- {{Database}}
- {{Hosting / runtime quirks}}

## Verification — run after any code change

{{REPLACE WITH PROJECT COMMANDS}}

- Tests: `{{npm test / pytest / php artisan test}}`
- Typecheck: `{{npm run typecheck / mypy / phpstan}}`
- Lint: `{{npm run lint / ruff / pint}}`

**Address root causes. Never silence a failing test or lint rule to make it pass.**

## Workflow

This project follows @WORKFLOW.md (3 phases, 11 steps + a fast lane for trivial changes).

- **Fast lane** for typos, one-liners, dep bumps: `/fast <description>` — skips gates and `/ce-*` parallel runs.
- **Full lane** for features: `/start-feature <name>` — both gates required before any code.
- **`/ce-compound` after every merged feature** (skip for fast-lane changes).
- **Read `docs/solutions/INDEX.md` (NOT the full directory)** before `/ce-plan`.

## Token discipline — non-negotiable

Per [official best practices](https://code.claude.com/docs/fr/best-practices):

- **`/clear` between unrelated tasks.** A polluted context degrades output quality.
- **Use subagents for investigation** (>3 file reads to answer one question). Their context is separate; only the summary returns.
- **`/btw` for side questions.** Answer stays in an overlay, never enters the main conversation.
- **Plan Mode for changes spanning >3 files or unfamiliar code.** Skip it for typos.
- **Reference files with `@filename`**, never describe paths in prose.

## Specialized agents — delegate explicitly

Full list in `.claude/agents/`. Use the Agent tool with `subagent_type: <name>`.

- **Security-sensitive** (auth, secrets, SQL, file uploads, deserialisation): `security-auditor` BEFORE `code-reviewer`.
- **System design / dependencies**: `senior-architect` or `backend-architect`.
- **DB schema / migrations**: `database-architect`.
- **Multi-team feature** (FE+BE+mobile at once): `multi-agent-coordinator`.

## Project rules

- Pull patterns from THIS repo first; `/ce-plan` does this automatically.
- Verify UI changes visually (screenshot) before claiming done.

## Project gotchas

{{ADD non-obvious things the agent must know — env quirks, "this looks wrong but it's intentional", deploy traps. Each line should fail Claude if removed.}}

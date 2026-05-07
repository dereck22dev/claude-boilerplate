---
description: Fast lane for trivial changes — skip gates, skip /ce-* parallel runs, just implement+verify
allowed-tools: Read, Glob, Grep, Edit, Write, Bash
argument-hint: short description of the change
---

You are running the **fast lane** for: `$ARGUMENTS`

This skips the 11-step workflow because the change is trivial. Per @WORKFLOW.md "Fast lane" section.

## Self-check before proceeding

The fast lane requires ALL of:

1. Diff likely ≤ ~30 lines or one file.
2. No architectural impact.
3. Describable in one sentence.
4. NOT security-sensitive (auth, secrets, SQL, file uploads, deserialisation, crypto).

Before any change, list the files you'll touch. If the answer surprises you, ABORT this command and tell the user to run `/start-feature` instead.

## Process

1. Make the change directly with Edit / Write. No Plan Mode unless you discover unexpected complexity.
2. Run the verification commands from `CLAUDE.md` (tests, typecheck, lint). All must pass — address root causes, never silence failures.
3. Print a one-line summary of what changed.
4. **Do NOT run `/ce-compound`** — there's nothing to capture from a trivial change.
5. **Do NOT spawn review subagents** — overkill for this scope.

## Hard stops

- If you find yourself touching > 1 file or > ~30 lines: STOP. Tell the user the change is bigger than fast-lane scope; recommend `/start-feature`.
- If the change touches `auth/`, `security/`, secrets, or SQL: STOP. Recommend `/start-feature` so `security-auditor` runs.
- If verification fails: address the root cause once. If it fails again, STOP — that's a sign the change wasn't fast-lane material.

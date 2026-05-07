---
description: Start a new feature using the 11-step workflow (both gates included)
allowed-tools: Read, Glob, Grep, Bash, Write, AskUserQuestion
argument-hint: feature-slug
---

You are starting a new feature for this project. Follow @WORKFLOW.md strictly. Argument: `$ARGUMENTS` (use as the feature slug).

## Step 1 — 95% confidence (THIS STEP, NOW)

Interview the user with the AskUserQuestion tool, in rounds of 3–4 questions max. Goal: 95% confidence about what they **actually** want — not what they think they should want.

- Challenge their assumptions out loud
- Surface edge cases they haven't considered
- Force trade-off decisions (perf vs simplicity, ship now vs ship right, scope in vs out)
- Don't ask things you can read from the code — use Grep/Glob first

Stop only when you could write a spec they would not change.

Then write the spec to `docs/specs/$ARGUMENTS-spec.md` with these sections:
- **Problem** — one paragraph
- **Users / scenarios** — concrete
- **Scope** — in / out, bullet lists
- **Constraints** — perf, deadlines, compliance
- **Open questions** — anything still soft

Read `docs/solutions/` first if it exists — prior `/ce-compound` runs may have learnings that affect the spec.

## Steps 2–4 — Gates

Tell the user to run, in order:

1. `/office-hours` — gstack stress-test
2. `/plan-ceo-review` — product gate (real problem, worth building)
3. `/plan-eng-review` — architecture gate (foundation holds, deps clean)

If either gate fails, the spec is wrong. **Return to step 1 — do not patch the spec to make a gate pass.**

## Steps 5+ — Build phase

Only after both gates pass, the user runs:

- `/ce-brainstorm` → spec refinement
- `/ce-plan` → research-grounded implementation plan
- `/ce-work` → execute with task tracking
- `/ce-code-review` + `/qa` → pre-merge
- `/ce-compound` → post-merge learning capture (DO NOT SKIP)

## Hard rule

**DO NOT write production code inside this command.** Output is a spec + a routing instruction to the user.

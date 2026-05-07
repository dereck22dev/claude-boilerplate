# Workflow — 3 phases, 11 steps

The bulk of the value lives **before** and **after** coding. Treat steps 1–4 as a gate and step 10 as non-optional.

---

## Phase 1 — Build the right thing (steps 1–4)

### Step 1. The 95% confidence prompt

Before opening any tool, paste this verbatim into Claude Code:

> I'm about to start this project: **[YOUR PROJECT IN 1–2 SENTENCES]**.
> Interview me until you have 95% confidence about what I actually want — not what I think I should want. Challenge my assumptions. Ask about edge cases I haven't considered.

This flips the dynamic: the agent interviews you. ~10–15 minutes.

### Step 2. `/office-hours` (gstack)

Describe what you're building. gstack stress-tests the idea from multiple angles.

### Step 3. `/plan-ceo-review` (gstack)

Product gate. Is it worth building? Real problem? **If it fails, go back to step 1.**

### Step 4. `/plan-eng-review` (gstack)

Architecture gate. Solid foundation? Clean dependencies? **Both gates must pass before any code.**

---

## Phase 2 — Build it right (steps 5–9)

### Step 5. `/ce-brainstorm` (Compound Engineering)

Validated idea + both gates passed. CE explores requirements and condenses into a spec.

### Step 6. `/ce-plan` (CE)

Parallel research agents scan your repo: history, code patterns, commit logs. The plan reflects **your project's reality**, not generic best practice.

### Step 7. `/ce-work` (CE)

Execute with task tracking. If 1–6 were clean, this runs smoothly.

### Step 8. `/ce-code-review` (CE)

≥6 reviewers in parallel: correctness, security, performance, tests, maintainability, adversarial. Independent reports. *(Anthropic finding: builders don't review themselves.)*

### Step 9. `/qa` (gstack)

Real browser, real clicks, real user flow on staging. Code review catches code bugs. QA catches experience bugs.

---

## Phase 3 — Learn (steps 10–11)

### Step 10. `/ce-compound` (CE) — DO NOT SKIP

Run after every feature or bug fix. Five sub-agents in parallel:

| Agent | Output |
| --- | --- |
| Context analyzer | What was the problem |
| Solution extractor | What worked, what failed, root cause |
| Related-docs finder | Updates older docs with new findings |
| Prevention strategist | How to avoid this class of issue |
| Category classifier | Tags for future retrieval |

Output → `docs/solutions/`. Next time you run `/ce-plan`, the planner already knows what you learned.

### Step 11. Ship it

Push. Start the next feature at step 1 — with a smarter planning layer.

---

## The sequence logic

- **1–4** ensure you build the right thing.
- **5–9** ensure you build it correctly.
- **10** ensures next time is faster.

Skip 1–4 → you build something nobody needs.
Skip 10 → you debug the same problem twice.

---

## Quick-start (smallest viable version)

1. Run only step 1 (the 95% prompt) on your next project.
2. Add `/office-hours` after a few projects.
3. Layer in CE once you're comfortable.

---

## Fast lane — for trivial changes

The 11-step workflow is for **features**. It's overkill for typos, one-line fixes, log-additions, dependency bumps, etc. Running gates + parallel reviewers + `/ce-compound` on a 3-line change burns tokens for no benefit.

**Use the fast lane when ALL of these are true:**

- The diff fits in your head (≤ ~30 lines or one file).
- The change has no architectural impact.
- You can describe it in one sentence ("rename `getCwd` to `getCurrentWorkingDirectory`").
- It's not security-sensitive (auth, secrets, SQL, file uploads, deserialisation).

**Fast-lane process:**

1. Skip Plan Mode (per official best practices).
2. Make the change directly. No `/start-feature`, no gates.
3. Run the project verification commands listed in `CLAUDE.md` (tests, typecheck, lint).
4. Commit with a short descriptive message.
5. **Skip `/ce-compound`** — there's nothing to learn from a typo fix.

**Use the slash command `/fast <description>`** to enforce this lane. It blocks itself if the change touches sensitive files.

If during fast lane you discover the change is bigger than expected — STOP, `/clear`, restart with `/start-feature`. Don't drift into a feature build with no spec.

---

## Token discipline — applies to BOTH lanes

Per [official best practices](https://code.claude.com/docs/fr/best-practices):

- **`/clear` between unrelated tasks** — keeps the main context lean.
- **Use subagents for investigation** — file reads happen in a separate context window; only the summary returns.
- **`/btw` for side questions** — answer doesn't pollute the main conversation.
- **Plan Mode for >3-file changes** — exploration stays out of the implementation context.
- **Read `docs/solutions/INDEX.md` first**, not the full `solutions/` directory, to find prior learnings.

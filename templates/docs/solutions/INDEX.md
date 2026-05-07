# Solutions index

`/ce-compound` writes one file per merged feature into `docs/solutions/`. Over time the directory grows. **Reading the whole folder during `/ce-plan` wastes tokens.**

This index is the lookup table. Add one row per solution file. `/ce-plan` should consult this first and only read the full files for tags relevant to the current task.

## How to use

When `/ce-compound` finishes, append a row below with:

- **File** — relative link to the solution doc.
- **Tags** — comma-separated keywords that describe the problem space (auth, perf, db-migration, react-hooks, etc.).
- **One-line takeaway** — what to do or avoid next time. The bit you'd want a future planner to see without reading the full doc.

## Index

| Date | File | Tags | Takeaway |
| --- | --- | --- | --- |
| YYYY-MM-DD | [example.md](./example.md) | example, template | Replace this row with real entries. |

## Rules

- **One row = one feature/fix.** Don't merge multiple takeaways.
- **Tags are search terms**, not categories. Pick what you'd actually grep for.
- **No prose in the takeaway** — fragment, ≤ 12 words.
- If a takeaway needs more nuance, that's what the linked doc is for.

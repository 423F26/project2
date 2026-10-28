# Agile progress

The [project backlog](project-backlog.xlsx), [sprint backlog](sprint-backlog.xlsx), and [burndown](burndown.xlsx) were reviewed against the C runtime on 2026-10-28. The original 30 product outcomes and ESOF 423 checkpoint dates remain the planning baseline. The sprint assignments are proposals, not evidence that a checkpoint was met.

| Acceptance status | Items | Meaning |
| --- | ---: | --- |
| Done | 1 | P09: five built-in effects are selectable and adjustable, with C and protocol tests. |
| In progress | 10 | Software or design work exists, but the stated acceptance check is still open. |
| Planned | 19 | No current implementation or sufficient acceptance evidence. |

The burndown therefore shows **29 open items as of 2026-10-28**. Its future phase balances remain a plan. Historical actual balances are blank because no dated sprint review results were supplied. Do not backfill them from current repository state.

Key next checks are a sustained Raspberry Pi capture/playback run, audible bypass and output-level checks, ADAC board bring-up, GPIO switch validation, and a measured end-to-end latency test. The current software tests cannot establish those hardware outcomes. The C tuner is a deterministic baseline; the backlog's pitch ML items remain open. P25 now follows the [gesture-aware effect assist roadmap](../dev/ml-roadmap.md) rather than the former timbre-effect proposal.

Update an item to **Done** only when its acceptance evidence is recorded. Keep the same status and evidence note in both backlog workbooks. Change the burndown's current remaining count when an item is accepted; enter actual remaining at a phase only after a dated review. Owners are left blank until assigned.

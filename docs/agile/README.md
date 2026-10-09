# Agile artifact audit

This directory contains two spreadsheet snapshots of project planning. They do not record completed sprint work or verify current product performance. Treat the code and tests as evidence of implemented behavior, and record new sprint status or measured latency only after the project team supplies it.

## What the workbooks contain

| Artifact | Recorded content | Limit |
| --- | --- | --- |
| [Sprint and project backlog](esof-backlog.xlsx) | Three sprint goals with tasks; two populated project-backlog entries | No owner, date, estimate, acceptance check, or completion status. Rows 3–37 of the project-backlog sheet are blank. |
| [Burndown chart](burndown-chart.xlsx) | Sprints 1–5 on the x-axis; 1,000 units remaining at sprint 1 and 500 at sprint 2 | The unit and source of the two values are undefined. Sprints 3–5 have no remaining-work values. The chart references blank cells for those sprints. |

No workbook formula links the burndown to backlog items. The values cannot be reconciled to item counts or used to infer progress from the repository.

## Plan versus current implementation

| Backlog item | Current repository evidence | What remains unverified |
| --- | --- | --- |
| Train ML note identification; test WAV input | Offline scan, train, predict, and tests exist in `ml_guitar_pedal/` and `tests/`. | Performance on the project's actual recordings and target hardware. |
| Integrate audio input/output; add guitar effect model | ALSA capture/playback and software overdrive exist. | A live hardware test and end-to-end audio latency. The code's effect is DSP overdrive, not a trained ML effect model. |
| Build a user-testable alpha | Terminal mode control, GPIO footswitch adapter, and localhost browser UI exist. | User testing and target-device validation. |
| Add touchscreen UI, Pi screen, and PCB | No touchscreen-specific integration or PCB design artifact is present in this repository. | Whether work exists outside this repository or remains planned. |
| Latency under 10 milliseconds | `Project Backlog!A2` states the long-term goal. The immediate minimum acceptable product target is 30 ms. The CLI currently checks p95 below 30 ms for classifier computation only. | A shared product-latency metric, test method, and hardware result. The classifier computation check cannot verify either product target on its own. |

The guides in [user](../user/README.md) and [dev](../dev/README.md) describe the current code. This table maps the older plan to that code without marking sprint items complete.

## Reconcile future updates

Before using the spreadsheets for reporting, the project owner should define the burndown work unit, assign estimates and statuses to backlog items, and add dates or sprint boundaries. Track 30 ms as the immediate minimum acceptable product target and 10 ms as the long-term goal. Measure and name each latency metric separately: algorithm computation p95, audio buffer time, or full input-to-output delay. Record the hardware and method with each measurement. Leave missing sprint values blank until actual data is available.

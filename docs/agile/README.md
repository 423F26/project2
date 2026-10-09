# Agile artifact audit

This directory preserves two original spreadsheet snapshots and two versions of the full-product vision plan. The [ESOF-aligned timeline](vision/esof-timeline/) is the current planning version; the earlier [undated vision](vision/) remains for comparison. The original files do not record completed sprint work or verify current product performance. Treat the code and tests as evidence of implemented behavior, and record new sprint status or measured latency only after the project team supplies it.

## Full-product vision workbooks

| Workbook | Purpose |
| --- | --- |
| [Project backlog](vision/esof-timeline/project-backlog-vision.xlsx) | Thirty proposed outcomes with acceptance evidence and dependency IDs. MVP and final horizons are separate. Owner and status fields are blank. |
| [Sprint backlog and ESOF timeline](vision/esof-timeline/sprint-backlog-vision.xlsx) | Each project ID appears once. A separate sheet records all twelve ESOF 423 `todo` entries and due dates from October 16 through December 17, 2026. Dates are source milestones; project assignments are proposed. |
| [Burndown plan](vision/esof-timeline/burndown-vision.xlsx) | Planned count of remaining unweighted items by ESOF-aligned phase. Actual remaining is blank until reviewed. |

These files describe the intended Raspberry Pi pedal: screen and player UI, dedicated GPIO interface circuit and PCB, 3D-printed case, guitar audio interface, presets, several effects including an ML audio effect, reliable startup, and validation on hardware. The immediate 30 ms minimum is proposed for the December 4 Production Readiness checkpoint. The 10 ms long-term goal remains undated after the ESOF course timeline. The measurement method and results still need to be recorded. Project IDs connect the two backlogs; the burndown's assigned-item counts must be updated if sprint assignments change. The Playwright exercise, post mortem, and presentation attendance remain course tasks or events rather than product acceptance evidence.

## What the original workbooks contain

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

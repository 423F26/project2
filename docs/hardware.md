# Hardware files

The [ZynADAC overview](../HW/piADAC/README.md) describes the audio interface. The current design sources and required KiCad libraries are under `HW/piADAC/`: the [schematic](../HW/piADAC/piADAC.kicad_sch), [PCB](../HW/piADAC/piADAC.kicad_pcb), and `production/` fabrication outputs. `HW/production/` contains an earlier fabrication export. The [render](../HW/piADAC/ZynADAC_render_01.png) and [schematic PDF](../HW/piADAC/sch.pdf) are reference exports; confirm their revision against the KiCad sources before fabrication.

The repository also includes Ultra Librarian import instructions for the PCM1863 and PCM5242 components:

| Component | General | KiCad | STEP |
| --- | --- | --- | --- |
| PCM1863 | [Import guide](../HW/piADAC/ul_PCM1863DBT/ImportGuides.html) | [KiCad guide](../HW/piADAC/ul_PCM1863DBT/KiCAD/ImportGuide.html) | — |
| PCM5242 | [Import guide](../HW/piADAC/ul_PCM5242RHBR/ImportGuides.html) | [KiCad guide](../HW/piADAC/ul_PCM5242RHBR/KiCAD/ImportGuide.html) | [STEP guide](../HW/piADAC/ul_PCM5242RHBR/STEP/ImportGuide.html) |

The hardware design files themselves remain in the [repository](https://github.com/423F26/project2/tree/main/HW).

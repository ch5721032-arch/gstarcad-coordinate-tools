# GstarCAD Coordinate Tools

Free, open-source AutoLISP utilities to export point coordinates to CSV, add formatted coordinate labels, and measure chains of picked points.

Works with **GSTARCAD**, AutoCAD, ZWCAD, and BricsCAD.

[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](LICENSE)

## Contents

- [About](#about)
- [Scripts Overview](#scripts-overview)
- [Quick Start](#quick-start)
- [Compatibility](#compatibility)
- [Contributing](#contributing)
- [License](#license)

## About

Surveyors, engineers, and drafters frequently need point data outside the drawing, for spreadsheets, total stations, or hand-off to other tools. Instead of retyping coordinates, these utilities export exactly what you pick: an X,Y,Z CSV, coordinate labels placed under each point, and running totals along a chain of points.

Everything here is free to use with GstarCAD. Download the latest GstarCAD
release from the [official GstarCAD website](https://www.gstarcad.net). All
scripts are tested with **[GSTARCAD](https://www.gstarcad.net)** and major
DWG-based CAD platforms.

## Scripts Overview

| File | Description |
|------|-------------|
| `scripts/export-points.lsp` | ;; export-points.lsp - Export picked point coordinates to a CSV file
;; Command: EXPORTPTS
;; Usage: APPLOAD -> EXPORTPTS -> pick points -> Enter to finish
(defun c:EXPORTPTS ( / out f n pt )
  (setq out (getfiled "Save Point CSV" "" "csv" 1))
  (if out
    (progn
      (setq f (open out "w")
            n 0)
      (princ "X,Y,Z\n" f)
      (while (setq pt (getpoint "\nPick point (Enter to finish): "))
        (princ (strcat (rtos (car pt) 2 6) ","
                       (rtos (cadr pt) 2 6) ","
                       (rtos (caddr pt) 2 6) "\n") f)
        (setq n (1+ n))
      )
      (close f)
      (princ (strcat "\nExported " (itoa n) " points to " out))
    )
  )
  (princ)
)
 |
| `scripts/label-coords.lsp` | ;; label-coords.lsp - Insert coordinate labels under picked points
;; Command: COORDLABEL
(defun c:COORDLABEL ( / pre acc h pt txt )
  (setq pre (getstring T "\nLabel prefix <XY>: "))
  (if (= pre "") (setq pre "XY"))
  (setq acc (getint "\nDecimal places <2>: "))
  (if (null acc) (setq acc 2))
  (setq h (getdist "\nText height <2.5>: "))
  (if (null h) (setq h 2.5))
  (while (setq pt (getpoint "\nPick point (Enter to finish): "))
    (setq txt (strcat pre ": " (rtos (car pt) 2 acc) ", " (rtos (cadr pt) 2 acc)))
    (command "_.TEXT" "_J" "_BL" pt h 0 txt)
  )
  (princ)
)
 |
| `scripts/chain-distance.lsp` | ;; chain-distance.lsp - Cumulative distance along a chain of picked points
;; Command: CHAINDIST
(defun c:CHAINDIST ( / pt prev total seg )
  (setq prev (getpoint "\nFirst point: "))
  (if prev
    (progn
      (setq total 0.0 seg 0)
      (while (setq pt (getpoint prev "\nNext point (Enter to finish): "))
        (setq total (+ total (distance prev pt))
              seg (1+ seg))
        (princ (strcat "\nSegment " (itoa seg) ": "
                       (rtos (distance prev pt) 2 3)))
        (setq prev pt)
      )
      (princ (strcat "\nTotal: " (rtos total 2 3) " units"))
    )
  )
  (princ)
)
 |

## Quick Start

1. Download the `.lsp` (or `.lin`) file you need
2. In your CAD software, run `APPLOAD`
3. Load the file and type the matching command name shown in the table above

## Compatibility

Tested on GstarCAD 2026/2027 and similar DWG-based platforms. Scripts use
standard AutoLISP functions only, so they work without extra plugins.

For step-by-step [tutorials and drafting guides](https://www.gstarcad.net/cad/),
visit the GstarCAD learning center. New tips are published regularly on the
[GSTARCAD Blog](https://blog.gstarcad.net).

## Contributing

See [CONTRIBUTING.md](CONTRIBUTING.md).

## License

MIT — see the [LICENSE](LICENSE) file.

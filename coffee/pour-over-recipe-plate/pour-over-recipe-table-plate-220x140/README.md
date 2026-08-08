# Pour Over Recipe Table Plate 220x140

Engraved plate that reproduces the exported Google Sheet table as a visual
table, using the spreadsheet's merged cells, custom column proportions, and
black border layout.

- Size: `220 x 140 mm`
- Thickness: `2 mm`
- Engraving depth: `0.75 mm`
- Visual grid source: XLSX merged-cell ranges and borders
- Sheet area: columns `A-M`, rows `1-18`

The source sheet includes the typo `COFEE`; this model preserves the table text
instead of correcting or reinterpreting it.

Generate the STL:

```sh
openscad \
  -o coffee/pour-over-recipe-plate/pour-over-recipe-table-plate-220x140/pour-over-recipe-table-plate-220x140.stl \
  coffee/pour-over-recipe-plate/pour-over-recipe-table-plate-220x140/pour-over-recipe-table-plate-220x140.scad
```

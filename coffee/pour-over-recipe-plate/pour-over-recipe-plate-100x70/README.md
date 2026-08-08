# Pour Over Recipe Plate 100x70

Engraved reference plate for the pour-over recipe exported from the Google
Sheet.

- Size: `100 x 70 mm`
- Thickness: `3 mm`
- Engraving depth: `0.55 mm`
- Recipe base: `20 g` coffee, `300 g` water, `1:15`
- Temperature range: `88-95 C`
- Grinder range from source sheet: `2.7-3.3`

Notes:

- `88 C` is a low brew temperature for many light roasts, but can be useful
  when a coffee trends bitter or harsh.
- The grind numbers are grinder-specific and should not be treated as universal.
- The plate preserves the source sheet's `40% flavor` and `60% strength`
  phases, including the updated `0:00` and `0:45` flavor-phase pours, with
  abbreviated wording so it remains legible at `100 x 70 mm`.

Generate the STL:

```sh
openscad \
  -o coffee/pour-over-recipe-plate/pour-over-recipe-plate-100x70/pour-over-recipe-plate-100x70.stl \
  coffee/pour-over-recipe-plate/pour-over-recipe-plate-100x70/pour-over-recipe-plate-100x70.scad
```

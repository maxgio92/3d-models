# Pour Over Recipe Plate 160x112

Larger engraved reference plate for the pour-over recipe exported from the
Google Sheet.

- Size: `160 x 112 mm`
- Proportion: same `10:7` ratio as the `100 x 70 mm` plate
- Thickness: `4 mm`
- Engraving depth: `0.75 mm`
- Recipe base: `20 g` coffee, `300 g` water, `1:15`
- Temperature range: `88-95 C`
- Grinder range from source sheet: `2.7-3.3`

This version keeps the same `10:7` proportion as the smaller plate and includes
the source sheet's taste/grind annotations, phase labels, pour timings, target
weights, increments, and acids/sugars/bitters reference labels.

Generate the STL:

```sh
openscad \
  -o coffee/pour-over-recipe-plate/pour-over-recipe-plate-160x112/pour-over-recipe-plate-160x112.stl \
  coffee/pour-over-recipe-plate/pour-over-recipe-plate-160x112/pour-over-recipe-plate-160x112.scad
```

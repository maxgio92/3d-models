# WDT Tool for Sewing Needles

Parametric OpenSCAD design for a coffee WDT tool that uses real sewing needles
as the tines.

## Design

- `tool`: ergonomic handle with a replaceable-looking needle cartridge.
- `cap`: tall protective cap to cover the exposed needle tips.
- `stand`: vertical bench stand for the assembled tool.
- `layout`: all printed parts shown together for design review.

The default geometry uses 9 needles in a small radial pattern with a 7 degree
splay. It is sized for sewing needles around 0.9 mm to 1.2 mm in diameter.

## Parameters to Adjust

- `needle_count`: number of sewing needles.
- `needle_diameter`: measured needle diameter, used for preview rods only.
- `needle_hole_diameter`: printed hole diameter. The default is 1.45 mm for
  0.9 mm to 1.2 mm sewing needles, leaving room for printer shrinkage and glue.
- `needle_exposed_length`: length below the cartridge.
- `needle_splay_angle`: outward needle angle.
- `needle_pattern_radius`: radius of the circular needle layout.

For a permanent build, insert needles after printing and lock them with a small
amount of epoxy or CA glue from the top relief hole. The default is a glue fit,
not a friction fit. For a tighter fit, reduce `needle_hole_diameter` and test
with a short calibration print first.

## Export

Render one printable part at a time by changing `part` in the SCAD file:

```scad
part = "tool";
show_preview_needles = false;
```

Then export:

```sh
openscad -o wdt-tool.stl wdt-tool-sewing-needles-parametric.scad
```

Repeat with `part = "cap"` and `part = "stand"` for the accessory parts.

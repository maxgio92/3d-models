# MINI R53 Fog Light Brake Duct Covers

Parametric round covers for the front bumper fog light openings after replacing the fog lights with internal brake ducts.

The cover is designed as an exterior bumper bezel with a rear round collar:

- the front flange hides the drilled/cut bumper edge;
- the middle ring transitions from the flat rear ring into the front Z-contoured ring;
- the middle transition starts directly from the rear ring, without an extra flat shelf;
- the front, middle, and rear internal diameters match at `60.5 mm`;
- the front ring follows a continuous Z-based curve from near-flat through the center band to `16 mm` at the top/bottom edge;
- the front ring keeps a fixed `2.5 mm` thickness along the Y axis, matching the rear collar wall;
- the center opening leaves a visible intake hint from the exterior;
- the rear collar is sized as a front-install pass-through neck, not as a direct seal to the larger internal brake duct;
- the cover has no visible front screw holes;
- left and right STLs are exported separately, even though the current round draft is symmetric.

## Files

- `mini-r53-fog-light-brake-duct-covers.scad`: source model for both sides.
- `mini-r53-fog-light-brake-duct-cover-left.stl`: left cover.
- `mini-r53-fog-light-brake-duct-cover-right.stl`: right cover.

## Current Draft Dimensions

- Bumper cut reference: `66 mm`
- Duct reference: `80 mm` external, `75 mm` internal
- Outer flange: `86 x 3 mm`
- Top/bottom exterior limb depth: `16 mm`
- Center-band front depth: `0.2 mm`
- Front ring Y thickness: `2.5 mm`
- Front contour segments: `432`
- Front limb curve power: `1.65`
- Middle ring profile scale: `45%`
- Visible opening: `60.5 mm`
- Rear collar: `65.5 x 22 mm`
- Rear collar internal diameter: `60.5 mm`
- Middle ring rear internal diameter: `60.5 mm`
- Sealing lip: `65.5 x 4 mm`
- No visible front screw holes

These dimensions are a first fit draft based on a `66 mm` drilled bumper cutout and the existing brake duct STL. The through-bumper collar is intentionally smaller than the bumper cutout so the cover can be installed from the front.

## Generate STLs

```sh
openscad -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-left.stl mini-r53-fog-light-brake-duct-covers.scad
openscad -D 'side="right"' -o mini-r53-fog-light-brake-duct-cover-right.stl mini-r53-fog-light-brake-duct-covers.scad
```

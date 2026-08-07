# MINI R53 Fog Light Brake Duct Covers

Parametric round covers for the front bumper fog light openings after replacing the fog lights with internal brake ducts.

The cover is designed as an exterior bumper bezel with a rear round collar:

- the front flange hides the drilled/cut bumper edge;
- the middle ring transitions from the flat rear ring into the front Z-contoured ring;
- the middle transition starts directly from the rear ring, without an extra flat shelf;
- the front intake opens to a `72 mm` bellmouth near the front ring, then adds
  a smoother `80 mm` edge-only lip flare across the final `10 mm` of the front ring;
- the `60.5 mm` throat stays straight through the rear section before the
  bellmouth begins;
- the front ring follows a steeper Z-based curve from near-flat through the center band to `10 mm`, with an extra `3 mm` only in the last `10 mm` of the bottom limb;
- the front ring keeps a constant `2.5 mm` shell thickness so the top/bottom limbs do not become thicker;
- the center opening reads as a progressive circular bellmouth to reduce sharp intake transitions;
- the bellmouth uses higher-resolution smootherstep sections for a softer internal-to-external radius progression;
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
- Top/bottom exterior limb depth: `10 mm`
- Bottom tip extra depth: `3 mm`
- Bottom tip max depth: `13 mm`
- Bottom tip band height: `10 mm`
- Center-band front depth: `0.2 mm`
- Front ring shell thickness: `2.5 mm`
- Front contour segments: `432`
- Front limb curve power: `2.4`
- Middle ring profile scale: `45%`
- Front bellmouth: `72 mm`
- Front edge-only lip flare: `80 mm` across the final `10 mm`
- Rear throat: `60.5 mm`
- Bellmouth progression: `24` smootherstep sections plus `18` edge-flare sections
- Rear collar: `65.5 x 22 mm`
- Rear collar internal diameter: `60.5 mm`
- Middle ring keeps the rear throat connected, with the bellmouth expansion
  starting near the front ring and a separate final edge flare at the lip
- Sealing lip: `65.5 x 4 mm`
- No visible front screw holes

These dimensions are a first fit draft based on a `66 mm` drilled bumper cutout and the existing brake duct STL. The through-bumper collar is intentionally smaller than the bumper cutout so the cover can be installed from the front.

## Generate STLs

```sh
openscad -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-left.stl mini-r53-fog-light-brake-duct-covers.scad
openscad -D 'side="right"' -o mini-r53-fog-light-brake-duct-cover-right.stl mini-r53-fog-light-brake-duct-covers.scad
```

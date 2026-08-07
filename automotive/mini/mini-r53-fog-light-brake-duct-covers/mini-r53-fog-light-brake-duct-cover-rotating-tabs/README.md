# MINI R53 Fog Light Brake Duct Cover - Rotating Tabs

Variant using hidden rear rotating tabs to fix the cover to the bumper instead of the brake duct.

The visible cover keeps the same smoothed front mouth profile as the current draft. The cover body has no rear bosses outside the `65.5 mm` through-bumper collar, so it can pass through the `66 mm` bumper hole. Separate small tabs sit behind the bumper and can rotate around their screws to clamp the bumper edge.

This draft assumes access behind the bumper. A rigid rotating tab that is larger than the circular bumper hole cannot be inserted from the front through the same round hole and then catch behind it.

## Parts

- `mini-r53-fog-light-brake-duct-cover-rotating-tabs-left-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rotating-tabs-right-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rotating-tabs.stl`
- `mini-r53-fog-light-brake-duct-cover-rotating-tabs-assembly.stl`

The assembly STL is only for previewing the layout. Print the cover and tabs as separate parts.

## Draft Dimensions

- Cover outer diameter: `86 mm`
- Front bellmouth: `72 mm`
- Front edge-only lip flare: `80 mm` across the final `10 mm`
- Rear throat: `60.5 mm`
- Internal intake shape: eased circular bellmouth
- Bellmouth progression: `24` smootherstep sections plus `18` edge-flare sections
- Max front protrusion: `13 mm` at the bottom tip
- Rear collar: `65.5 x 22 mm`
- Tab length: `18 mm`
- Tab width: `8 mm`
- Tab thickness: `3 mm`
- Tab screw clearance: `2.6 mm`
- Assumed bumper thickness: `3 mm`

## Generate

```sh
openscad -D 'component="cover"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rotating-tabs-left-cover.stl mini-r53-fog-light-brake-duct-cover-rotating-tabs.scad
openscad -D 'component="cover"' -D 'side="right"' -o mini-r53-fog-light-brake-duct-cover-rotating-tabs-right-cover.stl mini-r53-fog-light-brake-duct-cover-rotating-tabs.scad
openscad -D 'component="tabs"' -o mini-r53-fog-light-brake-duct-cover-rotating-tabs.stl mini-r53-fog-light-brake-duct-cover-rotating-tabs.scad
openscad -D 'component="assembly"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rotating-tabs-assembly.stl mini-r53-fog-light-brake-duct-cover-rotating-tabs.scad
```

# MINI R53 Fog Light Brake Duct Cover - Rear Clamp Ring

Variant using a hidden rear retainer sleeve to fix the cover to the bumper instead of the brake duct.

The visible cover keeps the same smoothed front mouth profile as the current draft. The cover body has no rear bosses outside the `65.5 mm` through-bumper collar, so it can pass through the `66 mm` bumper hole. A separate rear sleeve sits behind the bumper and grips the outside of the rear collar, giving the screws a rear-side retaining part that prevents the cover from pulling back out.

The outer transition curve is tuned inward to reduce the shoulder without
adding material or changing fit-critical diameters.

## Parts

- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-left-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-right-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-assembly.stl`

The assembly STL is only for previewing the layout. Print the cover and rear retainer sleeve as separate parts.

## Draft Dimensions

- Cover outer diameter: `86 mm`
- Front bellmouth: `72 mm`
- Front edge-only lip flare: `80 mm` across the final `10 mm`
- Rear throat: `60.5 mm`
- Internal intake shape: eased circular bellmouth
- Bellmouth progression: `24` smootherstep sections plus `18` edge-flare sections
- Max front protrusion: `10 mm`
- Rear collar: `65.5 x 22 mm`
- Retainer sleeve outer diameter: `82 mm`
- Retainer flange outer diameter: `86 mm`
- Retainer bore: `66.5 mm` for clearance over the `65.5 mm` cover collar
- Retainer sleeve depth: `12 mm`
- Retainer flange thickness: `3 mm`
- Retainer side screw clearance: `3.2 mm`
- Retainer side screw center: midway through the `12 mm` sleeve wall
- Retainer side holes: `4`, intended as drill guides for fitment-dependent cover holes
- Assumed bumper thickness: `3 mm`

## Generate

```sh
openscad -D 'component="cover"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-left-cover.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="cover"' -D 'side="right"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-right-cover.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="clamp-ring"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="assembly"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-assembly.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
```

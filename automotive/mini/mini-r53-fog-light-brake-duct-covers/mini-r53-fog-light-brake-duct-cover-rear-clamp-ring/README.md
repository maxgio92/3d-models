# MINI R53 Fog Light Brake Duct Cover - Rear Clamp Ring

Variant using a hidden rear clamp ring to fix the cover to the bumper instead of the brake duct.

The visible cover keeps the same front mouth profile as the current draft. The cover body has no rear bosses outside the `65.5 mm` through-bumper collar, so it can pass through the `66 mm` bumper hole. A separate rear ring sits behind the bumper around the collar and is rear-installed.

## Parts

- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-left-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-right-cover.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.stl`
- `mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-assembly.stl`

The assembly STL is only for previewing the layout. Print the cover and clamp ring as separate parts.

## Draft Dimensions

- Cover outer diameter: `86 mm`
- Visible opening: `60.5 mm`
- Max front protrusion: `10 mm`
- Rear collar: `65.5 x 22 mm`
- Clamp ring outer diameter: `86 mm`
- Clamp ring inner diameter: `66 mm`
- Clamp ring thickness: `3 mm`
- Clamp ring screw clearance: `2.6 mm`
- Assumed bumper thickness: `3 mm`

## Generate

```sh
openscad -D 'component="cover"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-left-cover.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="cover"' -D 'side="right"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-right-cover.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="clamp-ring"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
openscad -D 'component="assembly"' -D 'side="left"' -o mini-r53-fog-light-brake-duct-cover-rear-clamp-ring-assembly.stl mini-r53-fog-light-brake-duct-cover-rear-clamp-ring.scad
```

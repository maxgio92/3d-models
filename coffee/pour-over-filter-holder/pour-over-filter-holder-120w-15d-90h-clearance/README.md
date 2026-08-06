# Pour Over Filter Holder 120w 15d 90h Clearance

OpenSCAD holder for a compact stack of pour-over coffee filters.

Usable filter clearance:

- Internal width: 120 mm
- Internal stack depth: 15 mm
- Support height: 90 mm
- Front wall height: 90 mm
- Back wall height: 90 mm

The printed model is wider and deeper than those clearances because the side
cheeks, front lip, back support, and stabilizing base sit outside the filter
space.

Approximate printed footprint:

- Width: 130 mm
- Depth: 40 mm

Moisture-resilience details:

- Raised internal ribs keep filters off the base surface.
- Drainage slots prevent small splashes from pooling under the filters.
- Open side, front, and back slots preserve airflow.

Design details:

- Front wall has a larger centered pointed-arch opening.
- Front wall has a rose-window motif above the main opening.
- Front and back ventilation slots use narrow pointed-arch shapes.
- Front, back, and side faces include shallow gothic tracery incisions around the openings.
- Side cheeks use one Latin cross cutout and one miniature pointed-arch facade with a rose window.
- Optional lid uses a tall cathedral-cap profile with an 18 mm slip-on skirt,
  45 mm of internal clearance above the holder top, ridge finials, corner
  pinnacles, roof ribs, shallow lancet incisions, denser diagonal roof grooves,
  diamond roof panels, and sharp spires along the ridge, roof side edges, and
  sloped lateral roof planes.
- Sloped roof faces include raised sword-like gothic columns.
- Rectangular lid walls include raised sword-like gothic columns on all four sides.
- Long rectangular lid walls include thin raised exterior supports parallel to the roof ridge.
- Gable-end rectangular lid walls include thin raised braces parallel to the roof pitch.
- Prague-inspired details include nested pointed arches, facade buttress ribs,
  denser ridge spires, and layered roof lancet incisions.

Generate the STL:

```sh
openscad \
  -o coffee/pour-over-filter-holder/pour-over-filter-holder-120w-15d-90h-clearance/pour-over-filter-holder-120w-15d-90h-clearance.stl \
  coffee/pour-over-filter-holder/pour-over-filter-holder-120w-15d-90h-clearance/pour-over-filter-holder-120w-15d-90h-clearance.scad
```

Generate the cathedral-cap lid STL:

```sh
openscad \
  -o coffee/pour-over-filter-holder/pour-over-filter-holder-120w-15d-90h-clearance/pour-over-filter-holder-lid-136w-46d-88h.stl \
  coffee/pour-over-filter-holder/pour-over-filter-holder-120w-15d-90h-clearance/pour-over-filter-holder-lid-136w-46d-88h.scad
```

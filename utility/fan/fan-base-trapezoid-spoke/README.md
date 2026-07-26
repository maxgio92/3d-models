# Fan Base Trapezoid Spoke

Isosceles trapezoid prism for a fan base spoke.

## Dimensions

Requested side lengths:

```text
left side:   112 mm
top base:     65 mm
right side: 112 mm
bottom base:  12 mm
thickness:    12 mm
```

The vertical height is about `108.82 mm`. The side length is `112 mm` along the
diagonal, so the vertical height is shorter than `112 mm`.

## Files

```text
fan-base-trapezoid-spoke.scad
fan-base-trapezoid-spoke.stl
```

## Generate STL

From this directory:

```sh
openscad -o fan-base-trapezoid-spoke.stl fan-base-trapezoid-spoke.scad
```

From the repository root:

```sh
openscad \
  -o utility/fan/fan-base-trapezoid-spoke/fan-base-trapezoid-spoke.stl \
  utility/fan/fan-base-trapezoid-spoke/fan-base-trapezoid-spoke.scad
```

## Source Pattern

The source stores the requested dimensions as variables:

```scad
top_width = 65;
bottom_width = 12;
side_length = 112;
thickness = 12;
```

It computes the centered offset and vertical height:

```scad
offset = (top_width - bottom_width) / 2;
vertical_height = sqrt(side_length * side_length - offset * offset);
```

It creates the 2D trapezoid and extrudes it:

```scad
linear_extrude(thickness)
polygon(points=[
  [offset, 0],
  [offset + bottom_width, 0],
  [top_width, vertical_height],
  [0, vertical_height]
]);
```

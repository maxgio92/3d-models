// Parametric coffee dosing funnel.
//
// Render one part at a time by changing `part`:
//   "48.8"   48.8 mm base diameter
//   "57.4"   57.4 mm base diameter
//   "layout" both variants laid out for preview

part = "layout"; // ["48.8", "57.4", "layout"]

height = 38;
top_diameter_ratio = 1.6;

wall_thickness = 1.8;
base_border_width = 2;
base_border_height = 2.4;
base_collar_height = 8;
rim_height = 2.4;
rim_round_radius = 0.8;
lower_edge_round_radius = 0.6;

$fn = 160;

module dosing_funnel(base_diameter) {
  top_diameter = base_diameter * top_diameter_ratio;
  outer_base_radius = base_diameter / 2;
  border_radius = outer_base_radius + base_border_width;
  outer_top_radius = top_diameter / 2;
  inner_base_radius = outer_base_radius - wall_thickness;
  inner_top_radius = outer_top_radius - wall_thickness;

  rotate_extrude()
    polygon(points=[
      [inner_base_radius, 0],
      [inner_base_radius, base_collar_height],
      [inner_top_radius, height - rim_height],
      [inner_top_radius, height],
      [outer_top_radius - rim_round_radius, height],
      [outer_top_radius, height - rim_round_radius],
      [outer_top_radius, height - rim_height],
      [outer_base_radius, base_collar_height],
      [outer_base_radius, base_border_height],
      [border_radius, base_border_height],
      [border_radius, lower_edge_round_radius],
      [outer_base_radius, lower_edge_round_radius],
      [outer_base_radius - lower_edge_round_radius, 0]
    ]);
}

module layout() {
  translate([-52, 0, 0])
    dosing_funnel(48.8);

  translate([52, 0, 0])
    dosing_funnel(57.4);
}

if (part == "48.8")
  dosing_funnel(48.8);
else if (part == "57.4")
  dosing_funnel(57.4);
else
  layout();

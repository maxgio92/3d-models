overall_length = 45;
height = 3.8;

large_outer_diameter = 15;
small_outer_diameter = 7;
wall_width = 1.5;
side_opening_inset = 8;

$fn = 96;

large_radius = large_outer_diameter / 2;
small_radius = small_outer_diameter / 2;

large_center_x = large_radius;
small_center_x = overall_length - small_radius;
center_y = large_radius;

module tapered_capsule_2d(delta = 0) {
  offset(delta = delta)
    hull() {
      translate([large_center_x, center_y])
        circle(d = large_outer_diameter);

      translate([small_center_x, center_y])
        circle(d = small_outer_diameter);
    }
}

module side_opening_2d() {
  translate([side_opening_inset, -1])
    square([
      overall_length - side_opening_inset * 2,
      center_y + wall_width + 1
    ]);
}

linear_extrude(height = height)
  difference() {
    tapered_capsule_2d();
    tapered_capsule_2d(delta = -wall_width);
    side_opening_2d();
  }

part_length = 220;
part_height = 75;

wall_thickness = 8;
mount_flange_depth = 18;
mount_flange_thickness = 6;
corner_radius = 2;

screw_clearance_diameter = 3.4;
screw_head_diameter = 6.8;
screw_head_depth = 3.2;
screw_positions_x = [25, 82, 138, 195];

$fn = 36;

part_depth = wall_thickness + mount_flange_depth;
screw_y = wall_thickness + mount_flange_depth / 2;

module rounded_box(size, radius) {
  translate([radius, radius, radius])
    minkowski() {
      cube([
        size[0] - 2 * radius,
        size[1] - 2 * radius,
        size[2] - 2 * radius
      ]);
      sphere(radius);
    }
}

module screw_holes() {
  for (x_pos = screw_positions_x) {
    translate([x_pos, screw_y, -1])
      cylinder(h = mount_flange_thickness + 2, d = screw_clearance_diameter);

    translate([x_pos, screw_y, mount_flange_thickness - screw_head_depth])
      cylinder(h = screw_head_depth + 1, d1 = screw_clearance_diameter, d2 = screw_head_diameter);
  }
}

module screw_on_side_support() {
  difference() {
    union() {
      rounded_box([part_length, wall_thickness, part_height], corner_radius);
      rounded_box([part_length, part_depth, mount_flange_thickness], corner_radius);

      translate([0, wall_thickness - corner_radius, mount_flange_thickness])
        cube([part_length, corner_radius, part_height - mount_flange_thickness - corner_radius]);
    }

    screw_holes();
  }
}

screw_on_side_support();

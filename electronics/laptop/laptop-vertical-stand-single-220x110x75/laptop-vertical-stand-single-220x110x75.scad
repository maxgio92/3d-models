laptop_thickness = 18.9;
slot_clearance = 1.1;
slot_width = laptop_thickness + slot_clearance;

stand_length = 220;
base_depth = 110;
base_thickness = 8;
wall_height = 75;
wall_thickness = 8;
vent_cutout_start_z = 51;
corner_radius = 2;
$fn = 24;

slot_center_y = base_depth / 2;
slot_min_y = slot_center_y - slot_width / 2;
slot_max_y = slot_center_y + slot_width / 2;

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

module solid_side_wall(y_pos) {
  translate([0, y_pos, base_thickness])
    rounded_box([stand_length, wall_thickness, wall_height - base_thickness], corner_radius);

  translate([0, y_pos, base_thickness])
    cube([stand_length, wall_thickness, wall_height - base_thickness - corner_radius]);
}

module side_wall(y_pos, vent_cutout = false) {
  difference() {
    solid_side_wall(y_pos);

    if (vent_cutout)
      translate([-1, y_pos - 1, vent_cutout_start_z])
        cube([
          stand_length + 2,
          wall_thickness + 2,
          wall_height - vent_cutout_start_z + 1
        ]);
  }
}

union() {
  rounded_box([stand_length, base_depth, base_thickness], corner_radius);

  side_wall(slot_min_y - wall_thickness);
  side_wall(slot_max_y, true);
}

box_count = 3;
box_width = 80;
width = box_count * box_width;
depth = 80;
base_thickness = 2;
border_width = 2;
border_depth = 16;
tape_pad_width = 13.5;
tape_pad_thickness = 2;
tape_recess_depth = 0;
tape_margin = border_width;
tape_inset = border_width;
corner_radius = 2;
$fn = 24;

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

union() {
  difference() {
    rounded_box([width, depth, border_depth], corner_radius);

    translate([border_width, border_width, base_thickness])
      cube([
        width - 2 * border_width,
        depth - 2 * border_width,
        border_depth - base_thickness + 1
      ]);
  }

  translate([
    tape_inset,
    tape_margin,
    border_depth - tape_recess_depth - tape_pad_thickness
  ])
    cube([
      tape_pad_width,
      depth - 2 * tape_margin,
      tape_pad_thickness
    ]);

  translate([
    width - tape_inset - tape_pad_width,
    tape_margin,
    border_depth - tape_recess_depth - tape_pad_thickness
  ])
    cube([
      tape_pad_width,
      depth - 2 * tape_margin,
      tape_pad_thickness
    ]);
}

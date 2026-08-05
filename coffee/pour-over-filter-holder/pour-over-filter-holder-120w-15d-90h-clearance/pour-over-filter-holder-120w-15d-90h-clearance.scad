filter_width = 120;
filter_depth = 15;
filter_height = 90;

wall_thickness = 5;
front_lip_thickness = 4;
back_wall_thickness = 4;
base_thickness = 6;
front_lip_height = 18;
back_wall_height = 76;
side_wall_height = filter_height;
corner_radius = 2;

outer_width = filter_width + 2 * wall_thickness;
outer_depth = filter_depth + front_lip_thickness + back_wall_thickness;
back_y = front_lip_thickness + filter_depth;
overlap = 0.2;

$fn = 32;

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

module side_cheek(x_pos) {
  cutout_width = wall_thickness + 2;
  cutout_depth = 8;
  cutout_top_margin = 14;
  cutout_bottom_z = base_thickness - 1;
  cutout_height = side_wall_height - cutout_top_margin - cutout_bottom_z;

  difference() {
    union() {
      translate([x_pos, 0, base_thickness - overlap])
        rounded_box([
          wall_thickness,
          outer_depth,
          side_wall_height - base_thickness + overlap
        ], corner_radius);

      translate([x_pos, 0, base_thickness - overlap])
        cube([
          wall_thickness,
          outer_depth,
          side_wall_height - base_thickness + overlap - corner_radius
        ]);
    }

    translate([
      x_pos - 1,
      front_lip_thickness + (filter_depth - cutout_depth) / 2,
      cutout_bottom_z
    ])
      cube([cutout_width, cutout_depth, cutout_height]);

    translate([
      x_pos - 1,
      front_lip_thickness + filter_depth / 2,
      side_wall_height - cutout_top_margin
    ])
      rotate([0, 90, 0])
        cylinder(h=cutout_width, r=3);
  }
}

module front_lip() {
  scoop_width = 42;
  scoop_height = 10;

  difference() {
    union() {
      translate([wall_thickness - overlap, 0, base_thickness - overlap])
        rounded_box([
          filter_width + 2 * overlap,
          front_lip_thickness,
          front_lip_height + overlap
        ], corner_radius);

      translate([wall_thickness - overlap, 0, base_thickness - overlap])
        cube([
          filter_width + 2 * overlap,
          front_lip_thickness,
          front_lip_height + overlap - corner_radius
        ]);
    }

    translate([
      outer_width / 2,
      -1,
      base_thickness + front_lip_height
    ])
      rotate([-90, 0, 0])
        cylinder(h=front_lip_thickness + 2, r=scoop_width / 2);

    translate([
      (outer_width - scoop_width) / 2,
      -1,
      base_thickness + front_lip_height - scoop_height
    ])
      cube([scoop_width, front_lip_thickness + 2, scoop_height + 1]);
  }
}

module back_wall() {
  back_cutout_width = 6;
  back_cutout_count = 9;
  back_cutout_spacing = filter_width / (back_cutout_count + 1);
  back_cutout_bottom_z = base_thickness - 1;

  difference() {
    union() {
      translate([wall_thickness - overlap, back_y, base_thickness - overlap])
        rounded_box([
          filter_width + 2 * overlap,
          back_wall_thickness,
          back_wall_height - base_thickness + overlap
        ], corner_radius);

      translate([wall_thickness - overlap, back_y, base_thickness - overlap])
        cube([
          filter_width + 2 * overlap,
          back_wall_thickness,
          back_wall_height - base_thickness + overlap - corner_radius
        ]);
    }

    for (i = [0 : back_cutout_count - 1]) {
      top_margin = (i % 2 == 0) ? 14 : 26;
      cutout_height = back_wall_height - top_margin - back_cutout_bottom_z;
      cutout_center_x = wall_thickness + back_cutout_spacing * (i + 1);

      translate([
        cutout_center_x - back_cutout_width / 2,
        back_y - 1,
        back_cutout_bottom_z
      ])
        cube([back_cutout_width, back_wall_thickness + 2, cutout_height]);

      translate([
        cutout_center_x,
        back_y - 1,
        back_wall_height - top_margin
      ])
        rotate([-90, 0, 0])
          cylinder(h=back_wall_thickness + 2, r=back_cutout_width / 2);
    }
  }
}

union() {
  rounded_box([outer_width, outer_depth, base_thickness], corner_radius);

  side_cheek(0);
  side_cheek(outer_width - wall_thickness);

  front_lip();
  back_wall();
}

filter_width = 120;
filter_depth = 15;
filter_height = 90;

base_depth = 40;
wall_thickness = 5;
front_lip_thickness = 4;
back_wall_thickness = 4;
base_thickness = 6;
front_lip_height = filter_height - base_thickness;
back_wall_height = filter_height;
side_wall_height = filter_height;
corner_radius = 2;
rib_width = 4;
rib_height = 2;

outer_width = filter_width + 2 * wall_thickness;
outer_depth = base_depth;
filter_assembly_depth = filter_depth + front_lip_thickness + back_wall_thickness;
front_y = (base_depth - filter_assembly_depth) / 2;
filter_y = front_y + front_lip_thickness;
back_y = filter_y + filter_depth;
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

module vertical_slot_y(width, depth, height) {
  cube([width, depth, height]);

  translate([width / 2, 0, height])
    rotate([-90, 0, 0])
      cylinder(h=depth, r=width / 2);
}

module pointed_slot_y(width, depth, height) {
  cap_height = width * 0.8;
  shaft_height = height - cap_height;

  cube([width, depth, shaft_height]);

  translate([0, 0, shaft_height])
    polyhedron(
      points=[
        [0, 0, 0],
        [width, 0, 0],
        [width / 2, 0, cap_height],
        [0, depth, 0],
        [width, depth, 0],
        [width / 2, depth, cap_height]
      ],
      faces=[
        [0, 1, 2],
        [3, 5, 4],
        [0, 3, 4, 1],
        [1, 4, 5, 2],
        [2, 5, 3, 0]
      ]
    );
}

module pointed_slot_x(width, depth, height) {
  cap_height = width * 0.8;
  shaft_height = height - cap_height;

  cube([depth, width, shaft_height]);

  translate([0, 0, shaft_height])
    polyhedron(
      points=[
        [0, 0, 0],
        [0, width, 0],
        [0, width / 2, cap_height],
        [depth, 0, 0],
        [depth, width, 0],
        [depth, width / 2, cap_height]
      ],
      faces=[
        [0, 2, 1],
        [3, 4, 5],
        [0, 1, 4, 3],
        [1, 2, 5, 4],
        [2, 0, 3, 5]
      ]
    );
}

module groove_segment_y(x1, z1, x2, z2, depth, line_width) {
  hull() {
    translate([x1 - line_width / 2, 0, z1 - line_width / 2])
      cube([line_width, depth, line_width]);

    translate([x2 - line_width / 2, 0, z2 - line_width / 2])
      cube([line_width, depth, line_width]);
  }
}

module gothic_arch_incision_y(width, depth, height, line_width) {
  cap_height = width * 0.45;
  shoulder_z = height - cap_height;
  peak_x = width / 2;

  groove_segment_y(0, 0, 0, shoulder_z, depth, line_width);
  groove_segment_y(width, 0, width, shoulder_z, depth, line_width);
  groove_segment_y(0, shoulder_z, peak_x, height, depth, line_width);
  groove_segment_y(width, shoulder_z, peak_x, height, depth, line_width);
}

module gothic_window_incision_y(width, depth, height, line_width) {
  gothic_arch_incision_y(width, depth, height, line_width);

  translate([width / 2 - line_width / 2, 0, height * 0.18])
    cube([line_width, depth, height * 0.48]);

  translate([width / 2, 0, height * 0.76])
    rotate([-90, 0, 0])
      cylinder(h=depth, r=width * 0.12);
}

module nested_gothic_arches_y(widths, depth, height, line_width) {
  for (width = widths)
    translate([(max(widths) - width) / 2, 0, 0])
      gothic_arch_incision_y(width, depth, height, line_width);
}

module nested_gothic_window_y(widths, depth, height, line_width) {
  for (width = widths)
    translate([(max(widths) - width) / 2, 0, 0])
      gothic_window_incision_y(width, depth, height, line_width);
}

module ring_incision_y(outer_radius, inner_radius, depth) {
  rotate([-90, 0, 0])
    difference() {
      cylinder(h=depth, r=outer_radius);

      translate([0, 0, -1])
        cylinder(h=depth + 2, r=inner_radius);
    }
}

module rosette_rays_y(radius, depth, line_width) {
  for (angle = [0 : 30 : 150])
    rotate([0, angle, 0])
      translate([-line_width / 2, 0, -radius])
        cube([line_width, depth, 2 * radius]);
}

module ring_incision_x(outer_radius, inner_radius, depth) {
  rotate([0, 90, 0])
    difference() {
      cylinder(h=depth, r=outer_radius);

      translate([0, 0, -1])
        cylinder(h=depth + 2, r=inner_radius);
    }
}

module rosette_rays_x(radius, depth, line_width) {
  for (angle = [0 : 30 : 150])
    rotate([angle, 0, 0])
      translate([0, -line_width / 2, -radius])
        cube([depth, line_width, 2 * radius]);
}

module groove_segment_x(y1, z1, y2, z2, depth, line_width) {
  hull() {
    translate([0, y1 - line_width / 2, z1 - line_width / 2])
      cube([depth, line_width, line_width]);

    translate([0, y2 - line_width / 2, z2 - line_width / 2])
      cube([depth, line_width, line_width]);
  }
}

module gothic_arch_incision_x(width, depth, height, line_width) {
  cap_height = width * 0.45;
  shoulder_z = height - cap_height;
  peak_y = width / 2;

  groove_segment_x(0, 0, 0, shoulder_z, depth, line_width);
  groove_segment_x(width, 0, width, shoulder_z, depth, line_width);
  groove_segment_x(0, shoulder_z, peak_y, height, depth, line_width);
  groove_segment_x(width, shoulder_z, peak_y, height, depth, line_width);
}

module cross_tracery_incision_x(width, depth, height, line_width) {
  gothic_arch_incision_x(width, depth, height, line_width);

  translate([0, width / 2 - line_width / 2, height * 0.16])
    cube([depth, line_width, height * 0.62]);

  translate([0, width * 0.22, height * 0.56])
    cube([depth, width * 0.56, line_width]);
}

module vertical_slot_x(width, depth, height) {
  cube([depth, width, height]);

  translate([0, width / 2, height])
    rotate([0, 90, 0])
      cylinder(h=depth, r=width / 2);
}

module side_cross_slot_x(stem_width, depth, height, bar_width, bar_height, inverted = false) {
  bar_z = inverted ? height * 0.34 : height * 0.66;

  translate([0, (bar_width - stem_width) / 2, 0])
    cube([depth, stem_width, height]);

  translate([0, 0, bar_z - bar_height / 2])
    cube([depth, bar_width, bar_height]);
}

module base() {
  drain_width = 5;
  drain_depth = filter_depth - 3;
  drain_positions = [
    wall_thickness + filter_width * 0.25,
    wall_thickness + filter_width * 0.50,
    wall_thickness + filter_width * 0.75
  ];

  difference() {
    rounded_box([outer_width, outer_depth, base_thickness], corner_radius);

    for (x_pos = drain_positions)
      translate([
        x_pos - drain_width / 2,
        filter_y + (filter_depth - drain_depth) / 2,
        -1
      ])
        rounded_box([
          drain_width,
          drain_depth,
          base_thickness + 2
        ], corner_radius);
  }
}

module filter_ribs() {
  rib_positions = [
    wall_thickness + filter_width * 0.20,
    wall_thickness + filter_width * 0.50,
    wall_thickness + filter_width * 0.80
  ];

  for (x_pos = rib_positions)
    translate([
      x_pos - rib_width / 2,
      filter_y + 1,
      base_thickness - overlap
    ])
      cube([
        rib_width,
        filter_depth - 2,
        rib_height + overlap
      ]);
}

module facade_buttresses() {
  buttress_width = 3;
  buttress_depth = 2;
  buttress_height = filter_height - base_thickness - 10;
  front_positions = [
    wall_thickness + filter_width * 0.18,
    wall_thickness + filter_width * 0.34,
    wall_thickness + filter_width * 0.66,
    wall_thickness + filter_width * 0.82
  ];
  rear_positions = [
    wall_thickness + filter_width * 0.12,
    wall_thickness + filter_width * 0.28,
    wall_thickness + filter_width * 0.44,
    wall_thickness + filter_width * 0.56,
    wall_thickness + filter_width * 0.72,
    wall_thickness + filter_width * 0.88
  ];

  for (x_pos = front_positions)
    translate([
      x_pos - buttress_width / 2,
      front_y - buttress_depth,
      base_thickness - overlap
    ])
      cube([buttress_width, buttress_depth + overlap, buttress_height]);

  for (x_pos = rear_positions)
    translate([
      x_pos - buttress_width / 2,
      back_y + back_wall_thickness - overlap,
      base_thickness - overlap
    ])
      cube([buttress_width, buttress_depth + overlap, buttress_height]);
}

module side_cheek(x_pos) {
  cutout_depth = wall_thickness + 2;
  stem_width = 6;
  cross_bar_width = 14;
  cross_bar_height = 6;
  cutout_top_margin = 12;
  cutout_bottom_z = base_thickness - 1;
  cutout_height = side_wall_height - cutout_top_margin - cutout_bottom_z;
  incision_depth = 1.2;
  incision_width = 24;
  incision_height = cutout_height + 4;
  side_door_width = 18;
  side_door_height = 53;
  side_door_bottom_z = base_thickness - 1;
  side_rose_center_z = base_thickness + 72;
  side_rose_hole_radius = 3.2;
  side_rose_outer_radius = 7.8;
  side_rose_inner_radius = 5.7;

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

    if (x_pos > 0) {
      translate([
        x_pos - 1,
        filter_y + filter_depth / 2 - side_door_width / 2,
        side_door_bottom_z
      ])
        pointed_slot_x(side_door_width, cutout_depth, side_door_height);

      translate([
        x_pos - 1,
        filter_y + filter_depth / 2,
        side_rose_center_z
      ])
        rotate([0, 90, 0])
          cylinder(h=cutout_depth, r=side_rose_hole_radius);

      translate([
        x_pos + wall_thickness - incision_depth + 0.1,
        filter_y + filter_depth / 2 - side_door_width / 2 - 3,
        side_door_bottom_z
      ])
        gothic_arch_incision_x(
          side_door_width + 6,
          incision_depth,
          side_door_height + 5,
          1.1
        );

      translate([
        x_pos + wall_thickness - incision_depth + 0.1,
        filter_y + filter_depth / 2,
        side_rose_center_z
      ])
        ring_incision_x(
          side_rose_outer_radius,
          side_rose_inner_radius,
          incision_depth
        );

      translate([
        x_pos + wall_thickness - incision_depth + 0.1,
        filter_y + filter_depth / 2,
        side_rose_center_z
      ])
        rosette_rays_x(
          side_rose_inner_radius,
          incision_depth,
          0.8
        );
    } else {
      translate([
        x_pos - 1,
        filter_y + (filter_depth - cross_bar_width) / 2,
        cutout_bottom_z
      ])
        side_cross_slot_x(
          stem_width,
          cutout_depth,
          cutout_height,
          cross_bar_width,
          cross_bar_height
        );

      translate([
        x_pos - 0.1,
        filter_y + filter_depth / 2 - incision_width / 2,
        cutout_bottom_z
      ])
        cross_tracery_incision_x(
          incision_width,
          incision_depth,
          incision_height,
          1.1
        );
    }
  }
}

module front_lip() {
  front_cutout_width = 5;
  front_cutout_count = 9;
  front_cutout_spacing = filter_width / (front_cutout_count + 1);
  front_cutout_bottom_z = base_thickness - 1;
  incision_depth = 1.2;
  incision_width = 11;
  incision_line_width = 1.1;
  door_width = 28;
  door_top_margin = 16;
  door_height = front_lip_height - door_top_margin - front_cutout_bottom_z;
  door_incision_width = 42;
  door_incision_height = door_height + 4;
  blind_arch_width = 8;
  blind_arch_height = 30;
  tower_lancet_width = 13;
  tower_lancet_height = 62;
  rose_center_z = base_thickness + 74;
  rose_hole_radius = 4.5;
  rose_outer_radius = 10;
  rose_inner_radius = 7.4;
  rose_incision_depth = 1.2;

  difference() {
    union() {
      translate([wall_thickness - overlap, front_y, base_thickness - overlap])
        rounded_box([
          filter_width + 2 * overlap,
          front_lip_thickness,
          front_lip_height + overlap
        ], corner_radius);

      translate([wall_thickness - overlap, front_y, base_thickness - overlap])
        cube([
          filter_width + 2 * overlap,
          front_lip_thickness,
          front_lip_height + overlap - corner_radius
        ]);
    }

    for (i = [0 : front_cutout_count - 1]) {
      if (abs(i - floor(front_cutout_count / 2)) > 1) {
        top_margin = (i % 2 == 0) ? 12 : 22;
        cutout_height =
          front_lip_height + base_thickness -
          top_margin -
          front_cutout_bottom_z -
          front_cutout_width / 2;
        cutout_center_x = wall_thickness + front_cutout_spacing * (i + 1);

        translate([
          cutout_center_x - front_cutout_width / 2,
          front_y - 1,
          front_cutout_bottom_z
        ])
          pointed_slot_y(
            front_cutout_width,
            front_lip_thickness + 2,
            cutout_height
          );

        translate([
          cutout_center_x - incision_width / 2,
          front_y - 0.1,
          front_cutout_bottom_z
        ])
          gothic_window_incision_y(
            incision_width,
            incision_depth,
            cutout_height + 6,
            incision_line_width
          );

        translate([
          cutout_center_x - 17 / 2,
          front_y - 0.1,
          front_cutout_bottom_z
        ])
          nested_gothic_window_y(
            [9, 13, 17],
            incision_depth,
            cutout_height + 9,
            0.8
          );
      }
    }

    translate([
      outer_width / 2 - door_width / 2,
      front_y - 1,
      front_cutout_bottom_z
    ])
      pointed_slot_y(door_width, front_lip_thickness + 2, door_height);

    translate([
      outer_width / 2 - door_incision_width / 2,
      front_y - 0.1,
      front_cutout_bottom_z
    ])
      gothic_arch_incision_y(
        door_incision_width,
        incision_depth,
        door_incision_height,
        1.4
      );

    translate([
      outer_width / 2 - 56 / 2,
      front_y - 0.1,
      front_cutout_bottom_z
    ])
      nested_gothic_arches_y(
        [36, 46, 56],
        incision_depth,
        door_incision_height + 8,
        1.0
      );

    translate([
      outer_width / 2,
      front_y - 1,
      rose_center_z
    ])
      rotate([-90, 0, 0])
        cylinder(h=front_lip_thickness + 2, r=rose_hole_radius);

    translate([
      outer_width / 2,
      front_y - 0.1,
      rose_center_z
    ])
      ring_incision_y(
        rose_outer_radius,
        rose_inner_radius,
        rose_incision_depth
      );

    translate([
      outer_width / 2,
      front_y - 0.1,
      rose_center_z
    ])
      rosette_rays_y(
        rose_inner_radius,
        rose_incision_depth,
        1
      );

    for (x_pos = [
      wall_thickness + filter_width * 0.10,
      wall_thickness + filter_width * 0.90
    ])
      translate([
        x_pos - blind_arch_width / 2,
        front_y - 0.1,
        base_thickness + 32
      ])
        gothic_arch_incision_y(
          blind_arch_width,
          incision_depth,
          blind_arch_height,
          incision_line_width
        );

    for (x_pos = [
      wall_thickness + filter_width * 0.24,
      wall_thickness + filter_width * 0.76
    ])
      translate([
        x_pos - tower_lancet_width / 2,
        front_y - 0.1,
        base_thickness + 12
      ])
        nested_gothic_window_y(
          [7, 10, tower_lancet_width],
          incision_depth,
          tower_lancet_height,
          0.8
        );
  }
}

module back_wall() {
  back_cutout_width = 5;
  back_cutout_count = 11;
  back_cutout_spacing = filter_width / (back_cutout_count + 1);
  back_cutout_bottom_z = base_thickness - 1;
  incision_depth = 1.2;
  incision_width = 11;
  incision_line_width = 1.1;
  blind_arch_width = 8;
  blind_arch_height = 26;

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
      top_margin = (i % 2 == 0) ? 12 : 22;
      cutout_height =
        back_wall_height -
        top_margin -
        back_cutout_bottom_z -
        back_cutout_width / 2;
      cutout_center_x = wall_thickness + back_cutout_spacing * (i + 1);

      translate([
        cutout_center_x - back_cutout_width / 2,
        back_y - 1,
        back_cutout_bottom_z
      ])
        pointed_slot_y(
          back_cutout_width,
          back_wall_thickness + 2,
          cutout_height
        );

      translate([
        cutout_center_x - incision_width / 2,
        back_y + back_wall_thickness - incision_depth + 0.1,
        back_cutout_bottom_z
      ])
        gothic_window_incision_y(
          incision_width,
          incision_depth,
          cutout_height + 6,
          incision_line_width
        );

      translate([
        cutout_center_x - 17 / 2,
        back_y + back_wall_thickness - incision_depth + 0.1,
        back_cutout_bottom_z
      ])
        nested_gothic_window_y(
          [9, 13, 17],
          incision_depth,
          cutout_height + 9,
          0.8
        );
    }

    for (x_pos = [
      wall_thickness + filter_width * 0.04,
      wall_thickness + filter_width * 0.96
    ])
      translate([
        x_pos - blind_arch_width / 2,
        back_y + back_wall_thickness - incision_depth + 0.1,
        base_thickness + 36
      ])
        gothic_arch_incision_y(
          blind_arch_width,
          incision_depth,
          blind_arch_height,
          incision_line_width
        );
  }
}

union() {
  base();
  filter_ribs();

  side_cheek(0);
  side_cheek(outer_width - wall_thickness);

  front_lip();
  back_wall();
  facade_buttresses();
}

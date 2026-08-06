holder_outer_width = 130;
holder_outer_depth = 40;

clearance = 1;
wall_thickness = 2;
skirt_height = 18;
filter_clearance_height = 45;
roof_height = 18;
finial_height = 7;
ridge_width = 3;
eave_height = 2;
overlap = 0.2;

inner_width = holder_outer_width + 2 * clearance;
inner_depth = holder_outer_depth + 2 * clearance;
outer_width = inner_width + 2 * wall_thickness;
outer_depth = inner_depth + 2 * wall_thickness;
roof_base_z = skirt_height + filter_clearance_height;
roof_peak_z = roof_base_z + roof_height;
total_height = roof_peak_z + finial_height;

$fn = 32;

module wall_shell() {
  translate([0, 0, 0])
    cube([outer_width, wall_thickness, roof_base_z + overlap]);

  translate([0, outer_depth - wall_thickness, 0])
    cube([outer_width, wall_thickness, roof_base_z + overlap]);

  translate([0, wall_thickness, 0])
    cube([wall_thickness, inner_depth, roof_base_z + overlap]);

  translate([outer_width - wall_thickness, wall_thickness, 0])
    cube([wall_thickness, inner_depth, roof_base_z + overlap]);
}

module gabled_roof() {
  ridge_y = outer_depth / 2;

  polyhedron(
    points=[
      [0, 0, roof_base_z - overlap],
      [outer_width, 0, roof_base_z - overlap],
      [outer_width, outer_depth, roof_base_z - overlap],
      [0, outer_depth, roof_base_z - overlap],
      [0, ridge_y, roof_peak_z],
      [outer_width, ridge_y, roof_peak_z]
    ],
    faces=[
      [0, 1, 5, 4],
      [3, 4, 5, 2],
      [0, 3, 2, 1],
      [0, 4, 3],
      [1, 2, 5]
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

module groove_segment_x(y1, z1, y2, z2, depth, line_width) {
  hull() {
    translate([0, y1 - line_width / 2, z1 - line_width / 2])
      cube([depth, line_width, line_width]);

    translate([0, y2 - line_width / 2, z2 - line_width / 2])
      cube([depth, line_width, line_width]);
  }
}

module gothic_arch_incision_y(width, depth, height, line_width) {
  cap_height = width * 0.55;
  shoulder_z = height - cap_height;
  peak_x = width / 2;

  groove_segment_y(0, 0, 0, shoulder_z, depth, line_width);
  groove_segment_y(width, 0, width, shoulder_z, depth, line_width);
  groove_segment_y(0, shoulder_z, peak_x, height, depth, line_width);
  groove_segment_y(width, shoulder_z, peak_x, height, depth, line_width);
}

module gothic_arch_incision_x(width, depth, height, line_width) {
  cap_height = width * 0.55;
  shoulder_z = height - cap_height;
  peak_y = width / 2;

  groove_segment_x(0, 0, 0, shoulder_z, depth, line_width);
  groove_segment_x(width, 0, width, shoulder_z, depth, line_width);
  groove_segment_x(0, shoulder_z, peak_y, height, depth, line_width);
  groove_segment_x(width, shoulder_z, peak_y, height, depth, line_width);
}

module ring_incision_x(outer_radius, inner_radius, depth) {
  rotate([0, 90, 0])
    difference() {
      cylinder(h=depth, r=outer_radius);

      translate([0, 0, -1])
        cylinder(h=depth + 2, r=inner_radius);
    }
}

function roof_slope_length() = sqrt(pow(outer_depth / 2, 2) + pow(roof_height, 2));
function roof_slope_y(side, slope_pos) =
  side < 0
    ? slope_pos * (outer_depth / 2) / roof_slope_length()
    : outer_depth - slope_pos * (outer_depth / 2) / roof_slope_length();
function roof_slope_z(slope_pos) =
  roof_base_z - overlap + slope_pos * roof_height / roof_slope_length();

module roof_groove_segment(side, x1, slope1, x2, slope2, cut_depth, line_width) {
  hull() {
    translate([x1, roof_slope_y(side, slope1), roof_slope_z(slope1)])
      cube([line_width, cut_depth, line_width], center=true);

    translate([x2, roof_slope_y(side, slope2), roof_slope_z(slope2)])
      cube([line_width, cut_depth, line_width], center=true);
  }
}

module roof_raised_segment(side, x1, slope1, x2, slope2, raised_depth, line_width) {
  hull() {
    translate([x1, roof_slope_y(side, slope1), roof_slope_z(slope1)])
      cube([line_width, raised_depth, line_width], center=true);

    translate([x2, roof_slope_y(side, slope2), roof_slope_z(slope2)])
      cube([line_width, raised_depth, line_width], center=true);
  }
}

module roof_sword_column(side, x_pos, width, raised_depth) {
  lower_slope = 2.5;
  shoulder_slope = roof_slope_length() * 0.76;
  point_slope = roof_slope_length() - 2.5;

  roof_raised_segment(
    side,
    x_pos,
    lower_slope,
    x_pos,
    shoulder_slope,
    raised_depth,
    width
  );

  hull() {
    translate([x_pos, roof_slope_y(side, shoulder_slope), roof_slope_z(shoulder_slope)])
      cube([width * 1.35, raised_depth, width], center=true);

    translate([x_pos, roof_slope_y(side, point_slope), roof_slope_z(point_slope)])
      cube([width * 0.25, raised_depth * 0.55, width * 0.45], center=true);
  }
}

module roof_diamond_panel(side, x_pos, slope_pos, width, height, cut_depth, line_width) {
  roof_groove_segment(side, x_pos + width / 2, slope_pos, x_pos + width, slope_pos + height / 2, cut_depth, line_width);
  roof_groove_segment(side, x_pos + width, slope_pos + height / 2, x_pos + width / 2, slope_pos + height, cut_depth, line_width);
  roof_groove_segment(side, x_pos + width / 2, slope_pos + height, x_pos, slope_pos + height / 2, cut_depth, line_width);
  roof_groove_segment(side, x_pos, slope_pos + height / 2, x_pos + width / 2, slope_pos, cut_depth, line_width);
}

module eaves() {
  translate([0, 0, roof_base_z - eave_height])
    cube([outer_width, wall_thickness + 1, eave_height + overlap]);

  translate([0, outer_depth - wall_thickness - 1, roof_base_z - eave_height])
    cube([outer_width, wall_thickness + 1, eave_height + overlap]);
}

module ridge_cap() {
  translate([
    6,
    outer_depth / 2 - ridge_width / 2,
    roof_peak_z - ridge_width / 2
  ])
    cube([outer_width - 12, ridge_width, ridge_width]);
}

module ridge_finials() {
  for (x_pos = [
    10,
    outer_width * 0.22,
    outer_width * 0.36,
    outer_width / 2,
    outer_width * 0.64,
    outer_width * 0.78,
    outer_width - 10
  ])
    translate([x_pos, outer_depth / 2, roof_peak_z + ridge_width / 2 - overlap])
      cylinder(h=finial_height, r1=2.4, r2=0.7);
}

module sword_spire(height, base_radius) {
  cylinder(h=height * 0.55, r=base_radius);

  translate([0, 0, height * 0.55 - overlap])
    cylinder(h=height * 0.45 + overlap, r1=base_radius * 1.15, r2=0.25);
}

module corner_pinnacles() {
  pinnacle_height = 18;

  for (x_pos = [5, outer_width - 5])
    for (y_pos = [5, outer_depth - 5])
      translate([x_pos, y_pos, roof_base_z - overlap])
        union() {
          cylinder(h=pinnacle_height - 5, r=1.8);

          translate([0, 0, pinnacle_height - 5])
            cylinder(h=5, r1=2.5, r2=0.4);
        }
}

module roof_ribs() {
  rib_width = 1.4;
  rib_count = 11;
  rib_spacing = outer_width / (rib_count + 1);

  for (i = [0 : rib_count - 1]) {
    x_pos = rib_spacing * (i + 1) - rib_width / 2;

    translate([x_pos, 1, roof_base_z + 1])
      cube([rib_width, 3, roof_height - 2]);

    translate([x_pos, outer_depth - 4, roof_base_z + 1])
      cube([rib_width, 3, roof_height - 2]);
  }
}

module roof_sword_spires() {
  spire_positions = [
    outer_width * 0.08,
    outer_width * 0.16,
    outer_width * 0.24,
    outer_width * 0.32,
    outer_width * 0.40,
    outer_width * 0.48,
    outer_width * 0.56,
    outer_width * 0.64,
    outer_width * 0.72,
    outer_width * 0.80,
    outer_width * 0.88,
    outer_width * 0.96
  ];

  for (x_pos = spire_positions)
    translate([x_pos, outer_depth / 2, roof_peak_z + ridge_width / 2 - overlap])
      sword_spire(9, 0.85);

  for (x_pos = spire_positions) {
    translate([x_pos, 2.2, roof_base_z + 1])
      sword_spire(13, 0.9);

    translate([x_pos, outer_depth - 2.2, roof_base_z + 1])
      sword_spire(13, 0.9);
  }

  for (side = [-1, 1])
    for (x_pos = spire_positions)
      translate([
        x_pos,
        roof_slope_y(side, roof_slope_length() * 0.42),
        roof_slope_z(roof_slope_length() * 0.42)
      ])
        sword_spire(12, 0.85);
}

module roof_side_sword_columns() {
  column_positions = [
    outer_width * 0.07,
    outer_width * 0.14,
    outer_width * 0.21,
    outer_width * 0.28,
    outer_width * 0.35,
    outer_width * 0.42,
    outer_width * 0.49,
    outer_width * 0.56,
    outer_width * 0.63,
    outer_width * 0.70,
    outer_width * 0.77,
    outer_width * 0.84,
    outer_width * 0.91
  ];

  for (side = [-1, 1])
    for (x_pos = column_positions)
      roof_sword_column(side, x_pos, 1.6, 2.2);
}

module lateral_wall_sword_columns() {
  column_depth = 2.2;
  column_width = 1.7;
  column_height = filter_clearance_height - 7;
  spire_height = 10;
  x_positions = [
    outer_width * 0.08,
    outer_width * 0.16,
    outer_width * 0.24,
    outer_width * 0.32,
    outer_width * 0.40,
    outer_width * 0.48,
    outer_width * 0.56,
    outer_width * 0.64,
    outer_width * 0.72,
    outer_width * 0.80,
    outer_width * 0.88,
    outer_width * 0.96
  ];
  y_positions = [
    outer_depth * 0.10,
    outer_depth * 0.20,
    outer_depth * 0.30,
    outer_depth * 0.40,
    outer_depth * 0.50,
    outer_depth * 0.60,
    outer_depth * 0.70,
    outer_depth * 0.80,
    outer_depth * 0.90
  ];

  for (y_pos = y_positions) {
    translate([-column_depth + overlap, y_pos - column_width / 2, skirt_height])
      cube([column_depth, column_width, column_height]);

    translate([-column_depth / 2, y_pos, skirt_height + column_height - overlap])
      sword_spire(spire_height, 0.9);

    translate([outer_width - overlap, y_pos - column_width / 2, skirt_height])
      cube([column_depth, column_width, column_height]);

    translate([outer_width + column_depth / 2, y_pos, skirt_height + column_height - overlap])
      sword_spire(spire_height, 0.9);
  }

  for (x_pos = x_positions) {
    translate([x_pos - column_width / 2, -column_depth + overlap, skirt_height])
      cube([column_width, column_depth, column_height]);

    translate([x_pos, -column_depth / 2, skirt_height + column_height - overlap])
      sword_spire(spire_height, 0.9);

    translate([x_pos - column_width / 2, outer_depth - overlap, skirt_height])
      cube([column_width, column_depth, column_height]);

    translate([x_pos, outer_depth + column_depth / 2, skirt_height + column_height - overlap])
      sword_spire(spire_height, 0.9);
  }
}

module ridge_parallel_wall_supports() {
  support_depth = 1.6;
  support_height = 1.6;
  support_length = outer_width - 12;
  gable_line_width = 1.6;
  gable_line_depth = 1.8;
  z_positions = [
    skirt_height + 10,
    skirt_height + 22,
    skirt_height + 34
  ];

  module gable_support_segment(x_pos, y1, z1, y2, z2) {
    hull() {
      translate([x_pos, y1, z1])
        cube([gable_line_depth, gable_line_width, gable_line_width], center=true);

      translate([x_pos, y2, z2])
        cube([gable_line_depth, gable_line_width, gable_line_width], center=true);
    }
  }

  for (x_pos = [-gable_line_depth / 2 + overlap, outer_width + gable_line_depth / 2 - overlap]) {
    for (base_z = [skirt_height + 6, skirt_height + 18, skirt_height + 30]) {
      gable_support_segment(x_pos, 4, base_z, outer_depth / 2 - 2, base_z + 14);
      gable_support_segment(x_pos, outer_depth - 4, base_z, outer_depth / 2 + 2, base_z + 14);
    }

    gable_support_segment(x_pos, 4, roof_base_z - 13, outer_depth / 2 - 2, roof_base_z - 2);
    gable_support_segment(x_pos, outer_depth - 4, roof_base_z - 13, outer_depth / 2 + 2, roof_base_z - 2);
  }

  for (z_pos = z_positions) {
    translate([6, -support_depth + overlap, z_pos])
      cube([support_length, support_depth, support_height]);

    translate([6, outer_depth - overlap, z_pos])
      cube([support_length, support_depth, support_height]);
  }
}

module wall_incisions() {
  incision_depth = 1.2;
  line_width = 1.0;

  for (x_pos = [
    outer_width * 0.12,
    outer_width * 0.25,
    outer_width * 0.38,
    outer_width * 0.50,
    outer_width * 0.62,
    outer_width * 0.75,
    outer_width * 0.88
  ]) {
    translate([x_pos - 7, -0.1, skirt_height + 8])
      gothic_arch_incision_y(14, incision_depth, 30, line_width);

    translate([x_pos - 7, outer_depth - incision_depth + 0.1, skirt_height + 8])
      gothic_arch_incision_y(14, incision_depth, 30, line_width);
  }

  for (y_pos = [outer_depth * 0.24, outer_depth * 0.50, outer_depth * 0.76]) {
    translate([-0.1, y_pos - 7, skirt_height + 10])
      gothic_arch_incision_x(14, incision_depth, 30, line_width);

    translate([outer_width - incision_depth + 0.1, y_pos - 7, skirt_height + 10])
      gothic_arch_incision_x(14, incision_depth, 30, line_width);
  }

  for (x_pos = [-0.1, outer_width - incision_depth + 0.1])
    for (z_pos = [roof_base_z - 18, roof_base_z - 9])
      translate([x_pos, outer_depth / 2, z_pos])
        ring_incision_x(4.2, 2.8, incision_depth);
}

module roof_incisions() {
  incision_depth = 1.2;
  line_width = 0.8;
  slope_step = roof_slope_length() / 4;

  for (side = [-1, 1])
    for (x_pos = [
      outer_width * 0.10,
      outer_width * 0.23,
      outer_width * 0.36,
      outer_width * 0.49,
      outer_width * 0.62,
      outer_width * 0.75
    ])
      for (slope_pos = [3, 3 + slope_step, 3 + 2 * slope_step])
        roof_diamond_panel(
          side,
          x_pos,
          slope_pos,
          10,
          8,
          incision_depth,
          line_width
        );

  for (side = [-1, 1])
    for (x_pos = [
      outer_width * 0.17,
      outer_width * 0.30,
      outer_width * 0.43,
      outer_width * 0.56,
      outer_width * 0.69,
      outer_width * 0.82
    ])
      roof_groove_segment(
        side,
        x_pos,
        2,
        x_pos + 7,
        roof_slope_length() - 3,
        incision_depth,
        0.7
      );
}

difference() {
  union() {
    wall_shell();
    gabled_roof();
    eaves();
    ridge_cap();
    roof_ribs();
    roof_side_sword_columns();
    lateral_wall_sword_columns();
    ridge_parallel_wall_supports();
    ridge_finials();
    roof_sword_spires();
    corner_pinnacles();
  }

  wall_incisions();
  roof_incisions();
}

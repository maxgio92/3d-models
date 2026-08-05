holder_outer_width = 130;
holder_outer_depth = 40;

clearance = 1;
wall_thickness = 2;
rim_height = 12;
roof_height = 26;
eave_height = 2;
ridge_width = 3;
overlap = 0.2;

inner_width = holder_outer_width + 2 * clearance;
inner_depth = holder_outer_depth + 2 * clearance;
outer_width = inner_width + 2 * wall_thickness;
outer_depth = inner_depth + 2 * wall_thickness;
total_height = rim_height + roof_height;

$fn = 32;

module lid_rim() {
  translate([0, 0, 0])
    cube([outer_width, wall_thickness, rim_height + overlap]);

  translate([0, outer_depth - wall_thickness, 0])
    cube([outer_width, wall_thickness, rim_height + overlap]);

  translate([0, wall_thickness, 0])
    cube([wall_thickness, inner_depth, rim_height + overlap]);

  translate([outer_width - wall_thickness, wall_thickness, 0])
    cube([wall_thickness, inner_depth, rim_height + overlap]);
}

module gabled_roof() {
  roof_base_z = rim_height - overlap;
  roof_peak_z = total_height;
  ridge_y = outer_depth / 2;

  polyhedron(
    points=[
      [0, 0, roof_base_z],
      [outer_width, 0, roof_base_z],
      [outer_width, outer_depth, roof_base_z],
      [0, outer_depth, roof_base_z],
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

module groove_segment_x(y1, z1, y2, z2, depth, line_width) {
  hull() {
    translate([0, y1 - line_width / 2, z1 - line_width / 2])
      cube([depth, line_width, line_width]);

    translate([0, y2 - line_width / 2, z2 - line_width / 2])
      cube([depth, line_width, line_width]);
  }
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

module gothic_arch_incision_y(width, depth, height, line_width) {
  cap_height = width * 0.55;
  shoulder_z = height - cap_height;
  peak_x = width / 2;

  hull() {
    translate([-line_width / 2, 0, -line_width / 2])
      cube([line_width, depth, line_width]);
    translate([-line_width / 2, 0, shoulder_z - line_width / 2])
      cube([line_width, depth, line_width]);
  }

  hull() {
    translate([width - line_width / 2, 0, -line_width / 2])
      cube([line_width, depth, line_width]);
    translate([width - line_width / 2, 0, shoulder_z - line_width / 2])
      cube([line_width, depth, line_width]);
  }

  hull() {
    translate([-line_width / 2, 0, shoulder_z - line_width / 2])
      cube([line_width, depth, line_width]);
    translate([peak_x - line_width / 2, 0, height - line_width / 2])
      cube([line_width, depth, line_width]);
  }

  hull() {
    translate([width - line_width / 2, 0, shoulder_z - line_width / 2])
      cube([line_width, depth, line_width]);
    translate([peak_x - line_width / 2, 0, height - line_width / 2])
      cube([line_width, depth, line_width]);
  }
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
  for (angle = [0 : 45 : 135])
    rotate([angle, 0, 0])
      translate([0, -line_width / 2, -radius])
        cube([depth, line_width, 2 * radius]);
}

module eaves() {
  translate([0, 0, rim_height - eave_height])
    cube([outer_width, wall_thickness + 1, eave_height + overlap]);

  translate([0, outer_depth - wall_thickness - 1, rim_height - eave_height])
    cube([outer_width, wall_thickness + 1, eave_height + overlap]);
}

module ridge_cap() {
  translate([
    6,
    outer_depth / 2 - ridge_width / 2,
    total_height - ridge_width / 2
  ])
    cube([outer_width - 12, ridge_width, ridge_width]);
}

module finials() {
  for (x_pos = [
    10,
    outer_width * 0.22,
    outer_width * 0.36,
    outer_width / 2,
    outer_width * 0.64,
    outer_width * 0.78,
    outer_width - 10
  ])
    translate([x_pos, outer_depth / 2, total_height + 2])
      cylinder(h=7, r1=2.4, r2=0.7);
}

module corner_pinnacles() {
  pinnacle_height = 13;

  for (x_pos = [5, outer_width - 5])
    for (y_pos = [5, outer_depth - 5])
      translate([x_pos, y_pos, rim_height - overlap])
        union() {
          cylinder(h=pinnacle_height - 4, r=1.8);

          translate([0, 0, pinnacle_height - 4])
            cylinder(h=4, r1=2.4, r2=0.4);
        }
}

module roof_ribs() {
  rib_width = 1.4;
  rib_count = 9;
  rib_spacing = outer_width / (rib_count + 1);

  for (i = [0 : rib_count - 1]) {
    x_pos = rib_spacing * (i + 1) - rib_width / 2;

    translate([x_pos, 1, rim_height + 1])
      cube([rib_width, 3, roof_height - 2]);

    translate([x_pos, outer_depth - 4, rim_height + 1])
      cube([rib_width, 3, roof_height - 2]);
  }
}

module gothic_incisions() {
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
    translate([
      x_pos - 7,
      -0.1,
      rim_height + 3
    ])
      gothic_arch_incision_y(14, incision_depth, 18, line_width);

    translate([
      x_pos - 7,
      outer_depth - incision_depth + 0.1,
      rim_height + 3
    ])
      gothic_arch_incision_y(14, incision_depth, 18, line_width);
  }

  for (y_pos = [outer_depth * 0.24, outer_depth * 0.50, outer_depth * 0.76]) {
    translate([
      -0.1,
      y_pos - 6,
      rim_height + 3
    ])
      gothic_arch_incision_x(12, incision_depth, 17, line_width);

    translate([
      outer_width - incision_depth + 0.1,
      y_pos - 6,
      rim_height + 3
    ])
      gothic_arch_incision_x(12, incision_depth, 17, line_width);
  }

  for (x_pos = [outer_width * 0.25, outer_width * 0.50, outer_width * 0.75]) {
    translate([
      x_pos - 5,
      -0.1,
      rim_height + 22
    ])
      gothic_arch_incision_y(10, incision_depth, 10, line_width);

    translate([
      x_pos - 5,
      outer_depth - incision_depth + 0.1,
      rim_height + 22
    ])
      gothic_arch_incision_y(10, incision_depth, 10, line_width);
  }

  for (x_pos = [-0.1, outer_width - incision_depth + 0.1]) {
    for (z_pos = [rim_height + 17, rim_height + 25]) {
      translate([x_pos, outer_depth / 2, z_pos])
        ring_incision_x(4.2, 2.8, incision_depth);

      translate([x_pos, outer_depth / 2, z_pos])
        rosette_rays_x(2.8, incision_depth, 0.7);
    }
  }

  for (x_pos = [outer_width * 0.18, outer_width * 0.32, outer_width * 0.46, outer_width * 0.60, outer_width * 0.74]) {
    translate([
      x_pos - 8,
      -0.1,
      rim_height + 10
    ])
      gothic_arch_incision_y(16, incision_depth, 20, 0.8);

    translate([
      x_pos + 7,
      -0.1,
      rim_height + 10
    ])
      mirror([1, 0, 0])
        gothic_arch_incision_y(16, incision_depth, 20, 0.8);

    translate([
      x_pos - 8,
      outer_depth - incision_depth + 0.1,
      rim_height + 10
    ])
      gothic_arch_incision_y(16, incision_depth, 20, 0.8);

    translate([
      x_pos + 7,
      outer_depth - incision_depth + 0.1,
      rim_height + 10
    ])
      mirror([1, 0, 0])
        gothic_arch_incision_y(16, incision_depth, 20, 0.8);
  }

  for (y_pos = [outer_depth * 0.28, outer_depth * 0.50, outer_depth * 0.72]) {
    translate([
      -0.1,
      y_pos - 8,
      rim_height + 20
    ])
      gothic_arch_incision_x(16, incision_depth, 13, 0.8);

    translate([
      outer_width - incision_depth + 0.1,
      y_pos - 8,
      rim_height + 20
    ])
      gothic_arch_incision_x(16, incision_depth, 13, 0.8);
  }
}

difference() {
  union() {
    lid_rim();
    gabled_roof();
    eaves();
    ridge_cap();
    roof_ribs();
    finials();
    corner_pinnacles();
  }

  gothic_incisions();
}

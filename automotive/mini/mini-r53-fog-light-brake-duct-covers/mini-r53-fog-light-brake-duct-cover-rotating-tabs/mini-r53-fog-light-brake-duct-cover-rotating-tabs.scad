side = "left"; // "left", "right", or "pair"
component = "assembly"; // "assembly", "cover", or "tabs"

bumper_cut_diameter = 66;
opening_diameter = 60.5;
outer_diameter = 86;
outer_flange_thickness = 3;
front_ring_y_thickness = 2.5;
front_limb_depth = 16;
center_limb_depth = 0.2;
front_limb_curve_power = 1.65;
front_limb_segments = 432;

rear_collar_outer_diameter = 65.5;
rear_collar_depth = 22;
rear_collar_wall = 2.5;

seal_lip_outer_diameter = 65.5;
seal_lip_depth = 4;
seal_lip_wall = 2.5;
connector_shoulder_depth = 2;
front_body_back_y = -outer_flange_thickness - seal_lip_depth - connector_shoulder_depth;
middle_ring_profile_scale = 0.45;

bumper_thickness = 3;
tab_pivot_radius = 39;
tab_pivot_angles = [
  35,
  145,
  215,
  325
];
tab_length = 18;
tab_width = 8;
tab_thickness = 3;
tab_screw_clearance = 2.6;

$fn = 72;

function vertical_limb_progress(z) =
  let (
    outer_radius = outer_diameter / 2,
    abs_z = abs(z),
    u = min(1, abs_z / outer_radius),
    eased = 0.5 - 0.5 * cos(180 * u)
  )
    pow(eased, front_limb_curve_power);

function front_depth_at_z(z) =
  center_limb_depth + (front_limb_depth - center_limb_depth) * vertical_limb_progress(z);

function profiled_y_at_z(z, scale) =
  front_body_back_y + (front_depth_at_z(z) - front_body_back_y) * scale;

function ring_vertex_index(segment, point) = segment * 7 + point;

module progressive_front_body() {
  outer_radius = outer_diameter / 2;
  middle_radius = seal_lip_outer_diameter / 2;
  rear_join_radius = rear_collar_outer_diameter / 2;
  front_inner_radius = opening_diameter / 2;
  rear_inner_radius = (rear_collar_outer_diameter - 2 * rear_collar_wall) / 2;

  polyhedron(
    points = [
      for (segment = [0:front_limb_segments - 1])
        let (
          angle = 360 * segment / front_limb_segments,
          outer_z = outer_radius * sin(angle),
          middle_z = middle_radius * sin(angle),
          rear_join_z = rear_join_radius * sin(angle),
          front_inner_z = front_inner_radius * sin(angle),
          rear_inner_z = rear_inner_radius * sin(angle),
          outer_middle_y = profiled_y_at_z(outer_z, middle_ring_profile_scale),
          rear_join_y = profiled_y_at_z(rear_join_z, 0),
          middle_front_y = profiled_y_at_z(middle_z, middle_ring_profile_scale),
          outer_front_y = profiled_y_at_z(outer_z, 1),
          inner_front_y = profiled_y_at_z(front_inner_z, 1),
          outer_front_back_y = outer_front_y - front_ring_y_thickness,
          inner_front_back_y = inner_front_y - front_ring_y_thickness,
          inner_back_y = profiled_y_at_z(rear_inner_z, 0)
        )
        each [
          [outer_radius * cos(angle), outer_front_y, outer_z],
          [front_inner_radius * cos(angle), inner_front_y, front_inner_z],
          [front_inner_radius * cos(angle), inner_front_back_y, front_inner_z],
          [rear_inner_radius * cos(angle), inner_back_y, rear_inner_z],
          [rear_join_radius * cos(angle), rear_join_y, rear_join_z],
          [middle_radius * cos(angle), middle_front_y, middle_z],
          [outer_radius * cos(angle), outer_front_back_y, outer_z]
        ]
    ],
    faces = [
      for (segment = [0:front_limb_segments - 1])
        let (next_segment = (segment + 1) % front_limb_segments)
        each [
          for (edge = [0:6])
            let (next_edge = (edge + 1) % 7)
            each [
              [
                ring_vertex_index(segment, edge),
                ring_vertex_index(next_segment, edge),
                ring_vertex_index(segment, next_edge)
              ],
              [
                ring_vertex_index(next_segment, edge),
                ring_vertex_index(next_segment, next_edge),
                ring_vertex_index(segment, next_edge)
              ]
            ]
        ]
    ]
  );
}

module circular_tube(outer_diameter, depth, wall) {
  linear_extrude(depth)
    difference() {
      circle(d = outer_diameter);
      circle(d = outer_diameter - 2 * wall);
    }
}

module tab_pivot_positions() {
  for (angle = tab_pivot_angles)
    translate([
      tab_pivot_radius * cos(angle),
      0,
      tab_pivot_radius * sin(angle)
    ])
      rotate([0, -angle, 0])
        children();
}

module rounded_tab_2d() {
  hull() {
    circle(d = tab_width);
    translate([tab_length, 0])
      circle(d = tab_width);
  }
}

module rotating_tab() {
  difference() {
    rotate([90, 0, 0])
      linear_extrude(tab_thickness)
        translate([-tab_width / 2, 0])
          rounded_tab_2d();

    translate([0, -tab_thickness - 0.1, 0])
      rotate([-90, 0, 0])
        cylinder(h = tab_thickness + 0.2, d = tab_screw_clearance);
  }
}

module rotating_tabs() {
  tab_pivot_positions()
    rotating_tab();
}

module duct_cover(side_sign = 1) {
  difference() {
    union() {
      progressive_front_body();

      translate([0, -outer_flange_thickness - seal_lip_depth - connector_shoulder_depth, 0])
        rotate([90, 0, 0])
          circular_tube(rear_collar_outer_diameter, rear_collar_depth, rear_collar_wall);
    }

    translate([0, -outer_flange_thickness - seal_lip_depth - connector_shoulder_depth - rear_collar_depth - 1, 0])
      rotate([-90, 0, 0])
        cylinder(
          h = front_limb_depth + outer_flange_thickness + seal_lip_depth + connector_shoulder_depth + rear_collar_depth + 3,
          d = opening_diameter
        );
  }
}

module selected_cover() {
  if (side == "left") {
    duct_cover(-1);
  } else if (side == "right") {
    duct_cover(1);
  } else {
    translate([-outer_diameter / 2 - 10, 0, 0])
      duct_cover(-1);
    translate([outer_diameter / 2 + 10, 0, 0])
      duct_cover(1);
  }
}

if (component == "cover") {
  selected_cover();
} else if (component == "tabs") {
  rotating_tabs();
} else {
  selected_cover();
  translate([0, front_body_back_y - bumper_thickness - 4, 0])
    rotating_tabs();
}

side = "left"; // "left", "right", or "pair"
component = "assembly"; // "assembly", "cover", or "clamp-ring"

bumper_cut_diameter = 66;
opening_diameter = 60.5;
intake_mouth_diameter = 72;
front_edge_mouth_diameter = 80;
outer_diameter = 86;
outer_flange_thickness = 3;
front_ring_shell_thickness = 2.5;
front_limb_depth = 10;
front_limb_tip_extra_depth = 0;
front_limb_tip_height = 10;
center_limb_depth = 0.2;
front_limb_curve_power = 3.6;
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
clamp_ring_thickness = 12;
clamp_ring_flange_thickness = 3;
clamp_ring_outer_diameter = 82;
clamp_ring_flange_outer_diameter = 86;
clamp_ring_inner_diameter = 66.5;
clamp_screw_clearance = 3.2;
clamp_screw_side_radius = (clamp_ring_outer_diameter + clamp_ring_inner_diameter) / 4;
clamp_screw_side_y =
  -clamp_ring_flange_thickness
  - (clamp_ring_thickness - clamp_ring_flange_thickness) / 2;
clamp_screw_side_length =
  (clamp_ring_outer_diameter - clamp_ring_inner_diameter) / 2 + 2;
clamp_screw_angles = [
  35,
  145,
  215,
  325
];

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
  let (
    outer_radius = outer_diameter / 2,
    abs_z = z < 0 ? abs(z) : 0,
    tip_start = outer_radius - front_limb_tip_height,
    tip_u = abs_z <= tip_start ? 0 : min(1, (abs_z - tip_start) / front_limb_tip_height),
    tip_progress = tip_u * tip_u * (3 - 2 * tip_u)
  )
    center_limb_depth
      + (front_limb_depth - center_limb_depth) * vertical_limb_progress(z)
      + front_limb_tip_extra_depth * tip_progress;

function profiled_y_at_z(z, scale) =
  front_body_back_y + (front_depth_at_z(z) - front_body_back_y) * scale;

function ring_vertex_index(segment, point) = segment * 7 + point;

module progressive_front_body() {
  outer_radius = outer_diameter / 2;
  middle_radius = max(seal_lip_outer_diameter, intake_mouth_diameter) / 2;
  rear_join_radius = rear_collar_outer_diameter / 2;
  front_inner_radius = intake_mouth_diameter / 2;
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
          outer_front_back_y = outer_front_y - front_ring_shell_thickness,
          inner_front_back_y = inner_front_y - front_ring_shell_thickness,
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

module smooth_intake_cut() {
  rear_y = front_body_back_y - rear_collar_depth - 1;
  front_y = front_limb_depth + front_limb_tip_extra_depth + 1;
  bellmouth_start_y = front_body_back_y + 1;
  edge_flare_start_y = front_y - 10;
  sections = 24;
  edge_sections = 18;

  function smooth_progress(t) =
    t * t * t * (t * (t * 6 - 15) + 10);

  function bellmouth_y(i) =
    bellmouth_start_y + (edge_flare_start_y - bellmouth_start_y) * i / sections;

  function bellmouth_diameter(i) =
    opening_diameter
      + (intake_mouth_diameter - opening_diameter)
        * smooth_progress(i / sections);

  function edge_flare_y(i) =
    edge_flare_start_y + (front_y - edge_flare_start_y) * i / edge_sections;

  function edge_flare_diameter(i) =
    intake_mouth_diameter
      + (front_edge_mouth_diameter - intake_mouth_diameter)
        * smooth_progress(i / edge_sections);

  module circular_slice(y_pos, diameter) {
    translate([0, y_pos, 0])
      rotate([-90, 0, 0])
        cylinder(h = 0.4, d = diameter);
  }

  hull() {
    circular_slice(rear_y - 0.1, opening_diameter);
    circular_slice(bellmouth_start_y + 0.1, opening_diameter);
  }

  for (i = [0:sections - 1])
    hull() {
      circular_slice(bellmouth_y(i) - 0.1, bellmouth_diameter(i));
      circular_slice(bellmouth_y(i + 1) + 0.1, bellmouth_diameter(i + 1));
    }

  for (i = [0:edge_sections - 1])
    hull() {
      circular_slice(edge_flare_y(i) - 0.1, edge_flare_diameter(i));
      circular_slice(edge_flare_y(i + 1) + 0.1, edge_flare_diameter(i + 1));
    }
}

module radial_screw_holes() {
  for (angle = clamp_screw_angles)
    translate([
      clamp_screw_side_radius * cos(angle),
      clamp_screw_side_y,
      clamp_screw_side_radius * sin(angle)
    ])
      rotate([0, 90 - angle, 0])
        cylinder(h = clamp_screw_side_length, d = clamp_screw_clearance, center = true);
}

module rear_clamp_ring() {
  difference() {
    union() {
      translate([0, -clamp_ring_flange_thickness + 0.1, 0])
        rotate([90, 0, 0])
          linear_extrude(clamp_ring_thickness - clamp_ring_flange_thickness + 0.1)
            difference() {
              circle(d = clamp_ring_outer_diameter);
              circle(d = clamp_ring_inner_diameter);
            }

      rotate([90, 0, 0])
        linear_extrude(clamp_ring_flange_thickness)
          difference() {
            circle(d = clamp_ring_flange_outer_diameter);
            circle(d = clamp_ring_inner_diameter);
          }
    }

    radial_screw_holes();
  }
}

module duct_cover(side_sign = 1) {
  difference() {
    union() {
      progressive_front_body();

      translate([0, -outer_flange_thickness - seal_lip_depth - connector_shoulder_depth, 0])
        rotate([90, 0, 0])
          circular_tube(rear_collar_outer_diameter, rear_collar_depth, rear_collar_wall);
    }

    smooth_intake_cut();
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
} else if (component == "clamp-ring") {
  rear_clamp_ring();
} else {
  selected_cover();
  translate([0, front_body_back_y - bumper_thickness, 0])
    rear_clamp_ring();
}

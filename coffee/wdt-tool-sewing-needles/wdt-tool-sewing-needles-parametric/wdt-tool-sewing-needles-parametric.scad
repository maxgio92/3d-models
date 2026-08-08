// Parametric WDT tool for sewing needles.
//
// Render one part at a time by changing `part`:
//   "tool"      handle + needle cartridge
//   "cap"       protective cap for the needle tips
//   "stand"     vertical bench stand
//   "layout"    all printed parts laid out for preview/export planning
//
// Sewing needles are not printed. The gray rods in preview mode show where the
// needles should sit. For real prints, set show_preview_needles = false.

part = "layout"; // ["tool", "cap", "stand", "layout"]
show_preview_needles = true;

needle_count = 9;
needle_diameter = 1.10;
needle_hole_diameter = 1.45;
needle_exposed_length = 45;
needle_embedded_length = 9;
needle_splay_angle = 7;
needle_pattern_radius = 3.1;

cartridge_diameter = 17;
cartridge_height = 13;
cartridge_socket_depth = 6;

handle_diameter = 25;
handle_height = 58;
handle_waist_diameter = 20;
handle_top_diameter = 18;

cap_wall = 2.2;
cap_clearance = 1.1;
cap_height = needle_exposed_length + 10;
cap_tip_clearance = 6;

stand_base_diameter = 44;
stand_height = 34;
stand_socket_clearance = 0.7;

layer_overlap = 0.2;
$fn = 80;

module rounded_cylinder(height, radius, round_radius) {
  cylinder(h=round_radius, r1=radius - round_radius, r2=radius);

  translate([0, 0, round_radius])
    cylinder(h=height - 2 * round_radius, r=radius);

  translate([0, 0, height - round_radius])
    cylinder(h=round_radius, r1=radius, r2=radius - round_radius);
}

module tapered_cylinder(height, bottom_radius, top_radius) {
  cylinder(h=height, r1=bottom_radius, r2=top_radius);
}

module grip_grooves(radius, height, count, groove_radius) {
  for (i = [0 : count - 1]) {
    angle = 360 * i / count;
    rotate([0, 0, angle])
      translate([radius, 0, height * 0.50])
        rotate([0, 90, 0])
          cylinder(h=radius * 0.55, r=groove_radius, center=true, $fn=24);
  }
}

module needle_position(index) {
  angle = 360 * index / needle_count;
  translate([
    needle_pattern_radius * cos(angle),
    needle_pattern_radius * sin(angle),
    cartridge_height - needle_embedded_length
  ])
    rotate([needle_splay_angle, 0, angle])
      children();
}

module needle_holes() {
  for (i = [0 : needle_count - 1])
    needle_position(i)
      translate([0, 0, -layer_overlap])
        cylinder(
          h=needle_embedded_length + layer_overlap * 2,
          d=needle_hole_diameter,
          $fn=20
        );

  // Small center relief makes epoxy/filler easier to add after needles are set.
  translate([0, 0, cartridge_height - needle_embedded_length - layer_overlap])
    cylinder(h=needle_embedded_length * 0.50, d=3.2, $fn=32);
}

module preview_needles() {
  if (show_preview_needles)
    color([0.72, 0.72, 0.72])
      for (i = [0 : needle_count - 1])
        needle_position(i)
          translate([0, 0, -needle_exposed_length])
            cylinder(
              h=needle_exposed_length + needle_embedded_length,
              d=needle_diameter,
              $fn=16
            );
}

module cartridge() {
  difference() {
    union() {
      cylinder(h=cartridge_height, d=cartridge_diameter);

      translate([0, 0, cartridge_height - 2.6])
        cylinder(h=2.6, d1=cartridge_diameter, d2=cartridge_diameter - 2.2);
    }

    needle_holes();

    // Index mark for aligning the needle spread consistently.
    translate([0, -cartridge_diameter / 2 - 0.1, cartridge_height - 6])
      cube([1.1, 2.2, 5], center=true);
  }
}

module handle() {
  difference() {
    union() {
      rounded_cylinder(handle_height, handle_diameter / 2, 1.4);

      translate([0, 0, handle_height - 8])
        tapered_cylinder(8, handle_diameter / 2 - 1, handle_top_diameter / 2);
    }

    translate([0, 0, handle_height - cartridge_socket_depth + layer_overlap])
      cylinder(
        h=cartridge_socket_depth + layer_overlap,
        d=cartridge_diameter + 0.35
      );

    translate([0, 0, handle_height * 0.30])
      grip_grooves(handle_diameter / 2, handle_height, 18, 1.2);

    translate([0, 0, handle_height * 0.64])
      rotate([0, 0, 10])
        grip_grooves(handle_diameter / 2, handle_height, 18, 0.85);
  }
}

module tool() {
  union() {
    handle();

    translate([0, 0, handle_height - cartridge_socket_depth])
      cartridge();
  }

  translate([0, 0, handle_height - cartridge_socket_depth])
    preview_needles();
}

module cap() {
  inner_diameter = cartridge_diameter + cap_clearance;
  outer_diameter = inner_diameter + 2 * cap_wall;

  difference() {
    union() {
      cylinder(h=cap_height, d=outer_diameter);

      translate([0, 0, cap_height])
        sphere(d=outer_diameter);
    }

    translate([0, 0, cap_wall])
      cylinder(h=cap_height + outer_diameter, d=inner_diameter);

    translate([0, 0, cap_wall + cap_tip_clearance])
      cylinder(
        h=cap_height + outer_diameter,
        d=inner_diameter + 5
      );

    for (i = [0 : 5])
      rotate([0, 0, 60 * i])
        translate([outer_diameter / 2 - 0.4, 0, cap_height * 0.42])
          cube([1.2, 2.4, cap_height * 0.50], center=true);
  }
}

module stand() {
  socket_diameter = handle_diameter + stand_socket_clearance;

  difference() {
    union() {
      rounded_cylinder(stand_height, stand_base_diameter / 2, 1.5);

      translate([0, 0, stand_height - 8])
        cylinder(h=8, d1=stand_base_diameter - 6, d2=stand_base_diameter - 12);
    }

    translate([0, 0, 8])
      cylinder(h=stand_height, d=socket_diameter);

    translate([0, 0, 5])
      cylinder(h=stand_height, d=handle_waist_diameter + 2.4);

    for (i = [0 : 5])
      rotate([0, 0, 60 * i])
        translate([stand_base_diameter / 2 - 3.8, 0, 6])
          cylinder(h=stand_height, d=5.2, center=false);
  }
}

module layout() {
  translate([-45, 0, 0])
    tool();

  translate([6, 0, 0])
    cap();

  translate([48, 0, 0])
    stand();
}

if (part == "tool")
  tool();
else if (part == "cap")
  cap();
else if (part == "stand")
  stand();
else
  layout();

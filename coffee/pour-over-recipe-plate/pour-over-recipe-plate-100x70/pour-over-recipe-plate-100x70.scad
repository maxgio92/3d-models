plate_width = 100;
plate_height = 70;
plate_thickness = 3;
corner_radius = 3;

engrave_depth = 0.55;
line_width = 0.35;
margin = 4;

font_name = "Liberation Sans";
font_bold = "Liberation Sans:style=Bold";

$fn = 36;

module rounded_plate(width, height, radius, thickness) {
  linear_extrude(thickness)
    hull() {
      translate([radius, radius])
        circle(r=radius);
      translate([width - radius, radius])
        circle(r=radius);
      translate([width - radius, height - radius])
        circle(r=radius);
      translate([radius, height - radius])
        circle(r=radius);
    }
}

module engraved_text(txt, x, y, size, font=font_name, halign="left") {
  translate([x, y, plate_thickness - engrave_depth])
    linear_extrude(engrave_depth + 0.08)
      text(txt, size=size, font=font, halign=halign, valign="center");
}

module engraved_line(x, y, width, height) {
  translate([x, y, plate_thickness - engrave_depth])
    cube([width, height, engrave_depth + 0.08]);
}

module frame() {
  engraved_line(margin, 59.0, plate_width - 2 * margin, line_width);
  engraved_line(margin, 49.8, plate_width - 2 * margin, line_width);
  engraved_line(margin, 28.5, plate_width - 2 * margin, line_width);
  engraved_line(margin, 8.0, plate_width - 2 * margin, line_width);
  engraved_line(50, 28.5, line_width, 21.3);
  engraved_line(50, 8.0, line_width, 20.5);
}

module recipe_text() {
  engraved_text("POUR-OVER RECIPE", plate_width / 2, 65.2, 4.1, font_bold, "center");
  engraved_text("20g coffee / 300g water / 1:15", plate_width / 2, 61.1, 2.55, font_bold, "center");

  engraved_text("TEMP", 7, 55.4, 2.2, font_bold);
  engraved_text("88-95 C", 23, 55.4, 2.45);
  engraved_text("GRIND", 53, 55.4, 2.2, font_bold);
  engraved_text("2.7 - 3.3", 71, 55.4, 2.45);

  engraved_text("40% FLAVOR", plate_width / 2, 46.1, 2.65, font_bold, "center");
  engraved_text("sweet", 26.5, 42.3, 2.25, font_bold, "center");
  engraved_text("0:00  50g  +50g", 7, 38.4, 2.25);
  engraved_text("0:45 120g  +70g", 7, 34.7, 2.25);

  engraved_text("acid", 73.5, 42.3, 2.25, font_bold, "center");
  engraved_text("0:00  70g  +70g", 54, 38.4, 2.25);
  engraved_text("0:45 120g  +50g", 54, 34.7, 2.25);

  engraved_text("60% STRENGTH", plate_width / 2, 25.0, 2.55, font_bold, "center");
  engraved_text("lighter", 26.5, 21.2, 2.15, font_bold, "center");
  engraved_text("1:30 180g  +60g", 7, 17.5, 2.2);
  engraved_text("2:15 240g", 7, 14.1, 2.2);
  engraved_text("3:00 300g", 7, 10.7, 2.2);

  engraved_text("stronger", 73.5, 21.2, 2.15, font_bold, "center");
  engraved_text("1:30 210g  +90g", 54, 17.5, 2.2);
  engraved_text("2:35 300g", 54, 14.1, 2.2);
  engraved_text("drink 3:45", 54, 10.7, 2.2, font_bold);
}

difference() {
  rounded_plate(plate_width, plate_height, corner_radius, plate_thickness);

  frame();
  recipe_text();
}

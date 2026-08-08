design_width = 100;
design_height = 70;

plate_width = 160;
plate_height = 112;
plate_thickness = 4;
corner_radius = 4.8;

scale_factor = plate_width / design_width;
engrave_depth = 0.75;
line_width = 0.35;
margin = 4;

font_name = "Liberation Sans";
font_bold = "Liberation Sans:style=Bold";

$fn = 48;

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
  translate([x * scale_factor, y * scale_factor, plate_thickness - engrave_depth])
    linear_extrude(engrave_depth + 0.08)
      text(txt, size=size * scale_factor, font=font, halign=halign, valign="center");
}

module engraved_line(x, y, width, height) {
  translate([x * scale_factor, y * scale_factor, plate_thickness - engrave_depth])
    cube([width * scale_factor, height * scale_factor, engrave_depth + 0.08]);
}

module frame() {
  engraved_line(margin, 60.2, design_width - 2 * margin, line_width);
  engraved_line(margin, 52.8, design_width - 2 * margin, line_width);
  engraved_line(margin, 44.0, design_width - 2 * margin, line_width);
  engraved_line(margin, 22.0, design_width - 2 * margin, line_width);
  engraved_line(margin, 7.2, design_width - 2 * margin, line_width);
  engraved_line(50, 22.0, line_width, 22.0);
  engraved_line(50, 7.2, line_width, 14.8);
}

module recipe_text() {
  engraved_text("POUR-OVER RECIPE", design_width / 2, 66.0, 3.7, font_bold, "center");
  engraved_text("DOSE 1  /  C:W 1:15  /  COFFEE 20g  /  WATER 300g", design_width / 2, 62.0, 2.05, font_bold, "center");

  engraved_text("WATER TEMP 88-95 C", 7, 57.3, 2.05, font_bold);
  engraved_text("GRIND SIZE 2.7 - 3.3", 55, 57.3, 2.05, font_bold);
  engraved_text("SWEET <<   >> ACID    BITTER << SWEET >> SOUR", design_width / 2, 54.0, 1.8, font_bold, "center");
  engraved_text("ACID: coarser - medium - finer", design_width / 2, 50.0, 1.8, font_bold, "center");

  engraved_text("BREW - 40% FLAVOR", design_width / 2, 46.4, 2.35, font_bold, "center");
  engraved_text("SWEET", 26.5, 41.7, 2.05, font_bold, "center");
  engraved_text("0:00    50g   +50g", 7, 38.2, 1.95);
  engraved_text("0:45   120g   +70g", 7, 34.8, 1.95);

  engraved_text("ACID", 73.5, 41.7, 2.05, font_bold, "center");
  engraved_text("0:00    70g   +70g", 54, 38.2, 1.95);
  engraved_text("0:45   120g   +50g", 54, 34.8, 1.95);
  engraved_text("ACIDS / FRUITS", 73.5, 30.9, 1.75, font_bold, "center");
  engraved_text("SUGARS / BODY", 73.5, 27.6, 1.75, font_bold, "center");

  engraved_text("60% STRENGTH", design_width / 2, 24.3, 2.35, font_bold, "center");
  engraved_text("LIGHTER", 26.5, 19.9, 1.95, font_bold, "center");
  engraved_text("1:30   180g   +60g", 7, 16.6, 1.9);
  engraved_text("2:15   240g", 7, 13.4, 1.9);
  engraved_text("3:00   300g", 7, 10.2, 1.9);

  engraved_text("STRONGER", 73.5, 19.9, 1.95, font_bold, "center");
  engraved_text("1:30   210g   +90g", 54, 16.6, 1.9);
  engraved_text("2:35   300g", 54, 13.4, 1.9);
  engraved_text("BITTERS / FIBERS", 73.5, 10.2, 1.7, font_bold, "center");
  engraved_text("DRINK 3:45", design_width / 2, 4.4, 2.1, font_bold, "center");
}

difference() {
  rounded_plate(plate_width, plate_height, corner_radius, plate_thickness);

  frame();
  recipe_text();
}

plate_width = 220;
plate_height = 140;
plate_thickness = 2;
corner_radius = 5;

engrave_depth = 0.75;
border_width = 0.45;
margin = 4;

rows = 18;
table_width = plate_width - 2 * margin;
table_height = plate_height - 2 * margin;
row_height = table_height / rows;

// Column proportions exported from the spreadsheet XLSX.
col_edges = [0, 6.13, 16.26, 19.14, 27.39, 34.27, 46.15, 56.65, 67.15, 74.03, 82.16, 91.41, 99.16, 106.91];
col_unit = table_width / col_edges[len(col_edges) - 1];

font_name = "Liberation Sans";
font_bold = "Liberation Sans:style=Bold";

$fn = 48;

function col_left(col) = margin + col_edges[col - 1] * col_unit;
function col_right(col) = margin + col_edges[col] * col_unit;
function row_top(row) = plate_height - margin - (row - 1) * row_height;
function row_bottom(row) = plate_height - margin - row * row_height;
function span_center_x(c1, c2) = (col_left(c1) + col_right(c2)) / 2;
function span_center_y(r1, r2) = (row_top(r1) + row_bottom(r2)) / 2;

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

module engraved_text(txt, x, y, size, font=font_name, halign="center") {
  translate([x, y, plate_thickness - engrave_depth])
    linear_extrude(engrave_depth + 0.08)
      text(txt, size=size, font=font, halign=halign, valign="center");
}

module engraved_line(x, y, width, height) {
  translate([x, y, plate_thickness - engrave_depth])
    cube([width, height, engrave_depth + 0.08]);
}

module merged_border(c1, r1, c2, r2) {
  x1 = col_left(c1);
  x2 = col_right(c2);
  y1 = row_bottom(r2);
  y2 = row_top(r1);

  engraved_line(x1, y1, x2 - x1, border_width);
  engraved_line(x1, y2 - border_width, x2 - x1, border_width);
  engraved_line(x1, y1, border_width, y2 - y1);
  engraved_line(x2 - border_width, y1, border_width, y2 - y1);
}

module span_text(lines, c1, r1, c2, r2, size=2.4, font=font_name) {
  line_spacing = size * 1.12;
  count = len(lines);

  for (i = [0 : count - 1])
    engraved_text(
      lines[i],
      span_center_x(c1, c2),
      span_center_y(r1, r2) + (count - 1) * line_spacing / 2 - i * line_spacing,
      size,
      font
    );
}

module visual_borders() {
  // Top setup block.
  merged_border(1, 1, 1, 4);
  merged_border(2, 1, 3, 3);
  merged_border(2, 4, 2, 4);
  merged_border(3, 4, 3, 4);
  merged_border(4, 1, 4, 3);
  merged_border(4, 4, 4, 4);
  merged_border(5, 1, 5, 3);
  merged_border(5, 4, 5, 4);
  merged_border(6, 1, 7, 1);
  merged_border(6, 3, 6, 4);
  merged_border(7, 3, 7, 4);
  merged_border(8, 1, 12, 1);
  merged_border(8, 2, 13, 2);
  merged_border(8, 3, 8, 4);
  merged_border(9, 3, 12, 3);
  merged_border(13, 3, 13, 4);

  // Brew block.
  merged_border(1, 5, 1, 16);
  merged_border(2, 5, 3, 9);
  merged_border(2, 10, 3, 16);
  merged_border(4, 5, 6, 5);
  merged_border(7, 5, 9, 5);
  merged_border(10, 5, 10, 8);
  merged_border(10, 9, 10, 11);
  merged_border(10, 12, 10, 14);
  merged_border(11, 5, 11, 9);
  merged_border(12, 5, 12, 13);
  merged_border(13, 5, 13, 15);

  merged_border(4, 6, 4, 7);
  merged_border(5, 6, 5, 7);
  merged_border(6, 6, 6, 7);
  merged_border(7, 6, 7, 7);
  merged_border(8, 6, 8, 7);
  merged_border(9, 6, 9, 7);
  merged_border(4, 8, 4, 9);
  merged_border(5, 8, 5, 9);
  merged_border(6, 8, 6, 9);
  merged_border(7, 8, 7, 9);
  merged_border(8, 8, 8, 9);
  merged_border(9, 8, 9, 9);

  merged_border(4, 10, 6, 10);
  merged_border(7, 10, 9, 10);
  merged_border(4, 11, 4, 12);
  merged_border(5, 11, 5, 12);
  merged_border(6, 11, 6, 16);
  merged_border(7, 11, 7, 13);
  merged_border(8, 11, 8, 13);
  merged_border(9, 11, 9, 16);
  merged_border(4, 13, 4, 14);
  merged_border(5, 13, 5, 14);
  merged_border(7, 14, 7, 16);
  merged_border(8, 14, 8, 16);
  merged_border(4, 15, 4, 16);
  merged_border(5, 15, 5, 16);

  // Drink row block.
  merged_border(1, 17, 1, 18);
  merged_border(2, 17, 3, 18);
  merged_border(4, 17, 4, 18);
  merged_border(5, 17, 5, 18);
  merged_border(6, 17, 6, 18);
  merged_border(7, 17, 7, 18);
  merged_border(8, 17, 8, 18);
  merged_border(9, 17, 9, 18);
  merged_border(10, 18, 13, 18);
}

module table_text() {
  span_text(["DOSE"], 1, 1, 1, 4, 3.0, font_bold);
  span_text(["C/W", "RATIO"], 2, 1, 3, 3, 2.9, font_bold);
  span_text(["COFEE"], 4, 1, 4, 3, 2.7, font_bold);
  span_text(["WATER"], 5, 1, 5, 3, 2.7, font_bold);
  span_text(["WATER TEMP"], 6, 1, 7, 1, 2.45, font_bold);
  span_text(["GRIND SIZE"], 8, 1, 12, 1, 2.55, font_bold);
  span_text(["ACID"], 8, 2, 13, 2, 2.7, font_bold);
  span_text(["SWEET <<"], 6, 3, 6, 3, 2.2, font_bold);
  span_text([">> ACID"], 7, 3, 7, 3, 2.15, font_bold);
  span_text(["BITTER<<"], 8, 3, 8, 3, 2.15, font_bold);
  span_text(["SWEET"], 9, 3, 12, 3, 2.35, font_bold);
  span_text([">>SOUR"], 13, 3, 13, 3, 2.1, font_bold);

  span_text(["1"], 2, 4, 2, 4, 2.7);
  span_text(["15"], 3, 4, 3, 4, 2.7);
  span_text(["20"], 4, 4, 4, 4, 2.7);
  span_text(["300"], 5, 4, 5, 4, 2.7);
  span_text(["88"], 6, 4, 6, 4, 2.7);
  span_text(["95"], 7, 4, 7, 4, 2.7);
  span_text(["2.7"], 8, 4, 8, 4, 2.55);
  span_text(["3.3"], 13, 4, 13, 4, 2.55);

  span_text(["BREW"], 1, 5, 1, 16, 3.0, font_bold);
  span_text(["40%", "FLAVOR"], 2, 5, 3, 9, 2.7, font_bold);
  span_text(["SWEET"], 4, 5, 6, 5, 2.6, font_bold);
  span_text(["ACID"], 7, 5, 9, 5, 2.6, font_bold);
  span_text(["ACIDS", "(FRUITS)"], 10, 5, 10, 8, 2.35, font_bold);
  span_text(["COARSER"], 11, 5, 11, 9, 2.1, font_bold);
  span_text(["MEDIUM"], 12, 5, 12, 13, 2.15, font_bold);
  span_text(["FINER"], 13, 5, 13, 15, 2.2, font_bold);

  span_text(["0:00"], 4, 6, 4, 7, 2.45);
  span_text(["50"], 5, 6, 5, 7, 2.55);
  span_text(["50"], 6, 6, 6, 7, 2.55);
  span_text(["0:00"], 7, 6, 7, 7, 2.45);
  span_text(["70"], 8, 6, 8, 7, 2.55);
  span_text(["70"], 9, 6, 9, 7, 2.55);
  span_text(["0:45"], 4, 8, 4, 9, 2.45);
  span_text(["120"], 5, 8, 5, 9, 2.45);
  span_text(["70"], 6, 8, 6, 9, 2.55);
  span_text(["0:45"], 7, 8, 7, 9, 2.45);
  span_text(["120"], 8, 8, 8, 9, 2.45);
  span_text(["50"], 9, 8, 9, 9, 2.55);

  span_text(["SUGARS", "(BODY)"], 10, 9, 10, 11, 2.35, font_bold);
  span_text(["60%", "STRENGTH"], 2, 10, 3, 16, 2.5, font_bold);
  span_text(["LIGHTER"], 4, 10, 6, 10, 2.45, font_bold);
  span_text(["STRONGER"], 7, 10, 9, 10, 2.45, font_bold);
  span_text(["1:30"], 4, 11, 4, 12, 2.45);
  span_text(["180"], 5, 11, 5, 12, 2.45);
  span_text(["60"], 6, 11, 6, 16, 2.55);
  span_text(["1:30"], 7, 11, 7, 13, 2.45);
  span_text(["210"], 8, 11, 8, 13, 2.45);
  span_text(["90"], 9, 11, 9, 16, 2.55);
  span_text(["BITTERS", "(FIBERS)"], 10, 12, 10, 14, 2.25, font_bold);
  span_text(["2:15"], 4, 13, 4, 14, 2.45);
  span_text(["240"], 5, 13, 5, 14, 2.45);
  span_text(["2:35"], 7, 14, 7, 16, 2.45);
  span_text(["300"], 8, 14, 8, 16, 2.45);
  span_text(["3:00"], 4, 15, 4, 16, 2.45);
  span_text(["300"], 5, 15, 5, 16, 2.45);

  span_text(["DRINK"], 1, 17, 1, 18, 2.7, font_bold);
  span_text(["3:45"], 4, 17, 4, 18, 2.55);
  span_text(["3:45"], 7, 17, 7, 18, 2.55);
}

difference() {
  rounded_plate(plate_width, plate_height, corner_radius, plate_thickness);

  visual_borders();
  table_text();
}

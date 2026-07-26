top_width = 65;
bottom_width = 12;
side_length = 112;
thickness = 12;

offset = (top_width - bottom_width) / 2;
vertical_height = sqrt(side_length * side_length - offset * offset);

linear_extrude(thickness)
polygon(points=[
  [offset, 0],
  [offset + bottom_width, 0],
  [top_width, vertical_height],
  [0, vertical_height]
]);

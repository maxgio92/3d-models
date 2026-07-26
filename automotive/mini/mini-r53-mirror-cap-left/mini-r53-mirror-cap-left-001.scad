// MINI R50/R53 left (driver-side, LHD) mirror cap
// OEM ref 51167123293 — VISUAL APPROXIMATION ONLY (no measured data available).
// Shape and dimensions are best-guess proportions; fully parametric for later tuning.
//
// Coordinate system:
//   X = length, 0 at front nose -> L at blunt rear (toward door)
//   Y = width, centred on 0
//   Z = height, 0 at open underside -> up to the domed top

$fn = 64;

wall    = 2.5;   // shell wall thickness (mm)
smooth  = 0.6;   // x-thickness of each section "lens": smaller = crisper loft

// Outer surface cross-section stations: [x_length, half_width_y, height_z]
outer = [
  [  0,  5, 12],   // rounded nose
  [ 20, 20, 30],
  [ 45, 34, 44],
  [ 72, 43, 50],
  [ 94, 45, 52],   // widest + tallest (rear third)
  [114, 42, 49],
  [130, 33, 43]    // blunt rounded rear
];

function inner_station(s) = [ s[0], max(s[1] - wall, 0.5), max(s[2] - wall, 0.5) ];

// One cross-section: a thin scaled ellipsoid placed along X.
module section(s) {
  translate([s[0], 0, 0])
    scale([smooth, s[1], s[2]])
      sphere(r = 1);
}

// Loft a list of stations by hulling consecutive section pairs.
module loft(stations) {
  for (i = [0 : len(stations) - 2])
    hull() {
      section(stations[i]);
      section(stations[i + 1]);
    }
}

module cap() {
  difference() {
    // Outer solid, top half only -> open underside.
    intersection() {
      loft(outer);
      translate([-50, -150, 0]) cube([260, 300, 300]);  // keep z >= 0
    }
    // Inner cavity: full (un-clipped) ellipsoids dip below z=0 so the
    // underside is cut open, leaving a constant-thickness shell + flat rim.
    loft([ for (s = outer) inner_station(s) ]);
  }
}

cap();

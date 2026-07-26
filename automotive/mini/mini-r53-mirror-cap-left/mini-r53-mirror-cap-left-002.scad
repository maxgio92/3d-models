// MINI R50/R53 left (driver-side, LHD) mirror cap
// OEM ref 51167123293 — VISUAL APPROXIMATION ONLY (no measured data available).
// v2: Catmull-Rom smoothing through the control sections for an organic loft,
//     plus a gently rolled-off rear instead of a vertical cliff.
//
// Coordinate system:
//   X = length, 0 at front nose -> L at rear (toward door)
//   Y = width, centred on 0
//   Z = height, 0 at open underside -> domed top

$fn = 48;

wall    = 2.5;   // shell wall thickness (mm)
smooth  = 0.5;   // x half-thickness of each section "lens"
SEG     = 9;     // samples per control segment (loft density)

// Control cross-sections: [x_length, half_width_y, height_z]
ctrl = [
  [  0,  5, 12],   // rounded nose
  [ 20, 20, 30],
  [ 45, 34, 44],
  [ 72, 43, 50],
  [ 94, 45, 52],   // widest + tallest (rear third)
  [114, 42, 49],
  [126, 34, 44],
  [130, 22, 33]    // rolled-off rear edge
];

// --- Catmull-Rom interpolation over the control list ---
function clampi(i, n) = max(0, min(n - 1, i));

function cr(p0, p1, p2, p3, u) =
  0.5 * ( (2*p1)
        + (-p0 + p2) * u
        + (2*p0 - 5*p1 + 4*p2 - p3) * u*u
        + (-p0 + 3*p1 - 3*p2 + p3) * u*u*u );

// component c (0=x, 1=hw, 2=h) of segment i sampled at u in [0,1)
function seg(i, u, c, n) =
  cr( ctrl[clampi(i-1, n)][c],
      ctrl[clampi(i,   n)][c],
      ctrl[clampi(i+1, n)][c],
      ctrl[clampi(i+2, n)][c], u );

N = len(ctrl);

// Densely sampled, smoothed outer stations (plus the exact final point).
outer = concat(
  [ for (i = [0 : N - 2], j = [0 : SEG - 1])
      let (u = j / SEG)
      [ seg(i, u, 0, N), seg(i, u, 1, N), seg(i, u, 2, N) ] ],
  [ ctrl[N - 1] ]
);

function inner_station(s) = [ s[0], max(s[1] - wall, 0.5), max(s[2] - wall, 0.5) ];

module section(s) {
  translate([s[0], 0, 0])
    scale([smooth, s[1], s[2]])
      sphere(r = 1);
}

module loft(stations) {
  for (i = [0 : len(stations) - 2])
    hull() {
      section(stations[i]);
      section(stations[i + 1]);
    }
}

module cap() {
  difference() {
    intersection() {
      loft(outer);
      translate([-50, -150, 0]) cube([260, 300, 300]);  // keep z >= 0
    }
    loft([ for (s = outer) inner_station(s) ]);
  }
}

cap();

// MINI R50/R53 left (driver-side, LHD) mirror cap
// OEM ref 51167123293 — VISUAL APPROXIMATION ONLY (no measured data available).
// v4: manifold + fast. The outer form is convex (height/width profiles are
//     single humps over a convex plan), so each solid is built as the convex
//     HULL of a sampled point cloud. The shell is one clean difference of two
//     convex solids -> CGAL renders it in seconds and it is watertight.
//
// Coordinate system:
//   X = length, 0 at front nose -> L at rear (toward door)
//   Y = width, centred on 0
//   Z = height, 0 at open underside -> domed top

wall = 2.5;   // shell wall thickness (mm)
SEG  = 4;     // samples per control segment (length density)
K    = 22;    // samples around each cross-section arc (surface smoothness)

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

function seg(i, u, c, n) =
  cr( ctrl[clampi(i-1, n)][c],
      ctrl[clampi(i,   n)][c],
      ctrl[clampi(i+1, n)][c],
      ctrl[clampi(i+2, n)][c], u );

N = len(ctrl);

// Densely sampled stations: [x, half_width, height]
stations = concat(
  [ for (i = [0 : N - 2], j = [0 : SEG - 1])
      let (u = j / SEG)
      [ seg(i, u, 0, N), seg(i, u, 1, N), seg(i, u, 2, N) ] ],
  [ ctrl[N - 1] ]
);

// Convex solid: half-ellipsoidal dome (top half, flat on z=0), inset by `off`.
module dome_solid(off) {
  hull()
    for (s = stations) {
      x  = s[0];
      hw = s[1] - off;
      h  = s[2] - off;
      if (hw > 0.3 && h > 0.3)
        for (k = [0 : K]) {
          t = 180 * k / K;                 // 0..180 deg, rim -> top -> rim
          translate([x, hw * cos(t), h * sin(t)])
            sphere(r = 0.01, $fn = 4);     // point marker for the hull
        }
    }
}

module cap() {
  difference() {
    dome_solid(0);       // outer skin
    dome_solid(wall);    // inner cavity (strictly inside -> open underside + rim)
  }
}

cap();

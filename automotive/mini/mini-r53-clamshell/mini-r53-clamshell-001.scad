// MINI R50/R53 mirror-cap CLAMSHELL — two-part snap-fit assembly.
// OEM ref 51167123293 (left cap shape) — VISUAL APPROXIMATION ONLY.
//
//   cap  = the domed shell (top, z>=0) from v4, with clip WINDOWS cut in the wall
//   mate = mirror image across the open face (bottom, z<=0), carrying cantilever
//          snap FINGERS that rise into the cap and lock into the windows
//
// Set `part` to render/export:  "cap" | "mate" | "assembly" | "section"
//
// Coordinates: X = length (nose@0 -> rear), Y = width (centred), Z = height.

part = "assembly";

// ---- shell ----
wall = 2.5;
SEG  = 4;     // length samples per control segment
K    = 18;    // arc samples per cross-section

// ---- clips ----
clip_idxs = [10, 19];   // station indices that get a clip (both +Y and -Y sides)
cw        = 9.0;        // clip width along X
ft        = 1.8;        // finger (cantilever) thickness
clr       = 0.4;        // FDM clearance between finger and cap wall
win_z0    = 4.0;        // window lower edge (Z) = retention ledge
win_h     = 4.5;        // window height (Z)
barb_out  = 1.8;        // barb protrusion past the inner wall face
barb_h    = 3.0;        // barb flat retention height (Z)
fin_top   = 9.5;        // finger tip height (Z)
foot_h    = 3.0;        // anchor foot height bonding finger to rim

// Control cross-sections: [x_length, half_width_y, height_z]
ctrl = [
  [  0,  5, 12],
  [ 20, 20, 30],
  [ 45, 34, 44],
  [ 72, 43, 50],
  [ 94, 45, 52],
  [114, 42, 49],
  [126, 34, 44],
  [130, 22, 33]
];

function clampi(i, n) = max(0, min(n - 1, i));
function cr(p0, p1, p2, p3, u) =
  0.5 * ( (2*p1) + (-p0 + p2)*u + (2*p0 - 5*p1 + 4*p2 - p3)*u*u
        + (-p0 + 3*p1 - 3*p2 + p3)*u*u*u );
function seg(i, u, c, n) =
  cr( ctrl[clampi(i-1,n)][c], ctrl[clampi(i,n)][c],
      ctrl[clampi(i+1,n)][c], ctrl[clampi(i+2,n)][c], u );

N = len(ctrl);
stations = concat(
  [ for (i = [0:N-2], j = [0:SEG-1]) let (u = j/SEG)
      [ seg(i,u,0,N), seg(i,u,1,N), seg(i,u,2,N) ] ],
  [ ctrl[N-1] ] );

// Convex dome solid (top half, flat on z=0), inset by `off`.
module dome_solid(off) {
  hull()
    for (s = stations) {
      x = s[0]; hw = s[1]-off; h = s[2]-off;
      if (hw > 0.3 && h > 0.3)
        for (k = [0:K]) {
          t = 180*k/K;
          translate([x, hw*cos(t), h*sin(t)]) sphere(r=0.01, $fn=4);
        }
    }
}

// Hollow shell, z>=0, open underside.
module shell() { difference() { dome_solid(0); dome_solid(wall); } }

// ---- clip features (built for the +Y wall; caller mirrors for -Y) ----

// Window cut through the +Y wall at station s.
module window_pos(s) {
  x = s[0]; hw = s[1];
  translate([x - cw/2, hw - wall - 1, win_z0])
    cube([cw, wall + 2, win_h]);
}

// Cantilever finger + barb + anchor foot for the +Y wall at station s.
module finger_pos(s) {
  x = s[0]; hw = s[1];
  yin = hw - wall;          // cap inner wall face
  yo  = yin - clr;          // finger outer face (sits inside cap wall)
  // cantilever plate
  translate([x - cw/2, yo - ft, 0]) cube([cw, ft, fin_top]);
  // anchor foot bonding the finger to the rim wall
  translate([x - cw/2, yo - ft, 0]) cube([cw, yin - (yo - ft), foot_h]);
  // barb: flat retention at bottom, ramped lead-in on top
  hull() {
    translate([x - cw/2, yo, win_z0]) cube([cw, (yin + barb_out) - yo, barb_h]);
    translate([x - cw/2, yo, fin_top - 0.01]) cube([cw, 0.01, 0.01]);
  }
}

module both_sides(s) { children(0); mirror([0,1,0]) children(0); }

// ---- parts ----

module cap_part() {
  difference() {
    shell();
    for (i = clip_idxs) { window_pos(stations[i]); mirror([0,1,0]) window_pos(stations[i]); }
  }
}

module mate_part() {
  union() {
    mirror([0,0,1]) shell();                       // mirrored bottom half
    for (i = clip_idxs) { finger_pos(stations[i]); mirror([0,1,0]) finger_pos(stations[i]); }
  }
}

module assembly() {
  color("RoyalBlue")  cap_part();
  color("Tomato")     mate_part();
}

if      (part == "cap")      cap_part();
else if (part == "mate")     mate_part();
else if (part == "section")  intersection() { assembly(); translate([-10,-100,-100]) cube([200,100,200]); }
else                         assembly();

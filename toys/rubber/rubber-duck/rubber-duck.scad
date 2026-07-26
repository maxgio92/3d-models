// Stylized rubber duck bath toy for OpenSCAD.
// Units are millimeters. Export to STL with OpenSCAD.

$fn = 56;

duck_scale = 1;

module ellipsoid(size = [10, 10, 10]) {
    scale([
        size[0] / 2,
        size[1] / 2,
        size[2] / 2
    ])
        sphere(r = 1);
}

module hull_ellipsoids(nodes) {
    hull() {
        for (n = nodes) {
            translate([n[0], n[1], n[2]])
                ellipsoid([n[3], n[4], n[5]]);
        }
    }
}

module duck_body() {
    color([1.0, 0.78, 0.06])
    union() {
        hull_ellipsoids([
            [-50, 0, 23, 42, 56, 30],
            [-17, 0, 29, 72, 66, 45],
            [25, 0, 28, 64, 62, 42],
            [49, 0, 22, 38, 48, 28]
        ]);

        translate([-7, 0, 15])
            ellipsoid([116, 64, 30]);

        translate([23, 0, 39])
            ellipsoid([48, 50, 34]);
    }
}

module duck_neck() {
    color([1.0, 0.78, 0.06])
    union() {
        translate([25, 0, 45])
            ellipsoid([40, 44, 28]);

        translate([32, 0, 55])
            ellipsoid([38, 40, 30]);
    }
}

module duck_head() {
    color([1.0, 0.78, 0.06])
    union() {
        translate([35, 0, 65])
            ellipsoid([45, 42, 42]);

        translate([30, 0, 59])
            ellipsoid([37, 39, 27]);
    }
}

module duck_bill() {
    color([1.0, 0.42, 0.04])
    union() {
        hull_ellipsoids([
            [47, 0, 62, 17, 28, 11],
            [59, 0, 60, 26, 23, 9],
            [68, 0, 59, 15, 17, 7]
        ]);

        hull_ellipsoids([
            [47, 0, 56, 14, 23, 7],
            [58, 0, 55, 22, 18, 6]
        ]);
    }
}

module duck_tail() {
    color([1.0, 0.78, 0.06])
    hull_ellipsoids([
        [-52, 0, 34, 20, 32, 16],
        [-62, 0, 40, 12, 22, 10],
        [-66, 0, 43, 7, 14, 7]
    ]);
}

module duck_wing(side = 1) {
    color([0.98, 0.70, 0.04])
    translate([-7, side * 32, 29])
        rotate([0, -2, side * -6])
            hull() {
                translate([-22, 0, 1])
                    ellipsoid([18, 10, 20]);
                translate([0, 0, 0])
                    ellipsoid([42, 11, 25]);
                translate([23, 0, 0])
                    ellipsoid([17, 9, 16]);
            }
}

module duck_eye(side = 1) {
    color([0.02, 0.018, 0.012])
    translate([45, side * 17.5, 70])
        ellipsoid([5.8, 5.0, 5.8]);
}

module beak_groove(side = 1) {
    translate([57, side * 10.2, 57.5])
        rotate([0, -7, 0])
            ellipsoid([20, 3.8, 1.8]);
}

module wing_grooves(side = 1) {
    for (g = [
        [-18, 33],
        [-5, 29],
        [7, 26]
    ]) {
        translate([g[0], side * 36.8, g[1]])
            rotate([0, -24, 0])
                ellipsoid([3.8, 6.5, 18]);
    }
}

module smile_dimple(side = 1) {
    translate([49, side * 12.8, 54.6])
        rotate([0, 0, side * 8])
            ellipsoid([10, 3.4, 2.4]);
}

module flatten_base() {
    translate([0, 0, -36])
        cube([190, 110, 72], center = true);
}

module rubber_duck() {
    scale(duck_scale)
    difference() {
        union() {
            duck_body();
            duck_neck();
            duck_head();
            duck_bill();
            duck_tail();
            duck_wing(1);
            duck_wing(-1);
            duck_eye(1);
            duck_eye(-1);
        }

        beak_groove(1);
        beak_groove(-1);
        smile_dimple(1);
        smile_dimple(-1);
        wing_grooves(1);
        wing_grooves(-1);
        flatten_base();
    }
}

rubber_duck();

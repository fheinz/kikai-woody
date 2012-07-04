module hexagon(size, h, center=false) {
    boxWidth=size/1.75;
    translate ([0, 0, center ? 0 : h/2]) {
        union(){
            cube([boxWidth, size, h], center=true);
            rotate([0,0,60]) cube([boxWidth, size, h], center=true);
            rotate([0,0,-60]) cube([boxWidth, size, h], center=true);
        }
    }
}

module polyhole(d, h, center=false, d1=-1, d2=-1) {
    n = max(round(2 * ((d1<0 || d2<0) ? d : max(d1, d2))),3);
    if (d1<0 || d2<0) {
        cylinder(h = h, r = (d / 2) / cos (180 / n), center=center, $fn = n);
    } else {
        cylinder(h = h, r1 = (d1 / 2) / cos (180 / n), r2 = (d2 / 2) / cos (180 / n), center=center, $fn = n);
    }
}

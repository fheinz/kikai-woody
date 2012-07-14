// ******************************
// *   Parametric thumb wheel   *
// *   by Chris Garrett         *
// *   20-nov-2011              *
// ******************************


// *** Configuration variables ***
wheel_d = 20;    // Outer Diameter of the thumb wheel
wheel_h = 3;     // Height of the thumb wheel
hole_d = 3.25;    // Diameter of center hole
hex_sz = 5.5;      // Size of the hex (nut trap)
                 // An M4 nut fits perfectly in a 7mm hex opening made on my Prusa
hex_d = 2;       // Depth of the hex (set this < or = to wheel_h)
knurl_cnt = 12;  // Number of cutouts around the wheel
knurl_d = 3;     // Diameter of the cutouts


// *** Code area ***

module box(w,h,d) {
 translate([0,0,d/2]) scale ([w,h,d]) cube(1, true);
}

module hexagon(height, depth) {
 boxWidth=height/1.75;
 union() {
  box(boxWidth, height, depth);
  rotate([0,0,60]) box(boxWidth, height, depth);
  rotate([0,0,-60]) box(boxWidth, height, depth);
 }
}


// The thumb wheel 

difference() {
 cylinder(h=wheel_h, r=wheel_d/2, $fn=50);
 translate([0,0,-1]) cylinder(h=wheel_h+2, r=hole_d/2, $fn=50);
 if (hex_d >= wheel_h) {
   translate([0,0,-1]) hexagon(height=hex_sz, depth=wheel_d+2);
 } else {
  translate([0,0,wheel_h-hex_d]) hexagon(height=hex_sz, depth=hex_d+1);
 }
 for(i = [0:knurl_cnt-1]) {
  rotate(v=[0,0,1], a=i*360/knurl_cnt) translate([0,wheel_d/2,-1]) cylinder(h=wheel_h+2, r=knurl_d/2, $fn=50);
 }
}
include <util.scad>;

m3_size = 3;
m3_nut_size = 5.5;
m3_head_size=5.5;
m3_head_height=3;
m3_nut_height = 2.54;
m6_nut_size = 10;
m6_size = 6;
m4_size = 4;
rod_size = 8;
rod_nut_size = 15; //12 for M6, 15 for M8
motor_shaft_size = 5;
bearing_size = 15; //12 for LM6UU, 15 for LM8UU,LM8SUU
bearing_length = 24; //19 for LM6UU, 17 for LM8SUU, 24 for LM8UU
motor_screw_spacing = 31; //26 for NEMA14, 31 for NEMA17
motor_shaft_bevel_diameter = 22;
motor_casing = 45; //38 for NEMA14, 45 for NEMA17
motor_wiggle=5;
x_rod_spacing = 55;
z_rod_spacing = 30 ;
belt_thickness=1.5;
belt_tooth_depth=0.5;
idler_pulley_size = 22; // 22 for 636/608 bearing
idler_pulley_width = 10;
idler_pulley_axis_diameter = m6_size; // m6 for 636 bearing
idler_pulley_nut_size = m6_nut_size; // m6 for 636 bearing
motor_pulley_size = 12;
pulley_radius_difference = (idler_pulley_size-motor_pulley_size)/2+belt_tooth_depth;
clamping_hole_offsets = [motor_casing/2-pulley_radius_difference, (x_rod_spacing + rod_size + 8)-(motor_casing/2-pulley_radius_difference)];

// ratio for converting diameter to apothem
da6 = 1 / cos(180 / 6) / 2;
da8 = 1 / cos(180 / 8) / 2;

module leadscrew_coupler() difference() {
	linear_extrude(height = 10 + rod_nut_size / 2 + 1, convexity = 5) difference() {
		circle(motor_screw_spacing / 2 - 1);
		polyhole(motor_shaft_size * da6, $fn = 6);
	}
	translate([0, 0, (m3_nut_size+0.5) / 2]) rotate([-90, 0, 90]) {
		cylinder(r = m3_size * da6, h = motor_screw_spacing / 2 + 1);
		%rotate(90) cylinder(r = (m3_nut_size+0.5) / 2, h = 5.5, $fn = 6);
		translate([0, 0, 12]) cylinder(r = m3_size * da6 * 2, h = motor_screw_spacing / 2);
		translate([-(m3_nut_size+0.5) / da6 / 4, -(m3_nut_size+0.5) / 2, 0]) cube([(m3_nut_size+0.5) / da6 / 2, (m3_nut_size+0.5) + 1, 5.7]);
	}
	translate([0, 0, 10]) cylinder(r = rod_nut_size / 2, h = rod_nut_size + 1, $fn = 6);
	//translate([0, 0, -1]) cube(100);
}

module x_end(motor = 0) mirror([(motor == 0) ? 1 : 0, 0, 0]) difference() {
	union() {
		if(motor > 0) translate([-(motor_casing / 2 + rod_size + (bearing_size+0.5) + 8) / 2 - (motor_casing+motor_wiggle), (bearing_size+0.5) + rod_size-2/* 8 + rod_size */, 0]) rotate([90, 0, 0]) {
			// Motor holder
			linear_extrude(height = 7) difference() {
				#square([motor_casing + motor_wiggle + 3, motor_casing]);
			        translate([motor_casing / 2, motor_casing / 2, 0]) {
					circle(motor_shaft_bevel_diameter / 2);
                                        translate ([motor_wiggle, 0, 0]) circle(motor_shaft_bevel_diameter / 2);
                                        translate ([motor_wiggle/2, 0, 0]) square([motor_wiggle,motor_shaft_bevel_diameter], center=true);
					for(x = [1, -1]) for(y = [1, -1]) {
                                            translate([x * motor_screw_spacing / 2, y * motor_screw_spacing / 2, 0]) {
                                                circle(m3_size * da6, $fn = 6);
                                                translate ([motor_wiggle, 0, 0]) circle(m3_size * da6, $fn = 6);
                                                translate ([motor_wiggle/2, 0, 0]) square([motor_wiggle, m3_size], center=true);
                                            }
                                        }
					translate([-(motor_casing * 1.5 - motor_screw_spacing), (motor > 1) ? (motor_casing / 2 - motor_screw_spacing) : 0, 0]) square([motor_casing, x_rod_spacing + 8 + rod_size]);
				}
			}
		}
		linear_extrude(height = x_rod_spacing + 8 + rod_size, convexity = 5) difference() {
			union() {
				for(side = [1, -1]) translate([side * z_rod_spacing/2, 0, 0]) circle((bearing_size+0.5) / 2 + 3, $fn = 30);
				square([z_rod_spacing, (bearing_size+0.5) / 2 + 3], center = true);
				translate([-(z_rod_spacing + (bearing_size+0.5) + 6) / 2, 0, 0]) square([(z_rod_spacing + (bearing_size+0.5) / 2 + 3 + 3) / 2, (bearing_size+0.5) / 2 + 4 + rod_size / 2]);
				translate([-(z_rod_spacing + (bearing_size+0.5) + 6) / 2, 0, 0]) square([z_rod_spacing + (bearing_size+0.5) / 2 + 3 + 3, (bearing_size+0.5) / 2 + 3 + rod_size / 2]);
				translate([-(z_rod_spacing + (bearing_size+0.5) + 6) / 2 + rod_size / 2 + 2, 0, 0]) square([(z_rod_spacing + (bearing_size+0.5) + 6) / 2 + 5 - rod_size / 2 - 2, (bearing_size+0.5) / 2 + 6 + rod_size]);
				translate([-(z_rod_spacing + (bearing_size+0.5) + 6) / 2 + rod_size / 2 + 2, (bearing_size+0.5) / 2 + rod_size / 2 + 4, 0]) {
                                    if (motor > 0) {
                                        square(rod_size + 4, center=true);
                                    } else {
                                        circle(rod_size / 2 + 2);
                                    }
                                }
				translate([0, (bearing_size+0.5) / 2 + rod_size + 6, 0]) square([15,10], center = true);
			}
			square([z_rod_spacing, 3], center = true);
			translate([z_rod_spacing/2, 0, 0]) circle((bearing_size+0.5) / 2 - .5, $fn = 30);
			translate([-z_rod_spacing/2, 0, 0]) circle(rod_nut_size * 6/14, $fn = 6);
			translate([4 + rod_size / 2, (bearing_size+0.5) / 2 + rod_size / 2 + 3, 0]) {
				square([z_rod_spacing + (bearing_size+0.5) + 8, rod_size / 2], center = true);
				translate([-(z_rod_spacing + (bearing_size+0.5) + 8) / 2, .5, 0]) circle(rod_size / 4 + .5, $fn = 12);
			}
		}
                if (motor < 1) translate([z_rod_spacing/2, 0, 0]) rotate([0, 0, -142.5]) translate([(bearing_size+0.5)/2+6, 0, 0]) difference() {
                    cylinder(r=4, h=7);
                    #translate([0, 0, -0.1]) cylinder(r=1.5, h=7.2, $fn=8);
                }
	}
	translate([0, 0, (x_rod_spacing + rod_size + 8) / 2]) {
            for(end = [0, 1]) mirror([0, 0, end]) translate([z_rod_spacing / 2 , 0, -(x_rod_spacing + rod_size + 8) / 2 - 1]) cylinder(r = (bearing_size+0.5) / 2 - .05, h = (bearing_length+0.5), $fn = 30);
            for(side = [1, -1]) render(convexity = 5) translate([0, (bearing_size+0.5) / 2 + rod_size / 2 + 3, side * x_rod_spacing / 2]) rotate([0, 90, 0]) {
                    difference() {
                        translate([0, 0, (motor > -1) ? rod_size / 2 + 2 : 0]) intersection() {
                            rotate(45) cube([rod_size + 2, rod_size + 2, z_rod_spacing + (bearing_size+0.5) + 10], center = true);
                            cube([rod_size * 2, rod_size + 2, z_rod_spacing + (bearing_size+0.5) + 10], center = true);
                        }
                        translate([0, rod_size, 0]) cube([rod_size * 2, rod_size * 2, 6], center = true);
                        for(end = [1, -1]) translate([0, -rod_size, end * z_rod_spacing / 2]) cube([rod_size * 2, rod_size * 2, 6], center = true);
                    }
                    translate([0, 0, rod_size / 2 + 2]) intersection() {
                        rotate(45) cube([rod_size, rod_size, z_rod_spacing + (bearing_size+0.5) + 10], center = true);
                        cube([rod_size * 2, rod_size + 1, z_rod_spacing + (bearing_size+0.5) + 10], center = true);
                    }
                }
        }    
        // holes for clamping screws
        for (i = [0, 1]) {
            translate([0, 0, clamping_hole_offsets[i]]) {
                #rotate([90, 0, 0]) {
                    if (i == 1 || motor > 0) {
                        polyhole(d = m3_size+0.5, h = 100, center = true);
                        translate([0, 0, -((bearing_size+0.5) / 2 + rod_size + 11.5)]) polyhole(d=m3_head_size+0.5, h=m3_head_height+0.5);
                        translate([0, 0, (bearing_size+0.5) / 4 + .5]) hexagon(size=m3_nut_size+0.5, h = 2.5);
                    } else {
                        polyhole(d = idler_pulley_axis_diameter+0.5, h = 100, center = true);
                        translate([0, 0, (bearing_size+0.5) / 4 - 0.5]) hexagon(size = idler_pulley_nut_size, h = 5);
                    }
                }
            }
        }
        translate([-z_rod_spacing / 2, 0, 5]) rotate(90) cylinder(r = rod_nut_size / 2, h = x_rod_spacing + 8 + rod_size, $fn = 6);
	translate([z_rod_spacing / 2, 0, 5]) %rotate(180 / 8) cylinder(r = rod_size * da8, h = 200, center = true, $fn = 8);
}


module lm8uu_retainer(thickness=6) {
    outer_size=bearing_size+2*thickness;
    length=3*bearing_length/4;
    screw_offset=(bearing_size+thickness)/2;
    base_offset=bearing_size/2-2;
    difference() {
        union() {
            cylinder(r=outer_size/2-thickness/2, h=length);
            translate([0, -outer_size/2, 0]) cube([bearing_size/2, outer_size, length]);
        }
        translate([0, 0, -1]) {
            #polyhole(d=bearing_size+0.25, h=length+2);
            translate([0, -bearing_size/2, 0]) cube([bearing_size/2, bearing_size, length+2]);
            translate([base_offset, -(outer_size/2+1), 0]) cube([outer_size, outer_size+2, length+2]);
        }
        for (i = [-1,1]) {
            #translate([base_offset, i*screw_offset, length/2]) rotate([0, 90, 0]) polyhole(d=m3_size+0.25, h=40, center=true);
            #translate([0, i*screw_offset, length/2]) cube([m3_nut_height+0.25, thickness+0.2, m3_nut_size+0.25], center=true);
        }
    }
}

module 608_adapter() {
    difference() {
        union() {
            cylinder(r=8, h=0.5);
            cylinder(r=4.20, h=9);
        }
        translate([0, 0, -1]) polyhole(d=6.75, h=11);
    }
    translate([0, 25, 0]) difference() {
        union() {
            cylinder(r=12.5, h=1.5);
            cylinder(r=8, h=2);
            
        }
        translate([0, 0, -1]) polyhole(d=8.5, h=4);
    }
}
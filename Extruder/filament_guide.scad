nema17_side = 42;
nema17_bolt_distance = 31;
m3_hole = 3.3;
m3_nut_hole = 5.5;
block_beam_height = 5;
block_anchor_height = 10;
block_height = block_beam_height+block_anchor_height;
block_thickness = 15;
block_roundness = 1.5;
block_base_thickness = 4;
filament_x_offset = 6;
filament_z_offset = 10;
filament_guide_length = 4;
filament_hole = 2;
hinge_inner_diameter = 6;
hinge_outer_diameter = 9;
lever_thickness = 9;
lever_trench_start = 10;
tension_bolt_x_offset = 10;
tension_bolt_z_offset = block_base_thickness+lever_thickness/2;
tension_bolt_diameter = m3_hole;
tension_bolt_guide_length = 5;
plunger_bearing_size = 10; // 623 bearing: 10
plunger_bearing_height = 4; // 623 bearing: 4

module rprism(size=[10,10,10], r=1, center=false) {
    t = center ? [0, 0, 0] : [r, r, 0];
    minkowski() {
        translate(t) cube([size[0]-2*r, size[1]-2*r, size[2]-0.001] , center=center);
        cylinder(r=r, h=0.001);
    }
}

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
        echo("one:", d);
        cylinder(h = h, r = (d / 2) / cos (180 / n), center=center, $fn = n);
    } else {
        echo("two:", d1, d2);
        cylinder(h = h, r1 = (d1 / 2) / cos (180 / n), r2 = (d2 / 2) / cos (180 / n), center=center, $fn = n);
    }
}


module block() {
    $fn=8;
    union () {
        difference () {
            translate([-nema17_side/2, -block_anchor_height, 0]) rprism([nema17_side, block_height, block_thickness], r=block_roundness, center=false);
            // Motor shaft bevel
            #translate([0, -nema17_side/2, -0.01]) cylinder(r=11.5, h=2.5, $fn=60);
            // filament guide
            #translate([filament_x_offset+filament_hole/2-filament_guide_length/2, (block_anchor_height-block_height)/2, filament_z_offset]) rotate([90, 0, 0]) rprism([filament_guide_length, filament_hole+0.25, block_height+0.02], r=filament_hole/2, center=true);
            // tension bolt guide
            #translate([(tension_bolt_guide_length+tension_bolt_diameter)/2-(tension_bolt_x_offset), (block_anchor_height-block_height)/2, tension_bolt_z_offset]) rotate([90, 0, 0]) rprism([tension_bolt_guide_length, tension_bolt_diameter+0.25, block_height+0.02], r=tension_bolt_diameter/2, center=true);
            // mounting bolt holes
            for (i = [-1, 1]) {
                translate([i*nema17_bolt_distance/2, -block_anchor_height/2, 0]) {
                    // translate([0, 0, block_thickness/2]) cylinder(r=(m3_hole+0.25)/2, h=block_thickness+0.02, center=true);
                    // translate([0, 0, block_thickness-0.6*m3_hole]) cylinder(r1=(m3_hole+0.25)/2, r2=m3_hole+0.25, h=0.6*m3_hole+0.01);
                    translate([0, 0, block_thickness/2]) polyhole(d=m3_hole+0.25, h=block_thickness+0.02, center=true);
                    translate([0, 0, block_thickness-0.6*m3_hole]) polyhole(d1=m3_hole+0.25, d2=2*m3_hole+0.25, h=0.6*m3_hole+0.01);
                }
            }
            // lever
            difference() {
                union() {
                    translate([lever_trench_start-nema17_side/2, -(block_anchor_height+0.01), block_base_thickness-0.25]) {
                        cube([nema17_side, block_anchor_height+0.01, block_thickness]);
                    }
                    translate([nema17_bolt_distance/2, -block_anchor_height/2, block_base_thickness-0.25]) {
                        cylinder(r=hinge_outer_diameter/2+1.5, h=lever_thickness+0.5, $fn=20);
                    }
                }
                translate([nema17_bolt_distance/2, -block_anchor_height/2, block_base_thickness-0.25]) {
                    translate([0, 0, lever_thickness/2]) cylinder(r=(hinge_inner_diameter-0.50)/2, h=block_thickness, center=true);
                    translate([hinge_inner_diameter/2, -hinge_inner_diameter/2, lever_thickness+0.5]) {
                        rotate([0, 0, 90]) {
                            rprism([block_height, nema17_side, block_thickness], r=(hinge_inner_diameter-0.5)/2);
                        }
                    }
                }
            }
        }
        // support
        translate([lever_trench_start-nema17_side/2, -(block_anchor_height+hinge_inner_diameter)/2, block_base_thickness-0.2]) {
            cube([nema17_side/2+nema17_bolt_distance/2-lever_trench_start, 0.3, lever_thickness+0.4]);
        }
    }
}

module plunger() {
    lever_length=nema17_side-(lever_trench_start+(nema17_side-nema17_bolt_distance)/2);
    lever_height=block_anchor_height-1;
    bearing_lever_width=hinge_outer_diameter+1;
    bearing_lever_length=(nema17_bolt_distance+2*plunger_bearing_size/3)/2;
    bearing_lever_offset=-3;
    bearing_lever_thickness=11;
    bearing_axis_x_offset=filament_x_offset+plunger_bearing_size/2-nema17_bolt_distance/2;
    bearing_z_offset=filament_z_offset-block_base_thickness;
    joint_radius=5;
    union() {
        difference() {
            union() {
                cylinder(r=hinge_outer_diameter/2, h=lever_thickness, $fn=30);
                translate([-lever_length, -block_anchor_height/2, 0]) cube([lever_length, lever_height, lever_thickness]);
                translate([-bearing_lever_width/2+bearing_lever_offset, -bearing_lever_length, 0]) rprism([bearing_lever_width, bearing_lever_length-hinge_inner_diameter/2, lever_thickness], $fn=20);
                intersection() {
                    translate([-bearing_lever_width/2+bearing_lever_offset, -bearing_lever_length, lever_thickness-0.002]) rprism([bearing_lever_width, plunger_bearing_size*1.3, bearing_lever_thickness+0.003-lever_thickness], $fn=20);
                    translate([bearing_axis_x_offset, -nema17_bolt_distance/2, lever_thickness-0.001])
                        cylinder(r1=plunger_bearing_size*0.9, r2=plunger_bearing_size*0.9-2, h=bearing_lever_thickness+0.001-lever_thickness, $fn=20); 
                }
                translate([bearing_axis_x_offset, -nema17_bolt_distance/2, 0]) {
                    cylinder(r=plunger_bearing_size/3+1, lever_thickness, $fn=20); 
                    translate([0, 0, lever_thickness]) {
                        difference() {
                            sphere(r=plunger_bearing_size/3+1,$fn=20);
                            translate([0, 0, bearing_lever_thickness-lever_thickness+plunger_bearing_size/2]) cube(plunger_bearing_size, center=true);
                        }
                    } 
                }
                // joint bezel
                translate([-bearing_lever_width/2+bearing_lever_offset, -block_anchor_height/2, 0]) {
                    difference() {
                        translate ([-joint_radius, -joint_radius, 0]) cube([joint_radius+0.01, joint_radius+0.01, lever_thickness]);
                        translate([-joint_radius, -joint_radius, -0.01]) cylinder(r=joint_radius, h=lever_thickness+0.02, $fn=20);
                    }
                }
            }
            // hinge cutout
            translate([0, 0, -0.01]) cylinder(r=hinge_inner_diameter/2, h=lever_thickness+0.02);
            translate([0, -hinge_inner_diameter/2, -0.01]) cube([hinge_outer_diameter/2+1, hinge_inner_diameter, lever_thickness+0.02]);
            // lever bezel
            translate([-lever_length-0.01, -block_anchor_height/2, -0.01]) {
                difference() {
                    cube([lever_height+0.01, lever_height+0.01, lever_thickness+0.02]);
                    translate([lever_height+0.01, -0.01, -0.01]) cylinder(r=lever_height+0.01, h=lever_thickness+0.04, $fn=20);
                }
            }
            // filament guide
            #translate([filament_x_offset-nema17_bolt_distance/2, 0, filament_z_offset-block_base_thickness]) rotate([90, 0, 0]) cylinder(r=(filament_hole+0.5)/2, h=4*lever_height, $fn=8, center=true);
            // tension bolt hole
            #translate([-(nema17_bolt_distance/2+tension_bolt_x_offset-tension_bolt_guide_length), 0, tension_bolt_z_offset-block_base_thickness]) rotate([90, 0, 0]) {
                cylinder(r=tension_bolt_diameter/2, h=2*lever_thickness, $fn=8, center=true);
                translate([0, 0, lever_height/2-2]) hexagon(size=m3_nut_hole, h=3);
            }
            // bearing cradle
            translate([bearing_axis_x_offset, -nema17_bolt_distance/2, bearing_z_offset]) {
                cylinder(r=(plunger_bearing_size)/2, h=plunger_bearing_height+0.2, center=true); 
                difference() {
                    cylinder(r=(plunger_bearing_size+1.5)/2, h=plunger_bearing_height+1.5, center=true, $fn=30); 
                    cylinder(r=m3_hole/2+1, h=plunger_bearing_height+1.52, center=true, $fn=20); 
                }
                %cylinder(r=plunger_bearing_size/2, h=plunger_bearing_height, center=true, $fn=30);
            }
            // bearing axis hole
            translate([bearing_axis_x_offset, -nema17_bolt_distance/2, 0]) {
                translate([0, 0, -0.01]) cylinder(r=(m3_hole-0.25)/2, h=bearing_z_offset,$fn=8);
                translate([0, 0, bearing_z_offset]) cylinder(r=(m3_hole+0.25)/2, h=bearing_z_offset,$fn=8);
                translate([0, 0, bearing_lever_thickness-0.6*m3_hole]) cylinder(r1=(m3_hole+0.25)/2, r2=m3_hole+0.25, h=0.6*m3_hole+0.01);
            }
        }
        // support
        translate([bearing_axis_x_offset, -nema17_bolt_distance/2, bearing_z_offset]) {
            difference() {
                cylinder(r=plunger_bearing_size/3+1, h=plunger_bearing_height+1.3, $fn=20, center=true); 
                cylinder(r=plunger_bearing_size/3+0.7, h=plunger_bearing_height+1.5, $fn=20, center=true); 
                translate([plunger_bearing_size*0.55, 0, 0]) cube([plunger_bearing_size*1.1, plunger_bearing_size*1.1, plunger_bearing_size+1.5], center=true);
            }
        }
        translate([bearing_axis_x_offset, -nema17_bolt_distance/2, bearing_z_offset]) {
            difference() {
                cylinder(r=(m3_hole+0.25)/2+0.3, h=plunger_bearing_height+0.3, $fn=8, center=true); 
                cylinder(r=(m3_hole+0.25)/2, h=plunger_bearing_height+0.5, $fn=8, center=true); 
                cube([2*m3_hole, 1, plunger_bearing_height+0.5], center=true);
                cube([1, 2*m3_hole, plunger_bearing_height+0.5], center=true);

            }
        }
    }
}

module logo() {
    translate([-7, -4, 0]) linear_extrude(height=1.2, center=true) scale(0.4) import("logokikaiout.dxf", layer="logokikaiout");
}

module filament_guide() {
    translate([0, block_height, 0]) {
        difference() {
            block();
            #translate ([0, block_height/2-block_anchor_height, block_thickness]) logo();
        }
    }

    translate([nema17_bolt_distance/2, 0, 0]) plunger();
}

mirror([1, 0, 0]) filament_guide();
!	filament_guide();

include <Kikai Woody.scad>;

!union() {
    timing_belt_trap_y();
    *translate([7, -15, 0]) timing_belt_trap_x();
    *mirror([1, 0, 0]) translate([7, -15, 0]) timing_belt_trap_x();
} 

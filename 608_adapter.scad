include <Kikai Woody.scad>;

!union() {
	608_adapter(border_bottom_h=9);
	translate([25, 0, 0]) 608_adapter();
}

/*  Symmetric Prusia Z-coupling
    by Philip Hands <phil@hands.com>
    Copyright (C) 2011,
    distributed under the GNU GPL v2 (or later) license.
-   Inspired by:
    Yet Another Prusa Mendel Z Coupling by nophead
	is licensed under the Creative Commons - GNU GPL license.
*/

module coupling(x=30,y=25,z=8,s=8,m=7)
{
	difference()
	{
		intersection()
		{
			cube([x,y,z]);
			translate([x/2,y/2,0])  cylinder(h=z, r=sqrt(pow(x/2,2)+pow(max(s,m)/2+((y-max(s,m))/12),2)),$fn=40);
		}

		// Nut holes
		translate([x/4,y/4,-0.1]) cylinder(h=3, r=3.25, $fn=6);
		translate([x*3/4,y/4,-0.1]) cylinder(h=3, r=3.25, $fn=6);

		// bolt holes
		#translate([x/4,y/4,3.3]) cylinder(h=10, r=1.7, $fn=16);
		translate([x*3/4,y*3/4,-0.1]) cylinder(h=10, r=1.7, $fn=16);
		translate([x/4,y*3/4,-0.1]) cylinder(h=10, r=1.7, $fn=16);
		#translate([x*3/4,y/4,3.3]) cylinder(h=10, r=1.7, $fn=16);

		// dents for shafts
		translate([-1, y/2, z+0.5]) rotate([0,90,0]) cylinder(h=x/2+1, r=s/2, $fn=16);
		translate([x/2-1, y/2, z+0.5]) rotate([0,90,0]) cylinder(h=x/2+2, r=m/2, $fn=16);
	}
}

coupling();
//translate([0, 30, 0]) coupling();
//translate([35, 0, 0]) coupling();
//translate([35, 30, 0]) coupling();

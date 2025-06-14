//
// An accessory box that goes on the top of a dumbbell rack.  This rack has a v-shaped angle on the 
// top, so the box must have be angled to sit snugly on top.  It has two magnets to keep in on 
// the rack.
//
// Given:
//
// - The angle of the rack top is 160 degrees.
// - The depth of the box on the rack will be 95mm.  This gives a bit of space on each side.
// - The length of one side of the box on the rack will be 115mm.  This too give some space on each side.
//
// With the above measurements, the flat base of the box will be 226.5 mm using this online calculator: 
// https://www.omnicalculator.com/math/triangle-side
//

// The Belfry OpenScad Library, v2:  https://github.com/BelfrySCAD/BOSL2
// This library must be installed in your instance of OpenScad to use this model.
include <BOSL2/std.scad>

// *** Model Parameters ***
/* [Model Parameters] */

// Angle of the dumbbell rack top in degrees.
rack_angle = 160;

// Depth of the box on the rack in mm.
rack_depth = 115;

// Length of one side of the box on the rack in mm.
rack_side_length = 92;

// The diameter of the magnets that will hold the box on the rack.
magnet_diameter = 12;

// The depth of the magnet holes in the base of the box.
magnet_depth = 2;

// *** "Private" variables ***
/* [Hidden] */

// OpenSCAD System Settings
$fa = 1;
$fs = 0.4;

// Calculated Global Vars

//
// The flat base of the box on the rack.  Based on: https://en.wikipedia.org/wiki/Law_of_cosines
//
box_base_length = sqrt(
    (rack_side_length^2) + (rack_side_length^2) -
    2*(rack_side_length * rack_side_length) * cos(rack_angle)
    );

echo("box_base_length: ", box_base_length);

// This is the angle of the triangle formed by the rack base to the horizontal plane.
base_gap_angle = (180 - rack_angle) / 2;

//
// Calculates the hight of the base prismoid.  
//
base_height = (box_base_length / 2) * sin(base_gap_angle);
echo("base_height: ", base_height);

//
// Creates the angled base that sits on the rack.
//
module box_base() {
    difference() {
        prismoid(size1=[rack_depth, 0], size2=[rack_depth, box_base_length], h=base_height);

        magnet_holes();   
    }
}

//
// Create magnet holes in the base of the box.
// Place two magnet holes at 80% of the length on one side, centered.
//
module magnet_holes() {

    // Y position is 80% of the rack length.
    y_offset = rack_side_length * 0.8;
    echo("y_offset for magnet: ", y_offset);

    // Calculate z_offset to the bottom of the rack base.
    z_offset = (y_offset * sin(base_gap_angle)) + (magnet_depth/2);
    echo("z_offset for magnet: ", z_offset);

    translate([0, y_offset, z_offset]) {
        rotate([base_gap_angle, 0, 0])
            cyl(d=magnet_diameter, h=magnet_depth);
    }

    translate([0, -y_offset, z_offset]) {
        rotate([-base_gap_angle, 0, 0])
            cyl(d=magnet_diameter, h=magnet_depth);
    }

}


//
// Builds the entire model.
//
module build_model() {
    box_base();

}

build_model();


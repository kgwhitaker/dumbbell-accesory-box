//
// An accessory box that goes on the top of a dumbbell rack.  This rack has a v-shaped angle on the 
// top, so the box must have be angled to sit snugly on top.  It has two magnets to keep in on 
// the rack.
//

// The Belfry OpenScad Library, v2:  https://github.com/BelfrySCAD/BOSL2
// This library must be installed in your instance of OpenScad to use this model.
include <BOSL2/std.scad>

// *** Model Parameters ***
/* [Accessory Box] */

// Angle of the dumbbell rack top in degrees.
rack_angle = 158;

// Depth of the box on the rack in mm.
rack_depth = 115;

// Length of one side of the box on the rack in mm.
rack_side_length = 92;

// Accessory box height.
accessory_box_height = 70;

// Corner rounding for the accessory box.
corner_rounding = 2;

// Accessory box wall thickness.
wall_thickness = 2;

/* [Magnetic Base] */

// True = Put cutouts for magnets in the base of the box.
magnet_holes = true;

// The diameter of the magnets that will hold the box on the rack.
magnet_diameter = 12.1;

// The depth of the magnet holes in the base of the box.
magnet_depth = 2;

// *** "Private" variables ***
/* [Hidden] */

// OpenSCAD System Settings
$fa = 1;
$fs = 0.4;

// Calculated Global Vars

//
// The flat base of the box on the rack.  
// Calculation based on: https://en.wikipedia.org/wiki/Law_of_cosines
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
// Using Sine function: https://en.wikipedia.org/wiki/Sine_and_cosine
//
base_height = (box_base_length / 2) * sin(base_gap_angle);
echo("base_height: ", base_height);

//
// Creates the angled base that sits on the rack.
//
module box_base() {
    difference() {
        prismoid(size1=[rack_depth, 0], size2=[rack_depth, box_base_length], h=base_height, rounding2=corner_rounding);

        if (magnet_holes)
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
// Creates the accessory box that is joined with the angled base.
//
module accessory_box() {

    difference() {
        translate([0, 0, base_height]) {
            cuboid(size=[rack_depth, box_base_length, accessory_box_height], anchor=BOT, rounding = corner_rounding, except=BOT);
        }

        translate([0, 0, base_height + wall_thickness]) {
            cuboid(size=[rack_depth - (wall_thickness * 2), box_base_length - (wall_thickness * 2), accessory_box_height], anchor=BOT);
        }
    }
}


//
// Builds the entire model.
//
module build_model() {
    box_base();
    accessory_box();

}

build_model();


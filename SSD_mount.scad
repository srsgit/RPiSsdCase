// Mount for an SSD in a case and a Raspberry Pi for vertical mounting.
// Two parts/one design - re-render/export with bottom_half set to 0 & 1
//
// SSD case sits vertically in the Bottom part
// Top part is the same, but without the bottom.
// Both parts have mounts for a Raspberry Pi
//
// Copyright S.R.Smith 2021
//

bottom_half = 1; 

// Adjust these to match the SSD case size

ssd_width           = 76.5;   // width of SSD case
ssd_thickness       = 15.5;   // thickness of SSD case
mount_width         = 25.0;   // how high do you want each mount
wall_thickness      = 1.3;

// These only need adjusting if the RPi mounts or ears need adjusting

pi_hole_width       = 49.0;
pi_hole_length      = 58.0;

pi_mount_width      = 6.0;
pi_mount_height     = 4.0;
pi_mount_hole_dia   = 2.5;

ear_height          = 15.0;
ear_width           = 10.0;
ear_hole_dia        = 3.0;
ear_hole_head       = 6.0;

pi_mount_hole_depth = pi_mount_height + wall_thickness + 2.0;

// outer dimensions of case block
base_width  = ssd_width     + 2 * wall_thickness;
base_depth  = ssd_thickness + 2 * wall_thickness;
base_height = mount_width;

inner_width     = ssd_width;
inner_depth     = ssd_thickness;
inner_height    = base_height + 2.0;
inner_translate = base_height/2 + bottom_half * wall_thickness;

//-----------------------------------------------------------------------
// Main body to hold SSD case
//-----------------------------------------------------------------------

module body() {
    
  difference() {
    // outer wall
    translate( [0, -base_depth/2, base_height/2]) 
      cube([base_width, base_depth, base_height], true);
    // inner hole for end of SSD case
#    translate( [0, -base_depth/2, inner_translate])
      cube([ssd_width, ssd_thickness, base_height + 1.0], true);
  } 
}

//-----------------------------------------------------------------------
// Two mounting ears either side with a screw hole
//-----------------------------------------------------------------------

module ears() {
  difference() {
    union () {
      translate([(base_width + ear_width)/2,
                 -(base_depth - wall_thickness/2), 
                 ear_height/2])
        cube([ear_width, wall_thickness, ear_height], true);
        
      translate([-(base_width + ear_width)/2,
                 -(base_depth - wall_thickness/2), 
                 ear_height/2])
        cube([ear_width, wall_thickness, ear_height], true);
    }
    translate([(base_width + ear_width)/2,
               -(base_depth - wall_thickness/2), 
               ear_height/2])
      rotate([90,0,0])
        cylinder(h=wall_thickness + 2.0, 
                  r=ear_hole_dia/2,
                  center=true);
    translate([-(base_width + ear_width)/2,
               -(base_depth - wall_thickness/2), 
               ear_height/2])
      rotate([90,0,0])
        cylinder(h=wall_thickness + 2.0, 
                  r=ear_hole_dia/2,
                  center=true);
  }
}

//-----------------------------------------------------------------------
// Two stub mounting points with a screw hole
//-----------------------------------------------------------------------

module pi_mounts() {
  difference() {
    union() {
      translate([pi_hole_width /2, pi_mount_height/2, pi_mount_width /2])
        cube([pi_mount_width, pi_mount_height, pi_mount_width], true);
      translate([-pi_hole_width /2, pi_mount_height/2, pi_mount_width /2])
        cube([pi_mount_width, pi_mount_height, pi_mount_width], true);
    };
    translate([pi_hole_width /2, pi_mount_height /2, pi_mount_width /2])
      rotate([90,0,0])
        cylinder(h=pi_mount_hole_depth, 
                 r=pi_mount_hole_dia/2,
                 center=true);
    translate([-pi_hole_width /2, pi_mount_height /2, pi_mount_width /2])
      rotate([90,0,0])
        cylinder(h=pi_mount_hole_depth, 
                 r=pi_mount_hole_dia/2,
                 center=true);
  } 
}

//-----------------------------------------------------------------------
// Put it all together
//-----------------------------------------------------------------------

module mount() {
  body();
  pi_mounts();
  ears();
}

mount();
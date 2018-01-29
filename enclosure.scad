
$fn = 50;

part = "all";
//part = "front";
//part = "rear";
//part = "bottom_tripod_socket";

panel_width = 165;
panel_height = 95;
panel_thickness = 3.3;
shell_thickness = 2;

bezel_left = 3;
bezel_right = 5.5;
bezel_top = 7.5;
bezel_bottom = 3.5;
fudge = 0.4;

ribbon_width = 35;
ribbon_slot = 6;
ribbon_position = "bottom";
ribbon_cover = true;

ribbon_offset_x = 0;
ribbon_offset_y = 0;

vesa = 75;
vesa_mount_dia = 10;
vesa_mount_pillar = 10;
vesa_mount_drill = 5.1;
vesa_mount_tip = 3;
vesa_nut_dia = 8;

backpack_width = 85;
backpack_height = 50;
backpack_thickness = 9;

backpack_slot_side = "right";
backpack_slot_inset_x = 4;
backpack_slot_inset_y = 1;
backpack_slot_height = 47;


joiner_width = 75;
joiner_height = 6;
joiner_nut = 6;
joiner_nut_counterbore = 0;
joiner_counterbore = 0;
joiner_drill = 2.5;
joiner_drill_inset = 8;
joiner_drill_front_clearance = 2;
joiner_drill_rear_clearance = 0;
joiner_drill_side = 1;

tripod_mount_width = 40;


module panel_shell() {
     minkowski() {
          panel();
          sphere(r=shell_thickness/2);
     }
}

module backpack_shell() {
     minkowski() {
          backpack();
          sphere(r=shell_thickness/2);
     }
}

module backpack() {
     translate([(panel_width-backpack_width)/2,
                (panel_height-backpack_height)/2,
                panel_thickness])
          cube([backpack_width, backpack_height, backpack_thickness]);
}

module ribbon_clearance() {
     if (ribbon_position == "top") {
          translate([(panel_width-ribbon_width)/2-ribbon_offset_x,
                     panel_height/2,
                     panel_thickness])
               cube([ribbon_width, panel_height/2-ribbon_offset_y, backpack_thickness]);
     } else {
          translate([(panel_width-ribbon_width)/2-ribbon_offset_x,
                     ribbon_offset_y,
                     panel_thickness])
               cube([ribbon_width, panel_height/2-ribbon_offset_y, backpack_thickness]);

     }
}

module ribbon_cover() {
     minkowski() {
          ribbon_clearance();
          sphere(r=shell_thickness/2);
     }
     
}

module vesa_pillar() {
     cylinder(d=vesa_mount_dia, h=vesa_mount_pillar);
}

module vesa_standoffs() {
     translate([panel_width/2, panel_height/2, panel_thickness]) {
          translate([ vesa/2,  vesa/2, 0]) vesa_pillar();
          translate([ vesa/2, -vesa/2, 0]) vesa_pillar();
          translate([-vesa/2,  vesa/2, 0]) vesa_pillar();
          translate([-vesa/2, -vesa/2, 0]) vesa_pillar();
     }

}

module vesa_standoff_drill() {
     cylinder(d=vesa_nut_dia, h=vesa_mount_pillar-vesa_mount_tip, $fn=6);
     cylinder(d=vesa_mount_drill, h=vesa_mount_pillar+fudge);
}

module vesa_standoff_drills() {
     translate([panel_width/2, panel_height/2, panel_thickness-fudge]) {
          translate([ vesa/2,  vesa/2, 0]) vesa_standoff_drill();
          translate([ vesa/2, -vesa/2, 0]) vesa_standoff_drill();
          translate([-vesa/2,  vesa/2, 0]) vesa_standoff_drill();
          translate([-vesa/2, -vesa/2, 0]) vesa_standoff_drill();
     }
     
}


module joiner_shell() {
     minkowski() {
          cube([joiner_width, joiner_height, panel_thickness]);
          sphere(r=shell_thickness/2);
     }
}

module joiner() {
     translate([(panel_width-joiner_width)/2, -joiner_height,0]) joiner_shell();
     translate([(panel_width-joiner_width)/2, panel_height,0]) joiner_shell();
}

module joiner_drill() {
     cylinder(d=joiner_nut, h=joiner_counterbore);

     translate([0,0,joiner_drill_front_clearance])
          cylinder(d=joiner_drill, h=panel_thickness+2*shell_thickness-joiner_drill_front_clearance-joiner_drill_rear_clearance);

     translate([0,0,panel_thickness+2*shell_thickness-joiner_nut_counterbore])
          cylinder(d=joiner_nut, h=joiner_nut_counterbore, $fn=6);
}

module joiner_drills() {
     translate([(panel_width-joiner_width)/2, -joiner_height,-shell_thickness]) {
          translate([joiner_drill_inset, joiner_height/2]) joiner_drill();
          translate([joiner_width-joiner_drill_inset, joiner_height/2]) joiner_drill();
     }
     translate([(panel_width-joiner_width)/2, panel_height,-shell_thickness]) {
          translate([joiner_drill_inset, joiner_height/2]) joiner_drill();
          translate([joiner_width-joiner_drill_inset, joiner_height/2]) joiner_drill();
     }
}

module joiner_drill_set() {
     if (joiner_drill_side==0) {
          joiner_drills();
     } else {
          translate([0,0,panel_thickness+2*shell_thickness]) scale([1,1,-1]) joiner_drills();
     }
}

module enclosure_outline() {
     union() {
          panel_shell();
          joiner();
          backpack_shell();
          ribbon_cover();
          vesa_standoffs();
     }
}

module panel() {
     cube([panel_width, panel_height, panel_thickness]);
}

module panel_opening() {
     translate([bezel_left,bezel_bottom,0-shell_thickness-fudge]) cube([panel_width-bezel_left-bezel_right, panel_height-bezel_bottom-bezel_top,shell_thickness+2*fudge]);
}


module ribbon_slot() {
     if (ribbon_position == "top") {
          translate([(panel_width-ribbon_width)/2-ribbon_offset_x,
                     panel_height-ribbon_offset_y-ribbon_slot,
                     panel_thickness - fudge])
               cube([ribbon_width, ribbon_slot, shell_thickness+2*fudge]);
     } else {
          translate([(panel_width-ribbon_width)/2-ribbon_offset_x,
                     ribbon_offset_y,
                     panel_thickness - fudge])
               cube([ribbon_width, ribbon_slot, shell_thickness+2*fudge]);
     }
}


module backpack_slot() {
     translate([-shell_thickness,backpack_slot_inset_y,0])
          cube([backpack_slot_inset_x+shell_thickness, backpack_slot_height, backpack_thickness]);
}

module backpack_slots() {
     translate([(panel_width-backpack_width)/2,
                (panel_height-backpack_height)/2,
                panel_thickness]) {
          if (backpack_slot_side==0) {
               backpack_slot();
          } else {
               translate([backpack_width,0,0]) scale([-1,1,1]) backpack_slot();
          }
     }
}
          

module enclosure() {
     
     difference() {
          enclosure_outline();
          panel();
          panel_opening();
          ribbon_slot();
          vesa_standoff_drills();
          joiner_drill_set();
          backpack();
          ribbon_clearance();
          backpack_slots();
     }
}               

module front_bounding() {
     translate([-shell_thickness,
                -shell_thickness-joiner_height,
                -shell_thickness])
          cube([panel_width+2*shell_thickness,
                panel_height+2*shell_thickness+2*joiner_height,
                panel_thickness+shell_thickness]);
}


module tripod_socket_body() {
     tripod_mount_width = 40;

     hull() {
          translate([panel_width/2-vesa/2,
                     panel_height/2-vesa/2,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
          translate([panel_width/2+vesa/2,
                     panel_height/2-vesa/2,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
     }
     hull() {
          translate([panel_width/2-tripod_mount_width/2,
                     panel_height/2-vesa/2,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
          translate([panel_width/2+tripod_mount_width/2,
                     panel_height/2-vesa/2,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
          translate([panel_width/2-tripod_mount_width/2,
                     0-vesa_mount_pillar/2-joiner_height,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
          translate([panel_width/2+tripod_mount_width/2,
                     0-vesa_mount_pillar/2-joiner_height,
                     panel_thickness+vesa_mount_pillar])
               cylinder(r=vesa_mount_drill, h=8);
     }

     hull() {
          translate([panel_width/2-tripod_mount_width/2,
                     0-vesa_mount_pillar/2-joiner_height-shell_thickness/2,
                     0])
               cylinder(r=vesa_mount_drill, h=vesa_mount_pillar+8+panel_thickness);
          translate([panel_width/2+tripod_mount_width/2,
                     0-vesa_mount_pillar/2-joiner_height-shell_thickness/2,
                     0])
               cylinder(r=vesa_mount_drill, h=vesa_mount_pillar+8+panel_thickness);

     }

}

module tripod_socket_drills() {
     translate([panel_width/2-vesa/2,
                panel_height/2-vesa/2,
                panel_thickness+vesa_mount_pillar])
          cylinder(d=vesa_mount_drill, h=8);
     translate([panel_width/2+vesa/2,
                panel_height/2-vesa/2,
                panel_thickness+vesa_mount_pillar])
          cylinder(d=vesa_mount_drill, h=8);
     
          translate([panel_width/2,0,0]) 
               rotate([-90,0,0])
               translate([0,
                          -panel_thickness-vesa_mount_pillar/2,
                          0-joiner_height-vesa_mount_pillar-shell_thickness/2-fudge]) {
               cylinder(d=6.35, h=vesa_mount_pillar+2*fudge);
               translate([0,0,vesa_mount_pillar-5+fudge]) cylinder(d=25.4*7/16, h=5+fudge,$fn=6);
          }
     
}

module bottom_tripod_socket() {
     
     difference() {
     //union() {
          color("grey") tripod_socket_body();
          color("red" ) tripod_socket_drills();
     }
}

if (part == "front") {
     intersection() {
          front_bounding();
          enclosure();
     }
} else if (part == "rear") {
     difference() {
          enclosure();
          front_bounding();
     }
} else if (part == "bottom_tripod_socket") {
     bottom_tripod_socket();
} else {
     enclosure();
     bottom_tripod_socket();
}



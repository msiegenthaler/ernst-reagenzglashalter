///////////////
// Parameter //
///////////////

// Anzahl der Gläser
glas_count = 8;

// Durchmesser der Gläser
glas_diameter = 17;

// Abstand zwischen den Gläsern in mm
glas_gap = 8;

//Differenz im Durchmesser zwischen Glas und Halterung im mm
glas_holding_gap = 1;

// Höhe (total der Halterung in mm)
height = 100;

// Vertikale Position vom Boden weg gemessen in mm der unteren Halterung (kleine Löcher)
holder_y = 35;

// Holzdicke in mm
wood = 4;



////////////////////////
// Art des Renderings //
////////////////////////

// lasercut();
3d_body();






/////////////////////
// Implementierung //
/////////////////////

use <wood.scad>
glas_inset = 2 * wood;
glas_spacing_z = 1.625 * wood;
width = glas_count*glas_diameter + (glas_count-1)*glas_gap + glas_inset*2;
depth = glas_spacing_z*2 + glas_diameter;
viewport_width = glas_diameter;

module lasercut() {
  gap = 2;
  translate([0,0])
    backplate();
  translate([width+gap,0])
    frontplate();
  translate([0,height+2*wood+gap])
    bottom();
  translate([width+gap,height+2*wood+gap])
    holder();
  translate([0,height+2*wood+depth+2*gap])
    topping();
}

module 3d_body() {
  color("Aquamarine") linear_extrude(wood)
    backplate();
  translate([0,0,depth-wood]) color("LightSkyBlue") linear_extrude(wood)
    frontplate();

  translate([0,wood,wood]) rotate([90,0,0]) color("SandyBrown") linear_extrude(wood)
    bottom();
  translate([0,holder_y + wood,wood]) rotate([90,0,0]) color("RosyBrown") linear_extrude(wood)
    holder();
  translate([0,height,wood]) rotate([90,0,0]) color("Wheat") linear_extrude(wood)
    topping();
}

module backplate() {
  difference() {
    side();
    translate([0, holder_y])
      holder_spikes();
  }
}

module frontplate() {
  viewport_height = height - 4*wood;
  difference() {
    side();
    for (i=[0:glas_count-1]) {
      translate([glas_inset+i*(glas_diameter+glas_gap),0])
        translate([0,(height-viewport_height)/2])
          square([viewport_width,viewport_height]);
    };
    translate([0, holder_y])
      holder_spikes();
  }
}

module topping() {
  difference() {
    layer();
    for (i=[0:glas_count-1]) {
      translate([glas_inset+i*(glas_diameter+glas_gap),0])
        translate([glas_diameter/2,depth/2-wood])
          circle(d = glas_diameter + glas_holding_gap);
    }
  }
}

module holder() {
  diameter = glas_diameter / 2;
  union() {
    difference() {
      square([width, depth - 2*wood]);;
      for (i=[0:glas_count-1]) {
        translate([glas_inset+i*(glas_diameter+glas_gap),0])
          translate([glas_diameter/2,depth/2-wood])
            circle(d = diameter + glas_holding_gap);
      }
    };
    translate([0, -wood])
      holder_spikes();
    translate([0, depth-2*wood])
      holder_window_fills();
    translate([0, depth-2*wood])
      holder_spikes();
  }
}

module holder_window_fills() {
    for (i=[0:glas_count-1]) {
      translate([glas_inset+i*(glas_diameter+glas_gap),0])
        #square([viewport_width, wood]);
    }
}

module holder_spikes() {
  union() {
    square([wood, wood]);
    translate([width-wood, 0])
      square([wood, wood]);
    for (i=[1:glas_count-1]) {
      translate([-glas_gap/2-wood/2,0])
        translate([glas_inset+i*(glas_diameter+glas_gap),0])
          square([wood, wood]);
    }
  }
}

module bottom() {
  layer();
}

module layer() {
  union() {
    square([width, depth - 2*wood]);
    woodjoint(width, true, true, wood, wood);
    translate([0, depth - wood])
    woodjoint(width, true, true, wood, wood);
  }
}

module side() {
  union() {
    translate([0,wood])
      square([width, height-2*wood]);
    woodjoint(width, false, false, wood, wood);
    translate([0, height-wood])
      woodjoint(width, false, false, wood, wood);
  }
}
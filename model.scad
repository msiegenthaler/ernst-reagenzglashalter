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

module lasercut() {
  gap = 2;
  translate([0,0])
    backplate();
  translate([width+gap,0])
    frontplate();
  translate([0,height+gap])
    bottom();
  translate([width+gap,height+gap])
    holder();
  translate([0,height+depth+2*gap])
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
  side();
}

module frontplate() {
  viewport_width = glas_diameter;
  viewport_height = height - 4*wood;
  difference() {
    side();
    for (i=[0:glas_count-1]) {
      translate([glas_inset+i*(glas_diameter+glas_gap),0])
        translate([0,(height-viewport_height)/2])
          square([viewport_width,viewport_height]);
    };
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
  difference() {
    layer();
    for (i=[0:glas_count-1]) {
      translate([glas_inset+i*(glas_diameter+glas_gap),0])
        translate([glas_diameter/2,depth/2-wood])
          circle(d = diameter + glas_holding_gap);
    }
  }
}

module bottom() {
  layer();
}

module layer() {
  square([width, depth - 2*wood]);
}

module side() {
  square([width, height]);
}
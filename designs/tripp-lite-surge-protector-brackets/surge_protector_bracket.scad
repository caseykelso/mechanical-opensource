// Under-desk mounting bracket for a surge protector.
// Two are required, one near each end; the protector slides in lengthwise so
// their spacing is free.
//
// The top plate extends sideways into two ears that carry the desk screws, so
// the screw heads are buried in solid plate and never break into the cavity or
// thin the walls. Load path: protector -> strap -> walls -> plate -> ears.
// The load enters the plate at the wall centreline and leaves it at the screw
// 5.25mm outboard, so the plate does bend, but only to 0.48 MPa against a
// ~50 MPa PETG yield. See the note on the ear rib below.
//
// Print orientation: profile flat on the bed, extruded 13mm upwards. That keeps
// the filament running continuously around the band in every layer, so the load
// path lies along the extrusion instead of across layer bonds. No supports, no
// overhangs, 13mm tall.
//
// make surgeprotectorbracket.stl

$fn=200;

/* [surge protector] */
// measured body width
protector_w        = 55;
// measured body height, this becomes the drop below the desk
protector_h        = 34;
// radius of the protector's own body corners
protector_corner_r = 4;
// body length, only used to draw the fit-check ghost
protector_len      = 300;

/* [fit] */
// clearance per side, 0.25 is a sliding fit in PETG
clearance = 0.25;
// chamfer on both cavity mouths so the protector starts without snagging
lead_in   = 1;

/* [bracket] */
// bracket width along the protector's length
bracket_w = 13;
// top plate, this is the face that meets the desk
plate_t   = 5;
// side walls
wall_t    = 6;
// bottom strap, carries the whole weight of the protector
strap_t   = 5;
// fillet on the outside corners of the body
outer_r   = 5;
// fillet on the ear tips. keep this small: rrect clamps it to plate_t/2 and a
// round tip pulls the underside inboard, which can let the countersink burst
// out through the tip
ear_r     = .5;
// The ear needs no reinforcing rib. Per bracket the protector hangs ~10N off
// two screws: the wall sees 0.06 MPa in tension and the plate 0.48 MPa in
// bending from the 5.25mm eccentricity between wall centreline and screw, both
// more than 100x inside PETG yield. A rib there would also be almost entirely
// consumed by the screw hole, leaving a sliver that prints badly.

/* [fastener] */
// #8 wood screw: 4.2mm shank, 8.3mm flat head, 82 degree included angle
screw_d    = 4.5;
cs_head_d  = 8.3;
cs_angle   = 82;
// how far the screw centre sits outboard of the body face. only just outboard,
// so the countersink is enclosed inboard by solid wall top and the ear can
// stay narrow
screw_outboard = 5.25;
// plastic left between the widest point of the head and the ear tip
ear_margin = 1.5;

/* [layout] */
// brackets rendered side by side, set to 1 to export a single part
layout_count = 2;
layout_gap   = 10;
// draw a translucent protector and desk to check fit, never reaches the STL
show_context = true;
// 2d export for drawings, applies projection to the solid so the cavity and
// screw holes show up. override from the command line:
//   openscad surge_protector_bracket.scad -o bracket.dxf -D 'make_2d=true'
make_2d = false;


// ---- derived, edit the parameters above instead ----
cav_w    = protector_w + 2 * clearance;
cav_h    = protector_h + 2 * clearance;
cav_r    = protector_corner_r + clearance;
// walls + cavity, before the ears are added
body_w   = cav_w + 2 * wall_t;
outer_h  = plate_t + cav_h + strap_t;
// cavity is centred in X, shifted in Y so plate_t and strap_t are both honoured
cav_dy   = (strap_t - plate_t) / 2;
// underside of the top plate, this is the bearing face for the screw heads
y_desk   = cav_dy + cav_h / 2;
// the ear reaches from the body face out past the head, plus tip margin
ear_w    = screw_outboard + cs_head_d / 2 + ear_margin;
total_w  = body_w + 2 * ear_w;
// one screw per ear, just outboard of the wall
screw_x  = body_w / 2 + screw_outboard;
cs_depth = (cs_head_d - screw_d) / 2 / tan(cs_angle / 2);
// the ear tip rounding pulls the underside inboard by rr, so the tightest
// point for the countersink is the plate underside, not the ear midline
ear_rr   = min(ear_r, plate_t / 2);
tip_margin       = total_w / 2 - screw_x - cs_head_d / 2;
tip_margin_worst = tip_margin - ear_rr;


// sanity checks, these only warn, they never fail the build. each one is
// computed from the resulting geometry, not from the input parameters
if (tip_margin_worst < 0.5)
    echo(str("WARNING: only ", tip_margin_worst,
             "mm of ear left outboard of the head at the plate underside"));
if (screw_x - cs_head_d / 2 < cav_w / 2)
    echo(str("WARNING: countersink breaks into the cavity by ",
             cav_w / 2 - (screw_x - cs_head_d / 2), "mm"));
if (plate_t - cs_depth < 2)
    echo(str("WARNING: only ", plate_t - cs_depth,
             "mm of plate left above the ", cs_depth, "mm countersink"));
if (bracket_w - cs_head_d < 2)
    echo(str("WARNING: only ", (bracket_w - cs_head_d) / 2,
             "mm of ear beside the head along the bracket width"));
if (strap_t < 4)
    echo(str("WARNING: ", strap_t, "mm bottom strap is thin, it carries the full load"));
if (wall_t < 4)
    echo(str("WARNING: ", wall_t, "mm side wall is thin for a ", cav_h, "mm tall wall"));

echo(str("bracket ", total_w, " wide x ", outer_h, " tall x ", bracket_w,
         " thick, drops ", outer_h - plate_t, "mm below the desk"));
echo(str("cavity ", cav_w, " x ", cav_h, ", countersink ", cs_depth,
         " deep, screws at +-", screw_x, " on ", 2 * screw_x, " centres"));
echo(str("ear tip margin ", tip_margin_worst,
         "mm worst case, wall left inboard of the countersink ",
         screw_x - cs_head_d / 2 - cav_w / 2, "mm"));


// rectangle centred on the origin with all four corners rounded
module rrect(w, h, r)
{
    rr = max(0, min(r, w / 2, h / 2));

    if (rr == 0)
    {
        square([w, h], center=true);
    }
    else
    {
        hull()
        {
            translate([ w/2 - rr,  h/2 - rr]) circle(rr);
            translate([-w/2 + rr,  h/2 - rr]) circle(rr);
            translate([ w/2 - rr, -h/2 + rr]) circle(rr);
            translate([-w/2 + rr, -h/2 + rr]) circle(rr);
        }
    }
}

// the band cross section: body, plate extended out into the ears, minus the
// protector cavity
module band_section()
{
    difference()
    {
        union()
        {
            // walls, strap and the middle of the plate
            rrect(body_w, outer_h, outer_r);

            // one continuous bar across the whole span, the outer parts of
            // which are the ears. drawn as a single piece so the desk-side
            // face stays flat and unbroken all the way out to the ear tips
            translate([0, y_desk + plate_t / 2])
                rrect(total_w, plate_t, ear_r);
        }

        translate([0, cav_dy]) rrect(cav_w, cav_h, cav_r);
    }
}

// widen each cavity mouth so the protector threads in instead of snagging on
// the sharp inner corner
module lead_in_cut()
{
    if (lead_in > 0)
    {
        sx = (cav_w + 2 * lead_in) / cav_w;
        sy = (cav_h + 2 * lead_in) / cav_h;

        translate([0, cav_dy, 0])
        {
            // far mouth, wide at z = bracket_w and closing down to nominal
            translate([0, 0, bracket_w - lead_in])
                linear_extrude(lead_in + 0.01, scale=[sx, sy], convexity=4)
                    rrect(cav_w, cav_h, cav_r);

            // near mouth, wide at z = 0 and closing down to nominal
            translate([0, 0, lead_in]) mirror([0, 0, 1])
                linear_extrude(lead_in + 0.01, scale=[sx, sy], convexity=4)
                    rrect(cav_w, cav_h, cav_r);
        }
    }
}

// origin where the screw axis crosses the underside of the plate, +Y towards
// the desk. the cone opens downwards, so the flat head seats below the plate
// and the desk-side face is never touched
module screw_tool()
{
    rotate([-90, 0, 0])
    {
        // clearance hole. over-runs past the desk-side face only, never below
        // the plate underside, so the cone mouth stays a clean full circle
        cylinder(d=screw_d, h=plate_t + 0.5);

        // head recess, widest at the plate underside
        cylinder(h=cs_depth, d1=cs_head_d, d2=screw_d);
    }
}

module bracket()
{
    difference()
    {
        linear_extrude(bracket_w, convexity=10) band_section();

        lead_in_cut();

        for (side = [-1, 1])
            translate([side * screw_x, y_desk, bracket_w / 2])
                screw_tool();
    }
}

// % marks this as background geometry, openscad excludes it from the STL
module context()
{
    if (show_context)
    {
        %translate([0, cav_dy, bracket_w / 2 - protector_len / 2])
            linear_extrude(protector_len)
                rrect(protector_w, protector_h, protector_corner_r);

        %translate([0, y_desk + plate_t + 45, 0])
            cube([400, 90, 400], center=true);
    }
}

module layout(n = layout_count)
{
    for (i = [0 : n - 1])
        translate([(i - (n - 1) / 2) * (total_w + layout_gap), 0, 0])
            bracket();
}


if (make_2d)
{
    projection(cut = false) layout();
}
else
{
    layout();
    context();
}

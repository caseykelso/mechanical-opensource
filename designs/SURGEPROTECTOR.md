# Tripp Lite Surge Protector Under-Desk Bracket

Two printed brackets clamp around a Tripp Lite surge protector body and screw
to the underside of a desk. The protector slides in lengthwise through both, so
their spacing along the body is free; put one near each end.

Source of truth for the model is `surge_protector_bracket.scad`. This document
is the design record: why the geometry is what it is, the numbers behind it, the
defects found along the way, and how to print it.

## Current state

Branch `tripp-lite-surge-brackets`. History, newest first:

| commit | change |
|---|---|
| `9fc980c` | it fits; add the Bambu Studio `.3mf` |
| `f9609cd` | increase length of mounting ears (`screw_outboard` 2.25 -> 5.25) |
| `855d16c` | reduce opening by 2mm in width and height |
| `9274dda` | original bracket, Makefile targets, print notes |

The `.3mf` (`surge_protector_bracket.3mf`) is the Bambu Studio project and is
what should be sliced. The STL/DXF are regenerable build artifacts and are
gitignored.

## Fit history: why the cavity is 55.5 x 34.5

The model was first built against a measured 57 x 36mm envelope with 0.25mm of
clearance per side, giving a 57.5 x 36.5mm cavity. A test fit showed about 2mm
of play per axis.

That play is diagnostic. A 57.5mm cavity around a 57mm body can only ever have
0.5mm of play, so 2mm of felt slop means the body at the point the brackets
actually clamp is about 55 x 34, not the 57 x 36 overall envelope. The envelope
is the widest point (end caps, cord boot); the mid-body the brackets grip is
narrower. `protector_w` and `protector_h` in the `.scad` are therefore the
clamping-section dimensions, not the envelope. If the protector is ever
re-measured, change those two numbers and everything downstream re-derives.

`f9609cd` then pushed the screws outboard (`screw_outboard` 2.25 -> 5.25). That
lengthened the ears and, as a side benefit, took the wall remaining inboard of
the countersink from 4.1mm to 7.1mm.

## How it holds the load

Closed band: a bottom strap under the protector, two side walls, and a top
plate against the desk. The protector cannot fall out; retention is positive.

Load path: protector -> strap -> walls -> plate -> ears -> desk screws.

The top plate extends sideways into two ears that carry the screws, so the
screw heads are buried in solid plate and never break into the cavity or thin
the walls. The load enters the plate at the wall centreline (X=30.75) and leaves
it at the screw (X=39.0), 8.25mm outboard, so the plate does bend. At ~10N per
bracket over two screws that is 5N per screw, a 41 N·mm moment against a
section modulus of 54 mm3, or 0.76 MPa. The wall sees 0.06 MPa in tension.
PETG yields around 50 MPa, so both are more than 60x inside yield. That margin
is why the ear carries no reinforcing rib; a rib placed there would also be
almost entirely consumed by the screw hole, leaving a sub-1mm sliver that prints
badly.

The countersink is cut upwards from the plate underside, so the flat head seats
below the plate and the desk-side face stays perfectly flat and unbroken out to
the ear tips.

## Parameters

Edit these at the top of `surge_protector_bracket.scad`, not the geometry.

| parameter | value | meaning |
|---|---|---|
| `protector_w` | 55 | body width at the clamping section |
| `protector_h` | 34 | body height at the clamping section, sets drop below desk |
| `protector_corner_r` | 4 | radius of the protector's own corners |
| `protector_len` | 300 | ghost length for the GUI fit check only |
| `clearance` | 0.25 | per side; 0.25 is a sliding fit in PETG |
| `lead_in` | 1 | chamfer on both cavity mouths so it threads without snagging |
| `bracket_w` | 13 | bracket width along the protector's length; also the print height |
| `plate_t` | 5 | top plate, the face that meets the desk |
| `wall_t` | 6 | side walls |
| `strap_t` | 5 | bottom strap, carries the full weight |
| `outer_r` | 5 | fillet on the outside body corners |
| `ear_r` | 0.5 | ear tip fillet; keep small, see defects below |
| `screw_d` | 4.5 | clearance for a #8 wood screw (4.2mm shank) |
| `cs_head_d` | 8.3 | #8 flat head diameter |
| `cs_angle` | 82 | included angle of the flat head |
| `screw_outboard` | 5.25 | screw centre outboard of the body face |
| `ear_margin` | 1.5 | plastic between the head and the ear tip |
| `layout_count` | 2 | brackets rendered side by side; set 1 for a single part |
| `layout_gap` | 10 | gap between laid-out brackets |
| `show_context` | true | ghost protector + desk in the GUI, never reaches the STL |
| `make_2d` | false | `projection()` for the DXF export |

## Verified geometry

Measured from the exported STL, not from the parameters.

| | |
|---|---|
| overall | 89.3 x 44.5 x 13 mm |
| cavity | 55.5 x 34.5 mm, corner r4.25 |
| drop below desk | 39.5 mm |
| plate / wall / strap | 5 / 6 / 5 mm |
| screw positions | X = +-39.0, on 78 mm centres, mid-height of the 13mm |
| countersink | 8.3 dia x 2.19 deep, opening at the plate underside |
| ear tip | 1.0mm of plastic outboard of the head at the tightest point |
| wall inboard of cone | 7.1 mm |
| solid volume | 15.2 cm3, 19.3g in PETG if printed solid |
| two-up footprint | 188.6 x 44.5 mm |
| sits flat on bed | z min exactly 0 |

Section scans confirm the countersink cone is fully enclosed in plastic at the
plate underside (outermost solid at X=44.37 against a cone edge of 43.15), and
the cone surface matches the analytic profile to within 0.04mm.

The cavity flares from 55.5 to about 57.4 over the 1mm `lead_in` at each mouth
so the protector starts easily, and is nominal through the middle.

## Fastener

Two #8 wood screws per bracket (4.2mm shank, 8.3mm flat head, 82 degree
included angle), four total. The 4.5mm hole gives clearance; the countersink
sinks the head flush with the plate underside.

## Print orientation and why

Print with the band profile flat on the bed, extruded 13mm upwards. This is the
load-bearing decision in the whole design:

- the filament runs continuously around the band in every layer, so the load
  path lies along the extrusion instead of across layer bonds
- no supports and no overhangs; the cavity is a through-void in the build
  direction
- only 13mm tall, so it is quick and the ironed face is the one visible under
  the desk

Printing it as-installed instead would put the layer bonds exactly where the
arms peel outward and would make the bottom strap a 55mm overhead bridge.

## Bambu P1S settings

Slice the committed `.3mf`, or import the STL and set:

- 0.2mm layer height
- **wall loops 4**; the default of 2 is too few for a load path around the band
- gyroid infill 40%
- ironing on
- no supports, no brim (188.6mm span fits the 256mm bed with room)
- run flow calibration once; the cavity is a 0.25mm-per-side sliding fit and an
  over-extruding profile will make it tight

PETG at about 250C nozzle and 75C bed. Print with the door open and the glass
top off if fitted: in a hot chamber PETG softens in the heat break and clogs.

ASA is worth considering because the P1S is enclosed. It resists creep far
better than PETG, and this part hangs under constant load indefinitely, which is
exactly where PETG slowly deforms. Door closed, chamber warm, and ventilate.

Roughly 15g and 35 to 45 min each at 4 walls and 40% gyroid. That figure is
computed from solid volume and contour lengths, not a slice; go by what Bambu
Studio reports.

## Defects found during development

Worth recording because each one is a trap the geometry still contains.

1. **Ear was half the width it needed.** The first `ear_w` placed the screw at
   the ear tip with the head hanging off into air. Fixed by sizing the ear
   around the head plus margin on both sides.
2. **Countersink burst out through the ear tip.** `rrect` clamps `ear_r` to
   `plate_t/2`, and a rounded tip pulls the plate underside inboard, letting the
   cone escape at Y just above the underside. Fixed by keeping `ear_r` small
   (0.5) and by pushing the screw outboard so solid wall encloses the cone
   inboard. This is why `ear_r` must stay small; raising it reintroduces the
   burst.
3. **Ear gusset was eaten by the screw hole.** They overlapped completely,
   leaving a sub-1mm sliver. Removed; the stress numbers above show no rib is
   needed.
4. **Screw hole under-run cut the plate underside**, deforming the cone mouth
   into a non-circle. The clearance cylinder now over-runs the desk-side face
   only.
5. **OpenSCAD reports "Volumes: 2" for this part.** That is the through-cavity,
   not a defect. Calibrated against a plain manifold tube, which also reports 2.
6. **Two renders of identical source differ byte-wise.** Only the triangle
   emission order differs; volume, bounding box, and the triangle multiset are
   bit-identical. Harmless, slicers ignore ordering.
7. **Echo checks originally validated parameters, not geometry**, which is how
   defect 1 slipped through. The checks in the `.scad` now compute margins from
   the resulting geometry (`tip_margin_worst`, cavity breakthrough, wall left
   inboard of the cone) and will warn if a parameter change breaks any of them.

## Caveats

- The band is closed, so the protector threads in lengthwise. The cord and any
  molded plug head must pass through the 55.5 x 34.5mm cavity. Confirm before
  printing; if a plug head is wider, raise `clearance` or move to an open
  C-clip.
- PLA creeps under constant load and is not recommended here. PETG at 4 walls
  and 40%+ infill is fine; ASA is better still.
- Desk screws go into solid wood or plywood. For particle board or veneer core,
  drop to a #6 (set `screw_d` 3.8, `cs_head_d` ~7.3) so the smaller bite does
  not split the panel.

## Build

```bash
make surgeprotectorbracket.stl          # both brackets, one bed
make surgeprotectorbracket-single.stl   # one bracket only
make surgeprotectorbracket2d.dxf        # 2d drawing
```

Open the `.scad` in the OpenSCAD GUI to see the ghosted protector and desk for a
fit check; that background geometry is excluded from exports.

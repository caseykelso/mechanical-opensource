# Overview
This repo contains my opensource mechanical designs posted on printables and elsewhere.

## Ubuntu 24.04
```bash
sudo apt-get install inkscape openscad build-essential
```


# License

# Inventory
* Tripp-lite surge protector mounting brackets for under desk or wall mounting.

## Surge Protector Under-Desk Brackets
Two brackets clamp around a Tripp Lite surge protector body and screw to the
underside of the desk via ears on the top plate.

```bash
make surgeprotectorbracket.stl          # both brackets, one bed
make surgeprotectorbracket-single.stl   # one bracket only
make surgeprotectorbracket2d.dxf        # 2d drawing
```

All design details, the verified geometry, the Bambu P1S print settings and the
fit history live in [SURGEPROTECTOR.md](SURGEPROTECTOR.md). Read that before
printing. The sliceable Bambu Studio project is `surge_protector_bracket.3mf`.

Fit and screw size are parameters at the top of
`surge_protector_bracket.scad`; edit those rather than the geometry. Open the
file in the OpenSCAD GUI to see a ghosted protector and desk for a fit check,
that background geometry is excluded from the STL.

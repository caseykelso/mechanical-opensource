breakerplate2d: .FORCE
	inkscape --file=3d_titleblock_breakerplates.svg --export-pdf=1.pdf
	inkscape --file=2d_titleblock_breakerplate_1.svg --export-pdf=2.pdf
	inkscape --file=2d_titleblock_breakerplate_2.svg --export-pdf=3.pdf
	pdftk 1.pdf 2.pdf 3.pdf cat output kelso_breakerplates_drawings.pdf
	rm 1.pdf 2.pdf 3.pdf

batterymonitorpanel.stl: .FORCE
	openscad  battery_monitor_panel.scad --o battery_monitor_panel.stl

solarbreakerpanel.stl: .FORCE
	openscad  solar_breaker_panel.scad --o solar_breaker_panel.stl

surgeprotectorbracket.stl: .FORCE
	openscad  surge_protector_bracket.scad --o surge_protector_bracket.stl -D 'show_context=false'

surgeprotectorbracket-single.stl: .FORCE
	openscad  surge_protector_bracket.scad --o surge_protector_bracket_single.stl -D 'layout_count=1' -D 'show_context=false'

surgeprotectorbracket2d.dxf: .FORCE
	openscad  surge_protector_bracket.scad --o surge_protector_bracket.dxf -D 'make_2d=true' -D 'show_context=false'

.FORCE:

SURGE_DIR = designs/tripp-lite-surge-protector-brackets
SURGE_SCAD = $(SURGE_DIR)/surge_protector_bracket.scad

all: surge

surge: surgeprotectorbracket.stl surgeprotectorbracket-single.stl surgeprotectorbracket2d.dxf

surgeprotectorbracket.stl: .FORCE
	openscad $(SURGE_SCAD) --o $(SURGE_DIR)/surge_protector_bracket.stl -D 'show_context=false'

surgeprotectorbracket-single.stl: .FORCE
	openscad $(SURGE_SCAD) --o $(SURGE_DIR)/surge_protector_bracket_single.stl -D 'layout_count=1' -D 'show_context=false'

surgeprotectorbracket2d.dxf: .FORCE
	openscad $(SURGE_SCAD) --o $(SURGE_DIR)/surge_protector_bracket.dxf -D 'make_2d=true' -D 'show_context=false'

.PHONY: all surge

.FORCE:

projects = parallax_hblank parallax_tile
configurations = release
build_directory = build
default_target = all

compile_options = -Werror -Weverything
fix_options = --pad-value 0 --validate

parallax_hblank_compile_options = -Iparallax/src -Iparallax/resources
parallax_hblank_link_options = --dmg --tiny
parallax_hblank_sources = $(addprefix parallax/src/,main.rgbasm sample_hblank.rgbasm)
parallax_hblank_prerequisites = $(addprefix parallax/resources/,astronaut.chr ship.chr ship_parallax.chr)

parallax_tile_compile_options = -Iparallax/src -Iparallax/resources
parallax_tile_link_options = --dmg --tiny
parallax_tile_sources = $(addprefix parallax/src/,main.rgbasm sample_tile.rgbasm)
parallax_tile_prerequisites = $(addprefix parallax/resources/,astronaut.chr moon.chr)

$(RESOURCES_DIR)/%.png: $(ASSETS_DIR)/%.aseprite | $$(@D)/
	@$(ASEPRITE) --batch $< --save-as $@

include gbbs.mk


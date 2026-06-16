.SECONDEXPANSION:

################################################################################
# Global
################################################################################

projects = parallax_hblank parallax_tile
configurations = release
build_directory = build
default_target = all

compile_options = -Werror -Weverything
fix_options = --pad-value 0 --validate

##############################################################################
# Tools
##############################################################################

has_asset_pipeline := $(call not,$(call not,$(call has_path,aseprite))$(call not,$(call has_path,gconv)))
aseprite := $(call get_path_or_noop,aseprite)
gconv := $(call get_path_or_noop,gconv)

################################################################################
# Parallax samples
################################################################################

parallax_directory = parallax
parallax_assets_directory = $(parallax_directory)/assets
parallax_resources_directory = $(parallax_directory)/res
parallax_sources_directory = $(parallax_directory)/src

clean_parallax_hblank: clean_parallax
clean_parallax_tile: clean_parallax
clean_parallax:
	@$(if $(has_asset_pipeline),rm -rf $(parallax_resources_directory),echo Skipping resources clean)

parallax_hblank_compile_options = -I$(parallax_sources_directory) -I$(parallax_resources_directory)
parallax_hblank_link_options = --dmg --tiny
parallax_hblank_sources = $(addprefix $(parallax_sources_directory)/,main.rgbasm sample_hblank.rgbasm)
parallax_hblank_prerequisites = $(addprefix $(parallax_resources_directory)/,astronaut.chr ship.chr ship_parallax.chr)

parallax_tile_compile_options = $(parallax_hblank_compile_options)
parallax_tile_link_options = $(parallax_hblank_link_options)
parallax_tile_sources = $(addprefix parallax/src/,main.rgbasm sample_tile.rgbasm)
parallax_tile_prerequisites = $(addprefix $(parallax_resources_directory)/,astronaut.chr moon.chr)

$(parallax_resources_directory)/%.png: $(parallax_assets_directory)/%.aseprite | $$(@D)/
	@$(aseprite) --batch $< --save-as $@

parallax_gconv_common_opt = -o $(parallax_resources_directory) -spal -sti -smi -v
parallax_gconv_opt =
parallax_gconv_tilemap_list =

$(parallax_resources_directory)/astronaut.chr: parallax_gconv_opt += -hw dmg-sp -tsd "16x16s:8x16k"
$(parallax_resources_directory)/moon.chr: parallax_gconv_opt += -hw dmg-bg -trm doubles -8800
$(parallax_resources_directory)/moon.chr: parallax_gconv_tilemap_list += -tm $(parallax_resources_directory)/moon.png
$(parallax_resources_directory)/ship.chr: parallax_gconv_opt += -hw dmg-bg -trm doubles -8800 -tsd "16x16k"
$(parallax_resources_directory)/ship.chr: parallax_gconv_tilemap_list += -tm $(parallax_resources_directory)/ship.png
$(parallax_resources_directory)/ship_parallax.chr: parallax_gconv_opt += -hw dmg-bg -8800 -tsd "16x16k"

$(parallax_resources_directory)/%.chr: $(parallax_resources_directory)/%.png | $$(@D)/
	@$(gconv) $(parallax_gconv_common_opt) $(parallax_gconv_opt) -ts $< $(parallax_gconv_tilemap_list)

################################################################################
# Game Boy Build System
################################################################################

include gbbs.mk


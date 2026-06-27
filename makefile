.SECONDEXPANSION:

################################################################################
# Global
################################################################################

assets_directory = assets
resources_directory = res
common_directory = src/common

projects = parallax_hblank parallax_tile copy_brute_force copy_optimized copy_popslide
configurations = release
build_directory = build
default_target = all

compile_options = -Werror -Weverything -I$(resources_directory) -I$(common_directory)
fix_options = --pad-value 0 --validate

release_sources = $(common_directory)/main.rgbasm

##############################################################################
# Tools
##############################################################################

has_asset_pipeline = $(call not,$(call not,$(call has_path,aseprite))$(call not,$(call has_path,gconv)))
aseprite = $(call get_path_or_noop,aseprite)
gconv = $(call get_path_or_noop,gconv)

################################################################################
# Assets
################################################################################

$(resources_directory)/%.png: $(assets_directory)/%.aseprite | $$(@D)/
	@$(aseprite) --batch $< --save-as $@

gconv_common_opt = -o $(resources_directory) -spal -sti -smi -v
gconv_opt =
gconv_tilemap_list =

$(resources_directory)/astronaut.chr: gconv_opt += -hw dmg-sp -tsd "16x16s:8x16k"
$(resources_directory)/gb_pixel_art_jam_2024_xcb.chr: gconv_opt += -hw dmg-bg -trm doubles -8800 -tsd "8x8k"
$(resources_directory)/gb_pixel_art_jam_2024_xcb.chr: gconv_tilemap_list += -tm $(resources_directory)/gb_pixel_art_jam_2024_xcb.png
$(resources_directory)/moon.chr: gconv_opt += -hw dmg-bg -trm doubles -8800
$(resources_directory)/moon.chr: gconv_tilemap_list += -tm $(resources_directory)/moon.png
$(resources_directory)/ship.chr: gconv_opt += -hw dmg-bg -trm doubles -8800 -tsd "16x16k"
$(resources_directory)/ship.chr: gconv_tilemap_list += -tm $(resources_directory)/ship.png
$(resources_directory)/ship_parallax.chr: gconv_opt += -hw dmg-bg -8800 -tsd "16x16k"

$(resources_directory)/%.chr: $(resources_directory)/%.png | $$(@D)/
	@$(gconv) $(gconv_common_opt) $(gconv_opt) -ts $< $(gconv_tilemap_list)

clean: clean_assets
clean_assets:
	@$(if $(has_asset_pipeline),rm -rf $(resources_directory),echo Skipping resources clean)

################################################################################
# Parallax samples
################################################################################

parallax_sources_directory = src/parallax

parallax_hblank_compile_options = -I$(parallax_sources_directory)
parallax_hblank_link_options = --dmg --tiny
parallax_hblank_sources = $(addprefix $(parallax_sources_directory)/,sample_hblank.rgbasm)
parallax_hblank_prerequisites = $(addprefix $(resources_directory)/,astronaut.chr moon.chr)

parallax_tile_compile_options = $(parallax_hblank_compile_options)
parallax_tile_link_options = $(parallax_hblank_link_options)
parallax_tile_sources = $(addprefix $(parallax_sources_directory)/,sample_tile.rgbasm)
parallax_tile_prerequisites = $(addprefix $(resources_directory)/,astronaut.chr ship.chr ship_parallax.chr)

################################################################################
# Copy samples
################################################################################

copy_sources_directory = src/popslide

copy_compile_options = -I$(copy_sources_directory)
copy_link_options = --dmg --tiny
copy_sources = $(addprefix $(copy_sources_directory)/,sample.rgbasm)
copy_prerequisites = $(addprefix $(resources_directory)/,gb_pixel_art_jam_2024_xcb.chr)

copy_brute_force_compile_options = $(copy_compile_options) -DUSE_BRUTE_FORCE
copy_brute_force_link_options = $(copy_link_options)
copy_brute_force_sources = $(copy_sources)
copy_brute_force_prerequisites = $(copy_prerequisites)

copy_optimized_compile_options = $(copy_compile_options)  -DUSE_OPTIMIZED
copy_optimized_link_options = $(copy_link_options)
copy_optimized_sources = $(copy_sources)
copy_optimized_prerequisites = $(copy_prerequisites)

copy_popslide_compile_options = $(copy_compile_options) -DUSE_POPSLIDE
copy_popslide_link_options = $(copy_link_options)
copy_popslide_sources = $(copy_sources)
copy_popslide_prerequisites = $(copy_prerequisites)

################################################################################
# Game Boy Build System
################################################################################

include gbbs.mk


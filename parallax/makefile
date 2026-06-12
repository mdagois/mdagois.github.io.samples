.SECONDEXPANSION:

.DEFAULT_GOAL = roms

##############################################################################
# Constants
##############################################################################

TMP_DIR = tmp
PREBUILT_DIR = prebuilt
ASSETS_DIR = assets
SOURCES_DIR = src

HBLANK_SAMPLE_NAME = parallax_hblank
HBLANK_ASSETS_FILES = astronaut moon

TILE_SAMPLE_NAME = parallax_tile
TILE_ASSETS_FILES = astronaut ship ship_parallax

##############################################################################
# Inferences
##############################################################################

RESOURCES_DIR = $(TMP_DIR)/resources
ROMS_DIR = $(PREBUILT_DIR)/roms

HBLANK_ASSETS_TARGETS = $(addsuffix .chr,$(addprefix $(RESOURCES_DIR)/,$(HBLANK_ASSETS_FILES)))
TILE_ASSETS_TARGETS = $(addsuffix .chr,$(addprefix $(RESOURCES_DIR)/,$(TILE_ASSETS_FILES)))

COMMON_SOURCE_FILES = $(SOURCES_DIR)/main.rgbasm

# hblank sample
HBLANK_ROM_TARGET = $(ROMS_DIR)/$(HBLANK_SAMPLE_NAME).gb
HBLANK_ROM_MAP_FILE = $(ROMS_DIR)/$(HBLANK_SAMPLE_NAME).map
HBLANK_ROM_SYMBOLS_FILE = $(ROMS_DIR)/$(HBLANK_SAMPLE_NAME).sym
HBLANK_SOURCE_FILES = $(COMMON_SOURCE_FILES) $(SOURCES_DIR)/sample_hblank.rgbasm
HBLANK_OBJECT_FILES = $(subst $(SOURCES_DIR),$(RESOURCES_DIR),$(HBLANK_SOURCE_FILES:.rgbasm=.o))

# tile sample
TILE_ROM_TARGET = $(ROMS_DIR)/$(TILE_SAMPLE_NAME).gb
TILE_ROM_MAP_FILE = $(ROMS_DIR)/$(TILE_SAMPLE_NAME).map
TILE_ROM_SYMBOLS_FILE = $(ROMS_DIR)/$(TILE_SAMPLE_NAME).sym
TILE_SOURCE_FILES = $(COMMON_SOURCE_FILES) $(SOURCES_DIR)/sample_tile.rgbasm
TILE_OBJECT_FILES = $(subst $(SOURCES_DIR),$(RESOURCES_DIR),$(TILE_SOURCE_FILES:.rgbasm=.o))

##############################################################################
# Main rules
##############################################################################

.PHONY: assets
assets: $(HBLANK_ASSETS_TARGETS) $(TILE_ASSETS_TARGETS)

.PHONY: roms
roms: hblank tile

.PHONY: hblank tile
hblank: $(HBLANK_ROM_TARGET)
tile: $(TILE_ROM_TARGET)

.PHONY: clean
clean:
	@rm -rf $(TMP_DIR)

##############################################################################
# Helpers
##############################################################################

# rule to make directories
%/:
	@mkdir -p $(dir $@)

##############################################################################
# Assets rules
##############################################################################

$(RESOURCES_DIR)/%.png: $(ASSETS_DIR)/%.aseprite | $$(@D)/
	@aseprite --batch $< --save-as $@

GCONV_COMMON_OPT = -o $(RESOURCES_DIR) -spal -sti -smi -v
GCONV_OPT =
GCONV_TILEMAP_LIST =

$(RESOURCES_DIR)/astronaut.chr: GCONV_OPT += -hw dmg-sp -tsd "16x16s:8x16k"
$(RESOURCES_DIR)/moon.chr: GCONV_OPT += -hw dmg-bg -trm doubles -8800
$(RESOURCES_DIR)/moon.chr: GCONV_TILEMAP_LIST += $(RESOURCES_DIR)/moon.png
$(RESOURCES_DIR)/ship.chr: GCONV_OPT += -hw dmg-bg -trm doubles -8800 -tsd "16x16k"
$(RESOURCES_DIR)/ship.chr: GCONV_TILEMAP_LIST += $(RESOURCES_DIR)/ship.png
$(RESOURCES_DIR)/ship_parallax.chr: GCONV_OPT += -hw dmg-bg -8800 -tsd "16x16k"

$(RESOURCES_DIR)/%.chr: $(RESOURCES_DIR)/%.png | $$(@D)/
	@gconv $(GCONV_COMMON_OPT) $(GCONV_OPT) -ts $< $(GCONV_TILEMAP_LIST)

##############################################################################
# ROM rules
##############################################################################

$(RESOURCES_DIR)/sample_hblank.o: $(HBLANK_ASSETS_TARGETS)
$(RESOURCES_DIR)/sample_hblank.o: $(SOURCES_DIR)/sample_hblank.rgbasm $(wildcard $(SOURCES_DIR)/*.rgbinc) | $$(@D)/
	@rgbasm -Werror -Weverything -I$(RESOURCES_DIR) -I$(SOURCES_DIR) -o $@ $<

$(RESOURCES_DIR)/sample_tile.o: $(TILE_ASSETS_TARGETS)
$(RESOURCES_DIR)/sample_tile.o: $(SOURCES_DIR)/sample_tile.rgbasm $(wildcard $(SOURCES_DIR)/*.rgbinc) | $$(@D)/
	@rgbasm -Werror -Weverything -I$(RESOURCES_DIR) -I$(SOURCES_DIR) -o $@ $<

$(RESOURCES_DIR)/%.o: $(SOURCES_DIR)/%.rgbasm $(wildcard $(SOURCES_DIR)/*.rgbinc) | $$(@D)/
	@rgbasm -Werror -Weverything -I$(RESOURCES_DIR) -I$(SOURCES_DIR) -o $@ $<

$(HBLANK_ROM_TARGET): $(HBLANK_ASSETS_TARGETS)
$(HBLANK_ROM_TARGET): $(HBLANK_OBJECT_FILES) | $$(@D)/
	@rgblink --dmg --tiny --map $(HBLANK_ROM_MAP_FILE) --sym $(HBLANK_ROM_SYMBOLS_FILE) -o $@ $(HBLANK_OBJECT_FILES) && rgbfix --title $(HBLANK_SAMPLE_NAME) --pad-value 0 --validate $@

$(TILE_ROM_TARGET): $(TILE_ASSETS_TARGETS)
$(TILE_ROM_TARGET): $(TILE_OBJECT_FILES) | $$(@D)/
	@rgblink --dmg --tiny --map $(TILE_ROM_MAP_FILE) --sym $(TILE_ROM_SYMBOLS_FILE) -o $@ $(TILE_OBJECT_FILES) && rgbfix --title $(TILE_SAMPLE_NAME) --pad-value 0 --validate $@


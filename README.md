# Coding Adventures samples

Repository containing all the code of the samples presented at the [Coding Adventures](https://mdagois.github.io) website.

## Build

The build system uses [GBBS](https://github.com/mdagois/gbtools/tree/main/gbbs), so please check the prerequisites for using it.
You will need the [RGBDS](https://github.com/gbdev/rgbds) toolchain installed and in the PATH to build the samples.

Optionally, to convert the art assets, you'll need a copy of [aseprite](https://github.com/aseprite/aseprite) and a copy of [gconv](https://github.com/mdagois/gbtools).
Both must be installed and in your PATH so that the build system can detected them.
However, the repository contains pre-converted assets, and the build system will skip assets conversion if the required executables are not found in the PATH.

Once you have all the prequisites, type `make` at the root of the repository to build all samples.

## Files

| Folder        | Comments                                  |
|---------------|-------------------------------------------|
| assets        | Assets used in the samples.               |
| prebuilt      | Prebuilt ROMs of all samples.             |
| res           | Pre-converted assets.                     |
| src           | The source files of the samples.          |


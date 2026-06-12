# Parallax Samples

The parallax samples presented on the [Coding Adventures](https://mdagois.github.io/) website.

## Files

| Folder        | Comments                                  |
|---------------|-------------------------------------------|
| assets        | Assets used in the samples.               |
| prebuilt/roms | Prebuilt ROMs of both parallax samples.   |
| src           | The source files of the sample.           |
| tmp           | Pre-converted assets, for convenience.    |

## Build

Here are the prerequisites to build the samples.

- A copy of make 4.0 or later (For Windows, get it from [here](https://github.com/mdagois/gca/blob/main/bin/make.exe)).
- The [RGBDS](https://github.com/gbdev/rgbds) toolchain installed and in the PATH.
- Additionally, to convert assets
  - A copy of [aseprite](https://github.com/aseprite/aseprite) installed and in the PATH.
  - A copy of [gconv](https://github.com/mdagois/gbtools) installed and in the PATH.

Once all the required tools are installed, type `make` at the root of the directory to build the samples.
You can use `make clean` to clean the build files.


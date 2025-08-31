# wezterm.appimage

This repository provides AppImage builds of [WezTerm](https://github.com/wez/wezterm), a GPU-accelerated terminal emulator and multiplexer.

## About

WezTerm is a highly configurable terminal emulator designed for speed, modern features, and extensibility.

**This repository offers AppImages specifically built using GLIBC 2.27 (from Ubuntu 18.04),** ensuring compatibility with older Linux distributions.
Unlike the official nightly AppImage (built on newer Ubuntu), these builds aim for broader compatibility.

### Provided Versions

- **Wayland-enabled:** Matches the official WezTerm AppImage with Wayland support.
- **No Wayland:** For systems without Wayland support or where X11-only is desired.

Both versions are published for every build.

## Usage

1. Download the desired AppImage (`WezTerm*.AppImage`) from the [Releases](https://github.com/henry-hsieh/wezterm.appimage/releases) page.
2. Make the file executable:
   ```bash
   chmod +x WezTerm*.AppImage
   ```
3. Run the AppImage:
   ```bash
   ./WezTerm*.AppImage
   ```

## Building

Builds are managed by GitHub Actions using a Docker-based environment that targets Ubuntu 18.04 (GLIBC 2.27).
If you wish to build locally, follow these steps (advanced users):

1. Ensure Docker and `make` are installed.
2. Clone this repository with submodules:
   ```bash
   git clone --recurse-submodules https://github.com/henry-hsieh/wezterm.appimage.git
   cd wezterm.appimage
   ```
3. Build the Docker image (if not already present):
   ```bash
   make docker_build
   ```
4. Build the AppImage (Wayland-enabled):
   ```bash
   make -j
   ```
   To build the no-Wayland version:
   ```bash
   make -j nowayland=1
   ```
5. The resulting AppImages will be in the `wezterm/` directory.

For details, see the [build workflow](.github/workflows/build.yml).

## Contributing

Pull requests, issues, and suggestions are welcome! Please open an issue if you encounter problems or have ideas for improvements.

## License

This repository follows the license of the upstream [WezTerm project](https://github.com/wez/wezterm). See the [LICENSE](./LICENSE) file for details.

---

> Maintained by [henry-hsieh](https://github.com/henry-hsieh)

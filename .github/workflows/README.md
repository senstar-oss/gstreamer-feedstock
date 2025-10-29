# GitHub Actions Workflows

## Build Conda Packages

The `build-conda-packages.yml` workflow allows you to manually build conda packages for gstreamer without submitting a PR.

### How to Use

1. Go to the **Actions** tab in your GitHub repository
2. Click on **Build Conda Packages** in the left sidebar
3. Click the **Run workflow** button (top right)
4. Select the platform you want to build for:
   - `linux_64` - Linux x86_64
   - `linux_aarch64` - Linux ARM64
   - `linux_ppc64le` - Linux PowerPC 64-bit LE
   - `osx_64` - macOS x86_64
   - `osx_arm64` - macOS ARM64 (Apple Silicon)
   - `win_64` - Windows x86_64
   - `all` - Build for all platforms
5. Click **Run workflow**

### What Happens

The workflow will:
- Check out your code
- Set up the appropriate build environment (Docker for Linux, native for macOS/Windows)
- Build all gstreamer conda packages using the conda-forge build scripts
- Collect all built `.conda` and `.tar.bz2` packages
- Upload them as artifacts attached to the workflow run
- Create a summary showing all built packages and their sizes

### Downloading Built Packages

After the workflow completes:
1. Go to the workflow run page
2. Scroll down to the **Artifacts** section at the bottom
3. Download the artifacts for your platform (e.g., `conda-packages-linux_64_`)
4. Extract and use the conda packages as needed

### Notes

- Built packages are retained for 30 days
- The workflow uses the same build scripts as conda-forge
- Cross-platform builds (aarch64, ppc64le) use QEMU emulation on Linux
- macOS builds run on macOS runners with SDK setup
- Windows builds use cmd.exe for the build process
- The `SKIP_OUTPUT_VALIDATION` flag is set to allow building without conda-forge authorization

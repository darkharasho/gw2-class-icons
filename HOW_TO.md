# HOW TO: npm Commands

This project uses npm scripts as wrappers around shell scripts in `scripts/`.

## Quick Commands

- `npm run build:icons` - Full pipeline: SVG -> high-res PNG -> 150px/40px/20px
- `npm run convert:svg` - Convert SVG files to PNG in `wiki/high-res/`
- `npm run resize:150px` - Build `wiki/150px/` from `wiki/high-res/`
- `npm run resize:40px` - Build `wiki/40px/` from `wiki/high-res/`
- `npm run resize:20px` - Build `wiki/20px/` from `wiki/high-res/`
- `npm run convert:srgb` - Replace `#0e0e0b` with `#000000` in PNG files
- `npm run zip:wiki` - Zip each `wiki/` subfolder into `release/`
- `npm run bump:version -- [new-version]` - Update `?v=` query versions

## Prerequisites

- Node.js + npm
- `bash`
- ImageMagick (`magick`) for image conversion/resizing commands
- `zip` for archive generation
- `rg` (ripgrep) for version-bump command

Install project dependencies (if needed):

```bash
npm install
```

## Command Reference

### `npm run convert:srgb`

Runs: `bash scripts/convert-to-srgb.sh`

- Scans all `*.png` files under `wiki/`
- Replaces `#0e0e0b` with `#000000`
- Rewrites files in place

Use when you need to normalize black values across icon assets.

### `npm run convert:svg -- [source_dir]`

Runs: `bash scripts/convert-svg-to-png.sh`

- Converts `*.svg` files to `*.png` using ImageMagick
- Source defaults to `wiki/svg/`
- Destination is always `wiki/high-res/`
- Preserves basename (for example `Mesmer.svg` -> `Mesmer.png`)

Examples:

```bash
# Default source directory
npm run convert:svg

# Custom source directory (still writes to wiki/high-res)
npm run convert:svg -- wiki/svg
```

### `npm run build:icons -- [source_dir]`

Runs: `bash scripts/convert-and-resize.sh`

- Runs the full pipeline in one command:
- Convert SVG files to PNG in `wiki/high-res/`
- Resize from `wiki/high-res/` into:
- `wiki/150px/`
- `wiki/40px/`
- `wiki/20px/`
- Optional `source_dir` controls the SVG input folder

Examples:

```bash
# Default SVG source (wiki/svg)
npm run build:icons

# Custom SVG source
npm run build:icons -- wiki/svg
```

### `npm run resize:150px`

Runs: `bash scripts/resize-150px.sh`

- Reads PNG files from `wiki/high-res/`
- Resizes each image so its larger dimension is at most `150px` (aspect ratio preserved)
- Writes outputs to `wiki/150px/`

### `npm run resize:40px`

Runs: `bash scripts/resize-40px.sh`

- Reads PNG files from `wiki/high-res/`
- Resizes each image so its larger dimension is at most `40px` (aspect ratio preserved)
- Writes outputs to `wiki/40px/`

### `npm run resize:20px`

Runs: `bash scripts/resize-20px.sh`

- Reads PNG files from `wiki/high-res/`
- Resizes each image so its larger dimension is at most `20px` (aspect ratio preserved)
- Writes outputs to `wiki/20px/`

### `npm run zip:wiki`

Runs: `bash scripts/zip-wiki.sh`

- Finds each subfolder in `wiki/` (for example `20px`, `40px`, `high-res`, etc.)
- Creates one zip per subfolder in `release/`
- Output format: `release/wiki-<folder>.zip`

Use this to generate distributable archives for each wiki asset size/set.

### `npm run bump:version -- [new-version]`

Runs: `bash scripts/bump-version.sh`

- Scans files containing `?v=` query parameters
- Replaces existing `?v=` values with a new version string
- If no version is supplied, script attempts to generate one from today’s date

Examples:

```bash
# Explicit version
npm run bump:version -- 20260211-1

# Script-generated version
npm run bump:version

# Preview mode (no writes)
npm run bump:version -- --dry-run
```

## Typical Workflows

Regenerate all resized outputs from `wiki/high-res/`:

```bash
npm run resize:150px
npm run resize:40px
npm run resize:20px
```

Run full SVG -> PNG -> all resize steps:

```bash
npm run build:icons
```

Prepare release zips:

```bash
npm run zip:wiki
```

Normalize black color values before exporting:

```bash
npm run convert:srgb
```

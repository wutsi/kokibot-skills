---
name: image-magick
description: Use when resizing, cropping, converting formats, batch-processing, or reading metadata (dimensions, EXIF) for images — includes ImageMagick/magick CLI commands for Windows, Linux, and macOS.
metadata:
    categories:
        - design
---

# Image Manipulation with ImageMagick

This skill enables image processing and manipulation tasks using ImageMagick
across Windows, Linux, and macOS systems.

## Prerequisites

Check first: `magick --version`. If it's missing:

- **macOS:** `brew install imagemagick` — no elevated privileges needed, safe to run directly.
- **Linux (Debian/Ubuntu):** requires `sudo apt install imagemagick`. Do not run `sudo` commands yourself — show the
  command to the user and ask them to run it in their own terminal, then continue once they confirm ImageMagick is
  installed.
- **Linux (RHEL/CentOS):** requires `sudo yum install ImageMagick`. Do not run `sudo` commands yourself — show the
  command to the user and ask them to run it in their own terminal, then continue once they confirm ImageMagick is
  installed.
- **Windows:** download and run the [ImageMagick Windows installer](https://imagemagick.org/script/download.php#windows).
  Do not run it yourself — show the link to the user and ask them to install it, then continue once they confirm
  ImageMagick is installed.

## Quick Reference

| Operation                              | Bash                                              | PowerShell                                   |
|----------------------------------------|---------------------------------------------------|----------------------------------------------|
| Get dimensions                         | `magick identify -format "%wx%h" img.jpg`         | `& $magick identify -format "%wx%h" img.jpg` |
| Resize                                 | `magick img.jpg -resize 427x240 out.jpg`          | `& $magick img.jpg -resize 427x240 out.jpg`  |
| Convert format                         | `magick img.png out.jpg`                          | `& $magick img.png out.jpg`                  |
| Verbose metadata                       | `magick identify -verbose img.jpg`                | `& $magick identify -verbose img.jpg`        |
| Force exact size (ignore aspect ratio) | add `!` after dimensions, e.g. `-resize 427x240!` | same                                         |
| Resize to at least NxM                 | add `^`, e.g. `-resize 427x240^`                  | same                                         |

## When NOT to Use This Skill

- Vector formats (SVG, EPS) needing structural edits — use a vector tool instead
- Very large batch jobs (10k+ files) where throughput matters — consider GraphicsMagick or parallel job runners

## Usage Examples

### Resolve the `magick` executable

**Bash (Linux/macOS):**

```bash
command -v magick &> /dev/null || { echo "ImageMagick not found. Install via apt/brew."; exit 1; }
```

**PowerShell (Windows):**

```powershell
$magick = (Get-Command magick -ErrorAction SilentlyContinue)?.Source
if (-not $magick) {
    $magick = Get-ChildItem "C:\Program Files\ImageMagick-*\magick.exe" -ErrorAction SilentlyContinue |
        Select-Object -First 1 -ExpandProperty FullName
}
if (-not $magick) { throw "ImageMagick not found. Install it and/or add 'magick' to PATH." }
```

### Convert format, resize, and batch-process (Bash)

```bash
# Convert format (extension drives the output format)
magick input.png output.jpg

# Resize a single image, keeping aspect ratio
magick input.jpg -resize 427x240 output.jpg

# Batch: resize every image in a directory into thumbnails
for img in path/to/images/*; do
    filename=$(basename "$img")
    magick "$img" -resize 427x240 "path/to/output/thumb_$filename"
done

# Batch: only process images matching a target resolution
for img in path/to/images/*; do
    dimensions=$(magick identify -format "%w,%h" "$img")
    width=$(echo "$dimensions" | cut -d',' -f1)
    height=$(echo "$dimensions" | cut -d',' -f2)
    if [[ "$width" -eq 2560 || "$height" -eq 1440 ]]; then
        filename=$(basename "$img")
        magick "$img" -resize 427x240 "path/to/output/thumb_$filename"
    fi
done
```

**PowerShell equivalents:** replace `magick ...` with `& $magick ...` (using the `$magick` variable resolved above), and
replace the `for` loop with `Get-ChildItem "path/to/images/*" | ForEach-Object { ... }`, using `$_.FullName` and
`$_.Name` in place of `$img`/`$filename`.

## Guidelines

1. **Always quote file paths** — they may contain spaces
2. **PowerShell**: invoke via the resolved `$magick` variable with the `&` call operator
3. **Verify dimensions first** — check before processing to avoid unnecessary work in large batches
4. **Resize flags**: `!` forces exact dimensions (ignores aspect ratio), `^` resizes to at least NxM

## Limitations

- Large batch operations may be memory-intensive
- Some complex operations (e.g. certain format delegates) may require additional ImageMagick libraries installed

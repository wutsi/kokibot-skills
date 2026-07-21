---
name: ffmpeg
description: Use when the user asks to convert, compress, resize, trim, merge, or concatenate video/audio files, create GIFs from video, extract audio or subtitles, generate thumbnails, or prepare video for YouTube/Instagram/TikTok/Twitter.
metadata:
    categories:
        - design
---

# ffmpeg Usage

## Overview

Video and audio processing using ffmpeg: format conversion, resizing, GIF creation, audio extraction, editing,
subtitles, compression, and social-platform presets.

**Requirements:** ffmpeg >= 4.0, ffprobe (optional but recommended)

## Prerequisites

Check first: `ffmpeg -version`. If it's missing:

- **macOS:** `brew install ffmpeg` — no elevated privileges needed, safe to run directly.
- **Linux (Ubuntu/Debian):** requires `sudo apt-get install ffmpeg`. Do not run `sudo` commands yourself — show the
  command to the user and ask them to run it in their own terminal, then continue once they confirm ffmpeg is
  installed.
- **Windows (Chocolatey):** `choco install ffmpeg` requires an elevated (Administrator) PowerShell session. Do not
  run it yourself — show the command to the user and ask them to run it in an Administrator terminal, then continue
  once they confirm ffmpeg is installed.

## Command Reference

### 1. Format Conversion

**MP4 to WebM:**

```bash
ffmpeg -i input.mp4 -c:v libvpx-vp9 -crf 30 -b:v 0 -c:a libopus output.webm
```

**MOV to MP4:**

```bash
ffmpeg -i input.mov -c:v libx264 -c:a aac -strict experimental output.mp4
```

**Any to MP4 (universal compatibility):**

```bash
ffmpeg -i input.* -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k output.mp4
```

### 2. Resolution Adjustment

**Scale to 720p:**

```bash
ffmpeg -i input.mp4 -vf scale=-2:720 -c:a copy output_720p.mp4
```

**Scale to 1080p:**

```bash
ffmpeg -i input.mp4 -vf scale=-2:1080 -c:a copy output_1080p.mp4
```

**Scale to specific width (auto height):**

```bash
ffmpeg -i input.mp4 -vf scale=1280:-2 -c:a copy output.mp4
```

**Scale with padding (letterbox):**

```bash
ffmpeg -i input.mp4 -vf "scale=1920:1080:force_original_aspect_ratio=decrease,pad=1920:1080:(ow-iw)/2:(oh-ih)/2" output.mp4
```

### 3. GIF Creation

**Basic GIF (10 fps):**

```bash
ffmpeg -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos" output.gif
```

**High-quality GIF with palette:**

```bash
# Generate palette
ffmpeg -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos,palettegen" palette.png

# Create GIF using palette
ffmpeg -i input.mp4 -i palette.png -filter_complex "fps=10,scale=480:-1:flags=lanczos[x];[x][1:v]paletteuse" output.gif
```

**GIF from specific time range:**

```bash
ffmpeg -ss 00:00:10 -t 5 -i input.mp4 -vf "fps=10,scale=480:-1:flags=lanczos,split[s0][s1];[s0]palettegen[p];[s1][p]paletteuse" output.gif
```

### 4. Audio Operations

**Extract audio to MP3:**

```bash
ffmpeg -i input.mp4 -vn -acodec libmp3lame -q:a 2 output.mp3
```

**Extract audio to WAV:**

```bash
ffmpeg -i input.mp4 -vn -acodec pcm_s16le -ar 44100 -ac 2 output.wav
```

**Convert audio format:**

```bash
ffmpeg -i input.wav -c:a aac -b:a 192k output.m4a
```

**Add background music:**

```bash
ffmpeg -i video.mp4 -i music.mp3 -c:v copy -c:a aac -map 0:v:0 -map 1:a:0 -shortest output.mp4
```

**Mix audio (overlay):**

```bash
ffmpeg -i video.mp4 -i music.mp3 -filter_complex "[0:a][1:a]amix=inputs=2:duration=first" -c:v copy output.mp4
```

### 5. Video Editing

**Trim video:**

```bash
# From 10s to 30s
ffmpeg -i input.mp4 -ss 00:00:10 -to 00:00:30 -c copy output.mp4

# Duration-based (10s starting from 5s)
ffmpeg -i input.mp4 -ss 00:00:05 -t 10 -c copy output.mp4
```

**Concatenate videos** (see Concatenation decision guide below for which method to pick):

**Method 1: Concat Protocol (Preferred - No temporary files needed)**

```bash
# For MPEG formats: .ts, .mpg, .mpeg, .mp3, .aac, etc.
ffmpeg -i "concat:file1.mp3|file2.mp3|file3.mp3" -c copy output.mp3
ffmpeg -i "concat:video1.ts|video2.ts|video3.ts" -c copy output.ts

# Works with: TS, MPEG-1, MPEG-2, MP3, AAC. Does NOT work with: MP4, MOV, MKV (use Method 2)
```

**Method 2: Concat Demuxer (For MP4, MOV, MKV)**

```bash
# Use process substitution to avoid temporary files
ffmpeg -f concat -safe 0 -i <(printf "file '%s'\n" video1.mp4 video2.mp4 video3.mp4) -c copy output.mp4

# If shell doesn't support process substitution:
printf "file '%s'\n" video1.mp4 video2.mp4 video3.mp4 > list.txt
ffmpeg -f concat -safe 0 -i list.txt -c copy output.mp4
rm list.txt
```

**Method 3: Concat Filter (When re-encoding is acceptable)**

```bash
# Use when videos have different codecs/resolutions
ffmpeg -i video1.mp4 -i video2.mp4 -i video3.mp4 \
  -filter_complex "[0:v][0:a][1:v][1:a][2:v][2:a]concat=n=3:v=1:a=1[v][a]" \
  -map "[v]" -map "[a]" output.mp4
```

**Speed up/slow down:**

```bash
# 2x speed
ffmpeg -i input.mp4 -filter:v "setpts=0.5*PTS" -an output.mp4

# 0.5x speed (slow motion)
ffmpeg -i input.mp4 -filter:v "setpts=2.0*PTS" output.mp4
```

**Rotate video:**

```bash
# 90 degrees clockwise
ffmpeg -i input.mp4 -vf "transpose=1" output.mp4

# 180 degrees
ffmpeg -i input.mp4 -vf "transpose=2,transpose=2" output.mp4
```

### 6. Subtitle Processing

**Burn subtitles into video:**

```bash
ffmpeg -i input.mp4 -vf subtitles=subtitles.srt output.mp4
```

**Add soft subtitles:**

```bash
ffmpeg -i input.mp4 -i subtitles.srt -c copy -c:s mov_text output.mp4
```

**Extract subtitles:**

```bash
ffmpeg -i input.mp4 -map 0:s:0 subtitles.srt
```

### 7. Thumbnail Extraction

**Single frame at specific time:**

```bash
ffmpeg -i input.mp4 -ss 00:00:05 -vframes 1 thumbnail.jpg
```

**Multiple thumbnails:**

```bash
# One frame every 10 seconds
ffmpeg -i input.mp4 -vf fps=1/10 thumb%04d.jpg

# First 10 frames
ffmpeg -i input.mp4 -vframes 10 frame%04d.png
```

### 8. Compression & Optimization

**Compress video (balanced):**

```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 23 -preset medium -c:a aac -b:a 128k output.mp4
```

**High compression (smaller file):**

```bash
ffmpeg -i input.mp4 -c:v libx264 -crf 28 -preset veryslow -c:a aac -b:a 96k output.mp4
```

**Compress for web:**

```bash
ffmpeg -i input.mp4 -c:v libx264 -preset medium -crf 23 -movflags +faststart -c:a aac -b:a 128k output.mp4
```

### Platform-Specific Presets

**YouTube:**

```bash
ffmpeg -i input.mp4 -c:v libx264 -preset slow -crf 18 -c:a aac -b:a 192k -pix_fmt yuv420p -movflags +faststart youtube.mp4
```

**Instagram Story (9:16, 15s max):**

```bash
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k -t 15 instagram_story.mp4
```

**Twitter/X (16:9, 2:20 max):**

```bash
ffmpeg -i input.mp4 -vf scale=1280:720 -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k -t 140 twitter.mp4
```

**TikTok (9:16, 60s max):**

```bash
ffmpeg -i input.mp4 -vf "scale=1080:1920:force_original_aspect_ratio=decrease,pad=1080:1920:(ow-iw)/2:(oh-ih)/2" -c:v libx264 -preset medium -crf 23 -c:a aac -b:a 128k -t 60 tiktok.mp4
```

### Other Common Use Cases

**Screen recording optimization:**

```bash
ffmpeg -i screen_recording.mov -c:v libx264 -preset medium -crf 23 -vf "scale=1920:-2" -c:a aac -b:a 128k optimized.mp4
```

**Batch conversion:**

```bash
for i in *.mov; do
  ffmpeg -i "$i" -c:v libx264 -crf 23 -c:a aac "${i%.mov}.mp4"
done
```

**Video from images:**

```bash
# From image sequence
ffmpeg -framerate 30 -pattern_type glob -i '*.jpg' -c:v libx264 -pix_fmt yuv420p output.mp4

# Single image to video (5 seconds)
ffmpeg -loop 1 -i image.jpg -c:v libx264 -t 5 -pix_fmt yuv420p output.mp4
```

## Concatenation: Which Method?

- `.mp3`, `.aac`, `.ts`, `.mpg`, `.mpeg` → Concat protocol (`concat:file1|file2`, no temp files)
- `.mp4`, `.mov`, `.mkv` → Concat demuxer (`-f concat -i list.txt`)
- Different codecs/resolutions → Concat filter (`-filter_complex concat=...`, re-encodes)

## Best Practices

1. **Inspect before processing:** `ffprobe -v quiet -print_format json -show_format -show_streams input.mp4`
2. **Use `-c copy` when no re-encoding is needed** (trims, remuxing) — much faster, no quality loss.
3. **Preview with `-t 10`** on a short clip before running the full command.
4. **CRF guide (libx264):** 18 = visually lossless, 23 = default/high quality, 28 = smaller/lower quality. Range 0–51.
5. **Add `-movflags +faststart`** for web-delivered video (moves metadata to the front for progressive playback).

## Common Mistakes

- **Odd dimensions crash libx264:** `scale=-1:720` can produce an odd width, causing "width/height not divisible by 2".
  Use `scale=-2:720` instead so the auto-computed dimension is always even.
- **`-y` omitted in non-interactive contexts:** Without `-y`, ffmpeg prompts to confirm overwriting an existing output
  file and hangs waiting for input that will never come. Always pass `-y` (or `-n` to fail instead of prompting) when
  running non-interactively.
- **`-ss` placement changes seek behavior:** `-ss` *before* `-i` does fast keyframe seeking (less accurate, much
  faster); `-ss` *after* `-i` does accurate frame-level seeking (slower, decodes from the start). Pick based on
  whether precision or speed matters more.
- **Unquoted filenames with spaces/globs break commands:** Always quote input/output paths (`"$file"`), especially in
  batch loops and concat list files.
- **Wrong concat method for the format:** Concat protocol only works on MPEG-TS-style streams; using it on
  `.mp4`/`.mov`/`.mkv` fails or produces corrupt output — use the concat demuxer instead (see decision guide above).
- **`-c copy` fails silently across incompatible containers/codecs:** Stream copying only works when the output
  container supports the source codec. If trimming or remuxing errors out unexpectedly, drop `-c copy` and re-encode.

## References

- FFmpeg Official Documentation: https://ffmpeg.org/documentation.html
- FFmpeg Wiki: https://trac.ffmpeg.org/wiki
- Supported Codecs: https://ffmpeg.org/ffmpeg-codecs.html
- Filter Documentation: https://ffmpeg.org/ffmpeg-filters.html

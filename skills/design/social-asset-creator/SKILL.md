---
name: social-asset-creator
description: Automates the creation of high-quality, platform-specific, brand-compliant images and multi-slide carousels across Facebook, Instagram, WhatsApp, TikTok, LinkedIn, and YouTube by executing Playwright CLI commands that output a plain-text summary list containing the absolute full file paths of created assets.
metadata:
    categories:
        - design
---

# Skill Instruction: Social Media Post & Carousel Image Generation

## Overview

This skill automates the creation of high-quality, platform-specific social media post images and multi-slide carousels.
By reading a central design system, staging provided background images into the local execution workspace, injecting
user-provided copy into HTML slide configurations based on platform specifications, and executing the renders via the
**Playwright CLI (`playwright-cli`)**, this skill outputs a plain-text list containing the absolute full file system
paths of all
generated visual assets.

---

## Output Contract & Location Reporting

The primary deliverable of this skill is a plain-text summary listing the absolute full paths to all rendered image
assets.

Downstream agent scripts and platform wrappers must parse `stdout` for the printed file path location to locate,
inspect, or dispatch the rendered files.

---

## When to Use This Skill

Trigger this skill whenever you need to generate high-fidelity, text-on-image marketing assets or multi-page swipeable
carousels programmatically while preserving strict brand identity across our supported social channels.

* **Multi-Platform Visual Distribution:** When the same copy and background asset need to be adapted perfectly into
  multiple aspect ratios simultaneously without manual cropping.
* **Multi-Slide Carousel Content:** For multi-page visual essays, step-by-step tutorials, slide decks, or episodic
  promotional cards (specifically for LinkedIn Document posts or Instagram Carousels).
* **Brand Asset Compliance Protection:** When rendering graphics at scale where traditional generative AI image
  generation models fail due to layout hallucination, misspelled text overlays, or non-compliant font usage.

---

## Input Parameters

| Parameter                    | Type   | Required? | Allowed Values / Description                                                                                     |
|:-----------------------------|:-------|:----------|:-----------------------------------------------------------------------------------------------------------------|
| **Target platform**          | String | **Yes**   | `facebook` \| `instagram` \| `whatsapp` \| `tiktok` \| `linkedin` \| `youtube`                                   |
| **Placement type**           | String | **Yes**   | `feed` \| `story` \| `reel_cover` \| `link_preview` \| `carousel_slide` \| `community_post` \| `video_thumbnail` |
| **Slides Data**              | Array  | **Yes**   | An array of objects containing content for each slide. Supports single-item arrays for static posts.             |
| *↳ Hook*                     | String | **Yes**   | The primary attention-grabbing text (e.g., "Stop Scrolling!"). Required for at least Slide 1.                    |
| *↳ Headline*                 | String | No        | The main title or value proposition of the specific slide.                                                       |
| *↳ Sub Head*                 | String | No        | Supporting text or secondary details providing context for the specific slide.                                   |
| *↳ CTA*                      | String | No        | Call To Action text (typically reserved for the final slide).                                                    |
| *↳ Path to background image* | String | No        | Local relative/absolute path (e.g., `./images/bg.png`) or remote web URL to the background image asset.          |

---

## Validation & Conflict Resolution

Before building the asset structure, cross-reference the `Target platform` and `Placement type` with the specifications
matrix below.

* If a requested combination is **invalid** (e.g., TikTok `link_preview`), default to the `feed` specification for that
  platform.
* If multiple items are passed into the **Slides Data** array for a placement that does not support carousels, default
  to generating a single static image using *only* the first data object in the array.

---

## Social Media Post Specifications

The container bounds and dimensions must be dynamically determined using the matrix below.

> **Important (Safe Zones):** For all vertical video formats (`story` and `reel_cover`), the template must center text
> and critical visual assets within the inner 1080 x 1350 px area. This ensures vital information isn't blocked by
> native
> social media app UI elements.

### 1. Instagram (`instagram`)

* **`feed` (Portrait / Carousel):** 1080 x 1350 px (4:5 aspect ratio) — *Recommended for Carousels*
* **`feed` (Square / Carousel):** 1080 x 1080 px (1:1 aspect ratio)
* **`story` / `reel_cover`:** 1080 x 1920 px (9:16 aspect ratio)

### 2. Facebook (`facebook`)

* **`feed` (Portrait / Carousel):** 1080 x 1350 px (4:5 aspect ratio)
* **`feed` (Square / Carousel):** 1080 x 1080 px (1:1 aspect ratio)
* **`link_preview`:** 1200 x 630 px (1.91:1 landscape aspect ratio)
* **`story`:** 1080 x 1920 px (9:16 aspect ratio)

### 3. TikTok (`tiktok`)

* **`feed` / `reel_cover`:** 1080 x 1920 px (9:16 aspect ratio)

### 4. WhatsApp (`whatsapp`)

* **`feed`:** 1080 x 1080 px (1:1 aspect ratio)
* **`story`:** 1080 x 1920 px (9:16 aspect ratio)

### 5. LinkedIn (`linkedin`)

* **`feed` (Portrait / Text Post):** 1080 x 1350 px (4:5 aspect ratio)
* **`carousel_slide` (Document Post):** 1080 x 1080 px (1:1 aspect ratio) — *Standard square for multi-page slide
  documents*
* **`link_preview`:** 1200 x 628 px (1.91:1 landscape aspect ratio)

### 6. YouTube (`youtube`)

* **`video_thumbnail`:** 1280 x 720 px (16:9 aspect ratio)
* **`community_post`:** 1080 x 1080 px (1:1 aspect ratio)
* **`reel_cover`:** 1080 x 1920 px (9:16 aspect ratio)

---

## Typography & Font Scale Guidelines

To stand out on small mobile feeds, typography must be aggressively scaled, hyper-legible, and weighted. Traditional
document sizes are strictly forbidden. Use the following baseline hierarchy, adjusting via fluid CSS `vw`/`vh` units or
specific target pixels based on a baseline canvas height of **1350px**:

* **Hook (Pattern Interrupter):** **`72px - 96px`** (`font-weight: 800` or `900`). Must be highly stylized, uppercase,
  or use high-contrast background badges to visually anchor attention instantly.
* **Headline (Core Value Prop):** **`64px - 80px`** (`font-weight: 700`). Clear, bold, and heavily structured.
* **Sub Head (Supporting Detail):** **`36px - 48px`** (`font-weight: 500` or `400`). Sized layout-defensively to handle
  up to 2-3 lines of explanatory copy.
* **CTA (Call to Action Button):** **`32px - 40px`** (`font-weight: 700`). Housed inside a defined, pill-shaped or
  rounded button layout with generous padding (`24px 48px`).

> **Scale Factor Note:** If the target resolution is scaled lower (e.g., a 720p YouTube Thumbnail), scale all absolute
> pixel ranges down proportionally using a multiplier (`Target Height / 1350`) to keep the visual layout balance.

---

## Execution Protocol

Execute these actions in strict sequential order. Do not loop or re-draft code once generated.

### Step 0: Environment Pre-Check (Dependency Validation)

Before generating templates or staging assets, verify that playwright-cli is installed and accessible in the system
environment. If the binary is missing, immediately halt execution and print an explicit error message.

```markdown
if ! command -v playwright-cli &> /dev/null; then
echo "Error: playwright-cli is not installed or not found in PATH." >&2
echo "Please install Playwright CLI before running this skill (e.g., npm install -g @playwright/cli@latest)." >&2
exit 1
fi
```

### Step 1: Read Design System

* Access and parse the central design system configuration file.
* Extract authorized brand assets including font families, font weights, primary/secondary color palettes, and global
  padding rules.

### Step 2: Generate the HTML

For each slide in the slides data array, generate a self-contained HTML file (
`output/asset_[UniqueId]/temp_slide_N.html`)
incorporating the required platform dimensions, background styles, and injected text content (hook, headline, subHead,
cta).

The HTML structure for each slide should follow this template:

```html
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <style>
        ...
    </style>
</head>
<body>
<div class="slide" style="background-image: url('[background-image-path]');....">
    <div class="overlay">
        <div class="hook">[hook]</div>
        <div class="headline">[headline]</div>
        <div class="subhead">[subhead]</div>
        <div class="cta">[cta]</div>
    </div>
</div>
</body>
</html>
```

### Step 3: Output Execution Payload & Return Asset Location

* Run sequence of `playwright-cli` commands to open each slide template, resize the viewport to the target
  specification,
  capture a pristine PNG screenshot, and close the session.
* Log the absolute full file path location of the created asset(s) to stdout.

```bash
# 1. Open the first slide template file in Playwright CLI
playwright-cli open file://$(pwd)/output/asset_[UniqueId]/temp_slide_1.html

# 2. Resize viewport to match target platform dimensions (e.g., width x height)
playwright-cli resize [Insert Evaluated Width] [Insert Evaluated Height]

# 3. Take screenshot and save to final absolute asset path
playwright-cli screenshot --filename=$(pwd)/output/asset_[UniqueId]/slide_1.png

# 4. Close session when finished or move to next tab/file
playwright-cli close

# Repeat for subsequent slides as necessary, then clean up temporary HTML files:
rm $(pwd)/output/asset_[UniqueId]/temp_slide_*.html

# Output plain text summary list containing absolute full image paths
echo "n asset(s) generated:"
echo "- $(pwd)/output/asset_[UniqueId]/slide_1.png"
```

---
name: social-asset-creator
description: Automates the creation of high-quality, platform-specific, brand-compliant images and multi-slide carousels across Facebook, Instagram, WhatsApp, TikTok, LinkedIn, and YouTube by generating self-contained Node.js Playwright scripts.
metadata:
    categories:
        - design
---

# Skill Instruction: Social Media Post & Carousel Image Generation

## Overview

This skill automates the creation of high-quality, platform-specific social media post images and multi-slide carousels.
By reading a central design system, dynamically injecting user-provided copy and assets into HTML slide structures based
on the platform specifications, and wrapping them in an executable Node.js loop, this skill outputs an automated
multi-frame rendering blueprint ready for immediate system execution.

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
| *↳ Path to background image* | String | No        | Local file path (`file://`) or URL to the background image asset for the specific slide.                         |

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
> and critical visual assets within the inner 1080 x 1350 px area. This ensures vital information isn't blocked by native
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

### Step 1: Read Design System

* Access and parse the central design system configuration file.
* Extract authorized brand assets including font families, font weights, primary/secondary color palettes, and global
  padding rules.

### Step 2: Compile Carousel Slides HTML & CSS Matrix

* Loop through the **Slides Data** array. For *each individual slide data object*, dynamically compile a complete,
  standalone HTML string structure.
* **Typography & Content Mapping:** Apply the specific scales outlined in **Typography & Font Scale Guidelines**. If an
  optional parameter is absent or empty, completely exclude it from that specific slide's DOM layout so it occupies zero
  space.
* **Safe Zone Enforcement:** For 9:16 formats, wrap all copy within an overlay container structurally constrained to the
  central 1080 x 1350 px bounding box.
* **Defensive Layout Constraints & Images:** Apply `word-wrap: break-word;` and `overflow-wrap: break-word;` to all text
  boxes. Force layout-safe `-webkit-line-clamp` boundaries. Set `box-sizing: border-box;` globally. Apply the background
  image using `background-size: cover;` and `background-position: center;`. If a local system paths utilize a local
  filesystem structure, ensure it uses the valid absolute URL pattern (`file://`).

### Step 3: Integrate into Multi-Page Playwright Script

* Embed the resulting array of HTML slide strings directly into a structural execution loop within an executable Node.js
  Playwright script template.
* Dynamically inject the calculated pixel `width` and `height` properties into the context's browser viewport
  configurations.
* Enforce a `networkidle` load event state update inside the loop immediately after setting each slide's content to
  ensure all web-fonts and background graphics finish loading prior to taking the distinct frame snapshot.

### Step 4: Output Execution Payload

* Deliver the output by generating the exact JavaScript code block structure detailed below. Do not append
  conversational chat text, instructions, or follow-up questions after outputting this block. Stop generating
  immediately.

```javascript
const { chromium } = require('playwright');
const fs = require('fs');
const path = require('path');

(async () => {
  // Target Specification: [Insert Target Platform] - [Insert Placement Type]
  const width = [Insert Evaluated Width];
  const height = [Insert Evaluated Height];
  const uniqueId = '[UniqueId]';

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width, height } });
  const page = await context.newPage();

  // Array of self-contained compiled HTML slides generated from input parameters
  const slides = [
    `<!DOCTYPE html><html><head><style>/* Slide 1 CSS */</style></head><body><!-- Slide 1 Content --></body></html>`
  ];

  // Ensure target output directory space exists
  const outputDir = path.resolve('output', `asset_${uniqueId}`);
  if (!fs.existsSync(outputDir)) {
    fs.mkdirSync(outputDir, { recursive: true });
  }

  // Sequentially process and capture every slide image asset in the payload
  for (let i = 0; i < slides.length; i++) {
    const outputPath = path.join(outputDir, `slide_${i + 1}.png`);

    await page.setContent(slides[i]);
    await page.waitForLoadState('networkidle');
    await page.screenshot({ path: outputPath, type: 'png' });
  }

  await browser.close();

  // Unified application output logs
  if (slides.length === 1) {
    console.log(`Asset generated: ${path.join(outputDir, 'slide_1.png')}`);
  } else {
    console.log(`Carousel generated: ${slides.length} slides saved to ${outputDir}`);
  }
})();

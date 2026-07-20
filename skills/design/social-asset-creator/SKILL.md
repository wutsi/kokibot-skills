---
name: social-asset-creator
description: Automates the creation of high-quality, platform-specific, brand-compliant images across Facebook, Instagram, WhatsApp, TikTok, LinkedIn, and YouTube using HTML/CSS templates rendered via a headless browser.
metadata:
    categories:
        - design
---

# Skill Instruction: Social Media Post Image Generation

## Overview

This skill automates the creation of high-quality, platform-specific social media post images. By reading a central
design system, dynamically injecting user-provided copy and assets into an HTML string based on the platform
specifications, and wrapping it in an executable Node.js script, this skill outputs a fully automated rendering
blueprint ready for immediate system execution.

---

## When to Use This Skill

Trigger this skill whenever you need to generate high-fidelity, text-on-image marketing assets programmatically while
preserving strict brand identity.

* **Multi-Platform Visual Distribution:** When the same copy and background asset need to be adapted perfectly into
  multiple aspect ratios simultaneously without manual cropping.
* **Text-Heavy Image Creative Creation:** For programmatic ad graphics, content hooks, promotional graphics, and
  typographic quote cards where pixel-perfect font alignment and dynamic word wrapping are required.
* **Brand Asset Compliance Protection:** When rendering graphics at scale where traditional generative AI image
  generation models fail due to layout hallucination, misspelled text overlays, or non-compliant font usage.

---

## Input Parameters

| Parameter                    | Type   | Required? | Allowed Values / Description                                                                                     |
|:-----------------------------|:-------|:----------|:-----------------------------------------------------------------------------------------------------------------|
| **Target platform**          | String | **Yes**   | `facebook` \| `instagram` \| `whatsapp` \| `tiktok` \| `linkedin` \| `youtube`                                   |
| **Placement type**           | String | **Yes**   | `feed` \| `story` \| `reel_cover` \| `link_preview` \| `carousel_slide` \| `community_post` \| `video_thumbnail` |
| **Hook**                     | String | **Yes**   | The primary attention-grabbing text (e.g., "Stop Scrolling!").                                                   |
| **Headline**                 | String | No        | The main title or value proposition of the post.                                                                 |
| **Sub Head**                 | String | No        | Supporting text or secondary details providing context.                                                          |
| **CTA**                      | String | No        | Call To Action text (e.g., "Shop Now", "Link in Bio").                                                           |
| **Path to background image** | String | No        | Local file path or URL to the background image asset.                                                            |

---

## Validation & Conflict Resolution

Before building the asset structure, cross-reference the `Target platform` and `Placement type` with the specifications
matrix below.

* If a requested combination is **invalid** (e.g., TikTok `link_preview`), default to the `feed` specification for that
  platform.
* If the platform does not have a designated `feed` specification, default to a standard square layout (1080 x 1080 px).

---

## Social Media Post Specifications

The container bounds and dimensions must be dynamically determined using the matrix below.

> **Important (Safe Zones):** For all vertical video formats (`story` and `reel_cover`), the template must center text
> and critical visual assets within the inner 1080 x 1350 px area. This ensures vital information isn't blocked by
> native
> social media app UI elements (like profiles, captions, or interactable buttons).

### 1. Instagram (`instagram`)

* **`feed` (Portrait):** 1080 x 1350 px (4:5 aspect ratio) — *Recommended*
* **`feed` (Square):** 1080 x 1080 px (1:1 aspect ratio)
* **`story` / `reel_cover`:** 1080 x 1920 px (9:16 aspect ratio)

### 2. Facebook (`facebook`)

* **`feed` (Portrait):** 1080 x 1350 px (4:5 aspect ratio)
* **`feed` (Square):** 1080 x 1080 px (1:1 aspect ratio)
* **`link_preview`:** 1200 x 630 px (1.91:1 landscape aspect ratio)
* **`story`:** 1080 x 1920 px (9:16 aspect ratio)

### 3. TikTok (`tiktok`)

* **`feed` / `reel_cover`:** 1080 x 1920 px (9:16 aspect ratio)

### 4. WhatsApp (`whatsapp`)

* **`feed`:** 1080 x 1080 px (1:1 aspect ratio)
* **`story`:** 1080 x 1920 px (9:16 aspect ratio)

### 5. LinkedIn (`linkedin`)

* **`feed` (Portrait / Text Post):** 1080 x 1350 px (4:5 aspect ratio) — *Takes up max mobile feed estate*
* **`carousel_slide` (Document Post):** 1080 x 1080 px (1:1 aspect ratio) — *Standard square for multi-page slide
  documents*
* **`link_preview`:** 1200 x 628 px (1.91:1 landscape aspect ratio) — *Thumbnail for shared articles*

### 6. YouTube (`youtube`)

* **`video_thumbnail`:** 1280 x 720 px (16:9 aspect ratio) — *Standard landscape video thumbnail*
* **`community_post`:** 1080 x 1080 px (1:1 aspect ratio) — *Image uploads for the community activity tab*
* **`reel_cover` (Shorts Thumbnail):** 1080 x 1920 px (9:16 aspect ratio)

---

## Typography & Font Scale Guidelines

To stand out on small mobile feeds, typography must be aggressively scaled, hyper-legible, and weighted. Traditional
document sizes (e.g., 16px, 24px) are strictly forbidden. Use the following baseline hierarchy, adjusting via fluid CSS
`vw`/`vh` units or specific target pixels based on a baseline canvas height of **1350px**:

* **Hook (Pattern Interrupter):** **`72px - 96px`** (`font-weight: 800` or `900`). Must be highly stylized, uppercase,
  or use high-contrast background badges to visually anchor the user's attention instantly.
* **Headline (Core Value Prop):** **`64px - 80px`** (`font-weight: 700`). Clear, bold, and heavily structured. This
  block drives the main content delivery.
* **Sub Head (Supporting Detail):** **`36px - 48px`** (`font-weight: 500` or `400`). Sized layout-defensively to handle
  up to 2-3 lines of explanatory copy without losing scanning hierarchy.
* **CTA (Call to Action Button):** **`32px - 40px`** (`font-weight: 700`). Housed inside a defined, pill-shaped or
  rounded button layout with generous padding (`24px 48px`) to mimic an interactive element.

> **Scale Factor Note:** If the target resolution is scaled lower (e.g., a 720p YouTube Thumbnail), scale all absolute
> pixel ranges down proportionally using a multiplier (e.g., `Target Height / 1350`) to keep the exact visual layout
> balance.

---

## Execution Protocol

Execute these actions in strict sequential order. Do not loop or re-draft code once generated.

### Step 1: Read Design System

* Access and parse the central design system configuration file.
* Extract authorized brand assets including font families, font weights, primary/secondary color palettes, and global
  padding rules to ensure absolute visual brand compliance.

### Step 2: Compile the Asset HTML & CSS

* Dynamically compile a single self-contained HTML payload containing all structure and explicit inline CSS.

* **Typography Calculations:** Map the text variables to the precise scales outlined in **Typography & Font Scale
  Guidelines**, translating the pixel boundaries into layout-safe styles using fluid ranges or relative scale math.

* **Strict Content Mapping (No Assumptions):** Map the provided values (`Hook`, `Headline`, `Sub Head`, `CTA`,
  `Background Image`) to their respective text blocks. Do **not** generate placeholder text or hallucinate content for
  omitted optional parameters. Completely hide or exclude empty parameter elements from the DOM so they occupy zero
  space.

* **Image & Canvas Asset Handling:** Set `box-sizing: border-box;` globally on all elements. Ensure parent canvas
  containers strictly enforce `overflow: hidden;`. Apply the `Path to background image` asset as a CSS background
  property configured with `background-size: cover;` and `background-position: center;`. If a local file path is
  provided, ensure it is formatted as an absolute filesystem path utilizing the valid URL file structure (`file://`).

* **Safe Zone Enforcement:** For 9:16 formats (`story`, `reel_cover`), wrap all copy within an overlay container
  structurally constrained to the central 1080 x 1350 px visual bounding box using padding or flex alignment rules.

* **Defensive Layout Constraints:** Apply `word-wrap: break-word;` and `overflow-wrap: break-word;` to all text boxes.
  Force dynamic truncation using line-clamping CSS (e.g., `-webkit-line-clamp: 3;`) on headers to guarantee text cannot
  break or expand past the canvas boundaries. Ensure `box-sizing: border-box;` is applied globally.

### Step 3: Integrate into Playwright Node.js Script

* Embed the complete HTML code generated in Step 2 directly into an executable Node.js Playwright script template.
* Dynamically inject the calculated pixel `width` and `height` properties extracted from the specifications matrix
  directly into the script's browser viewport configuration object.
* Configure a defensive network lifecycle event (`networkidle`) right after setting page content to ensure external
  brand web-fonts or network images load fully prior to snapshot creation.

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
  const outputPath = 'output/asset_[UniqueId].png';

  const browser = await chromium.launch({ headless: true });
  const context = await browser.newContext({ viewport: { width, height } });
  const page = await context.newPage();

  // Self-contained compiled HTML payload string
  const htmlContent = `
  <!DOCTYPE html>
  <html>
  <head>
    <style>
      /* Compiled brand system CSS goes here */
    </style>
  </head>
  <body>
    <!-- Compliant structured visual content goes here -->
  </body>
  </html>
  `;

  await page.setContent(htmlContent);
  await page.waitForLoadState('networkidle');

  // Ensure target output directory exists
  const dir = path.dirname(outputPath);
  if (!fs.existsSync(dir)) {
    fs.mkdirSync(dir, { recursive: true });
  }

  await page.screenshot({ path: outputPath, type: 'png' });
  await browser.close();

  console.log(`Asset generated: ${outputPath}`);
})();

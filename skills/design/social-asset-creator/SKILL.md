---
name: social-asset-creator
description: Automates the creation of high-quality, platform-specific, brand-compliant images using HTML/CSS templates rendered via a headless browser.
metadata:
    categories:
        - design
---

# Skill Instruction: Social Media Post Image Generation

## Overview

This skill automates the creation of high-quality, platform-specific social media post images. By reading a central
design system, dynamically injecting user-provided copy and assets into an HTML template based on the platform and
placement type, and rendering it via a headless browser, this skill ensures perfectly scaled, on-brand visual assets
ready for publication.

---

## When to Use This Skill

Trigger this skill whenever you need to generate high-fidelity, text-on-image marketing assets programmatically while
preserving strict brand identity.

* **Multi-Platform Visual Distribution:** When the same copy and background asset need to be adapted perfectly into
  multiple aspect ratios (e.g., matching Instagram Stories, LinkedIn Feed posts, and YouTube Community updates
  simultaneously) without manual cropping.
* **Text-Heavy Image Creative Creation:** For programmatic ad graphics, content hooks, promotional graphics, and
  typographic quote cards where pixel-perfect font alignment and dynamic word wrapping are required.
* **Brand Asset Compliance Protection:** When rendering graphics at scale where traditional generative AI image
  generation models (like DALL-E or Midjourney) fail due to layout hallucination, misspelled text overlays, or
  non-compliant font usage.

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

Before rendering, cross-reference the `Target platform` and `Placement type` with the specifications matrix below.

* If a requested combination is **invalid** (e.g., TikTok `link_preview`), the system must default to the `feed`
  specification for that platform.
* If the platform does not have a `feed` specification, default to a standard square layout (1080 x 1080 px).

---

## Social Media Post Specifications

The container bounds and dimensions must be dynamically determined using the matrix below.

> **Important (Safe Zones):** For all vertical video formats (`story` and `reel_cover`), the HTML/CSS template must
> center text and critical visual assets within the inner 1080 x 1350 px area. This ensures vital information isn't
> blocked by native social media app UI elements (like profiles, captions, or interactable buttons).

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

## Execution Protocol

Execute these actions in strict sequential order:

1. **Read Design System**
    * Access and parse the central design system configuration file.
    * Extract authorized brand assets including font families, font weights, primary/secondary color palettes, and
      global padding rules to ensure absolute visual brand compliance.

2. **Generate the Post in HTML (with Defensive Layouts & Overflow Protection)**
    * Dynamically compile a self-contained HTML/CSS file.
    * Determine the container's width and height based on the evaluated combination of `Target platform` and
      `Placement type`.
    * Inject the extracted brand typography and layout variables from Step 1.
    * **Strict Content Mapping (No Assumptions):** Map the provided values (`Hook`, `Headline`, `Sub Head`, `CTA`,
      `Background Image`) to their respective text blocks.
        * Do **not** generate placeholder text, imply, or hallucinate content for `Headline`, `Sub Head`, `CTA` or
          `Background Image` if they are omitted from the input parameters.
        * If an optional parameter (`Headline`, `Sub Head`, or `CTA`) is absent or empty, completely exclude or
          conditionally hide its corresponding HTML element box from the DOM template so it occupies zero space in the
          visual layout.
    * Map the `Hook`, `Headline`, `Sub Head`, and `CTA` values to their respective text blocks.
    * **Safe Zone Enforcement:** For 9:16 formats (`story`, `reel_cover`), wrap all copy and core text elements within a
      nested overlay container structurally constrained to the central 1080 x 1350 px visual bounding box (e.g., via
      padding or dedicated flex-containers) to strictly avoid UI collision.
    * **Text Overflow Handling:** Enforce defensive typography styling to prevent clipping or canvas breakages when long
      copy is passed:
        * Apply `word-wrap: break-word;` and `overflow-wrap: break-word;` to all text containers.
        * Use `clamp()` or fluid typography rules based on container height to scale font sizes dynamically.
        * For explicit headline or hook blocks where layout boundaries are rigid, enforce standard truncation mechanics
          using line-clamping CSS properties (e.g.,
          `-webkit-line-clamp: 3; display: -webkit-box; -webkit-box-orient: vertical; overflow: hidden;`).
    * **Image & Canvas Asset Handling:** Set `box-sizing: border-box;` globally on all elements. Ensure parent canvas
      containers strictly enforce `overflow: hidden;` to catch any rogue element drift. Apply the
      `Path to background image` asset as a CSS background property configured with `background-size: cover;` and
      `background-position: center;` to avoid visual distortion.

3. **Use Playwright to Take a Screenshot**
    * Launch a headless browser instance using **Playwright**.
    * Load the compiled HTML file, pausing briefly to guarantee all external fonts, weights, and high-resolution
      background assets are completely loaded.
    * Take a high-fidelity screenshot targeting the primary container element bounding box.
    * Save the final image format file into the project's designated media directory.

4. **Return System Message**
    * Upon successful image generation, return the final path response exactly matching this structure: "Asset
      generated: [image_full_path]"

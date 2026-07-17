---
name: "social-media-content-generator"
description: "Ingests a machine-readable DESIGN.md, processes an immutable text content payload with optional slide-specific background images, and programmatically generates pixel-perfect, consistently branded social media graphics using Playwright."
keywords: 
  - social media automation
  - playwright
  - browser automation
  - image generator
  - automation pipeline
  - content generation
  - background images
---

# Skill: social-media-content-generator

This skill acts as the visual renderer in an automated content pipeline. It programmatically parses a design system contract (`DESIGN.md`), reads raw text post content payloads, enforces a non-negotiable validation phase, maps customized social typography scales, and compiles self-contained HTML canvases. It then invokes **Playwright** to take pixel-perfect, high-fidelity screenshots of the layout canvas at exact social dimensions.

It natively supports rendering custom background image assets per slide while ensuring text remains readable via dynamic overlay shielding, strict data integrity constraints, and asset-load confirmations.

## !!! SYSTEM CONSTRAINTS & TOOL RESTRICTIONS (READ FIRST) !!!
*   **NO CHROMIUM/CHROME EXECUTION VIA SHOT-SCRAPER:** You must compile templates to local, temporary HTML files and render them exclusively using native **Playwright** execution paths (e.g., via the Playwright CLI or a lightweight automated Node/Python script using headless WebKit or Chromium).
*   **STRICT ASSET PATHING:** You must resolve and load visual media, logos, and background images directly from the local `[home-directory]/workspace/design/assets/` directory (e.g., matching the local paths exported by `design-md-generator`). Do not link to external image URLs.
*   **OUTPUT RESTRICTION:** Do not include conversational introductory text, closing remarks, or meta-commentary inside the workspace. Output only the requested script execution pathways and the structural terminal checklist.

---

## 0. Trigger Conditions

This skill is automatically triggered when the user expresses any of the following intents:
*   **Social Content Generation:** Requesting to draft, build, render, or export images/graphics for social media (Instagram, TikTok, LinkedIn, Facebook).
*   **Template Rendering:** Asking to apply brand guidelines or a `DESIGN.md` file to raw post text to generate a visual post.
*   **Programmatic Output with Backgrounds:** Asking to overlay text on top of background images, photos, or visual graphics using browser engines.

*Keywords to listen for:* `generate social post`, `render carousel slides`, `compile template to image`, `playwright render`, `playwright screenshot`, `background image overlay`.

---

## 1. Execution Protocol & Layout Guidelines

When triggered, the agent must execute the following sequence:

### 1. Verify & Ingest System Inputs
*   **Design Source:** Locate and parse the YAML frontmatter and guidelines from `[home-directory]/workspace/design/DESIGN.md`. If this file is missing, halt execution and prompt: *"Please generate a DESIGN.md using the design-md-generator skill first before rendering posts."*
*   **Content Source:** Retrieve the raw copy, hooks, background image assignments, and slide definitions enclosed between the explicit data payload delimiters.
*   **Identify Platform Target:** Assess the target layout size based on the request:
    *   *Square (1:1):* `1080x1080` (Instagram / LinkedIn standard feeds)
    *   *Portrait (4:5):* `1080x1350` (High-engagement feeds; default choice if unstated)
    *   *Vertical (9:16):* `1080x1920` (Stories, Reels, TikTok, YouTube Shorts)

### 2. Guardrail Phase: Validate Copy, Branding, & Spatial Structure (MANDATORY GATE)
Before generating any HTML code, the agent must run a strict validation pass on the input content against the design system. If any check fails, the agent must programmatically adjust the structure or truncate strings to fit the system contract perfectly.

*   **Literal Copy Execution & Zero-Drift:** 
    *   The agent must treat the `title`, `subtitle`, and `body` strings from the input payload as strictly immutable, read-only variables. 
    *   You are strictly forbidden from modifying, paraphrasing, optimizing, or adding a single word of your own to these text strings. The rendered HTML tags must match the input strings textually with 100% fidelity.
*   **Zero-Hallucination & Omission Rule (No Placeholders):**
    *   The agent is strictly forbidden from fabricating, guessing, or making up any configuration details, metadata, social handles, or website URLs.
    *   If the input payload does not explicitly provide a value for optional metadata attributes (e.g., `"handle"` is empty or missing, or `"topic_tag"` is absent), the agent **must omit the corresponding HTML elements and structural zones entirely** from the rendered canvas. Do not use fallback strings like `@yourbrand` or template defaults.
*   **Mandatory Brand Assets:** If a brand logo asset is defined within `DESIGN.md`, its inclusion in the HTML template canvas is **non-negotiable**. The agent is strictly forbidden from omitting it or leaving the branding zone blank if the token is available in the design source.
*   **Copy & Text Hard Ceiling:** 
    *   Count the words per slide canvas frame. If any slide exceeds a **strict 30-word limit**, the agent must truncate the text or split it into an additional slide to guarantee clean spacing. 
    *   Headings *must* have a tight line-height forced strictly between `1.0` and `1.2` in the final CSS.
*   **Spatial Zone Enforcement:**
    *   **The Content Safe Zone (Middle 70%):** All primary message text blocks must stay within a central/left-aligned grid container enforcing a minimum 10% structural margin (padding) from all canvas edges. This prevents clipping by platform UI overlays. Implement automatic font-scaling if text risks breaking bounds.
    *   **The Logo & Topic Tag Zone (Top 15%):** The brand logo from `DESIGN.md` must sit in the top-right corner, capped between 8–12% of the canvas height. The category/topic capsule tag must sit in the top-left corner. Both must share identical top/side padding tokens derived from `DESIGN.md`. If the logo file or metadata is completely missing, drop the space allocation to allow the content zone to naturally adjust.
    *   **The Footer Zone (Bottom 15%):** The social handle and carousel page indicator (`X / Y`) must occupy this zone exclusively.
*   **Visual Anchoring & Contrast Check:** 
    *   If a slide contains a `background_image`, a visual shielding layer is **mandatory**. You must inject a dark background overlay (`background: rgba(0, 0, 0, 0.45);`) or a heavy multi-stop vignette gradient directly between the image and the text layer. 
    *   The final contrast ratio for text sitting over any background asset must meet a minimum **7:1 AAA accessible threshold**.
*   **System Fallback Restriction & Contract Fidelity:** 
    *   Every color, font weight, and structural layout spacing applied must map directly to a token inside `DESIGN.md`. 
    *   The agent is strictly forbidden from using standard browser defaults or inventing generic CSS fallbacks. If a layout asset or style variant isn't explicitly defined in `DESIGN.md`, it must be programmatically derived from the core accent tokens present in the design file.

### 3. Compile HTML Template Canvases
*   Construct a self-contained, offline-ready HTML slide template inside a temporary system path (`/tmp/canvas_slide_X.html`).
*   **Strict Design Value Mapping:**
    *   `DESIGN.md` Brand Colors $\rightarrow$ Translate explicitly into CSS custom properties on `:root` (e.g., `--color-primary`, `--color-accent`). Do not invent fallback hex codes.
    *   `DESIGN.md` Typography Scale $\rightarrow$ Inherit global header/body line-heights and font-families. Translate fonts using standard, heavy neo-grotesque font weights (e.g., `800` or `900` for compressed formats) to survive aggressive feed image compression.
    *   Hardcode explicit absolute pixel layout dimensions on the viewport and container elements (e.g., `width: 1080px; height: 1350px; overflow: hidden;`).
*   **Preventing Logo / Image Layout Collapse:**
    *   Never output empty dimensions or let image assets auto-calculate their sizing unguided. Always apply explicit height, width, and `object-fit: contain;` layout parameters to wrapping containers and target `<img>` tags to ensure they don't render at `0px`.
*   **Dynamic Layout Frameworks (Choose via Flexbox/Grid):**
    *   *The Balanced Split:* Top 15% for Logo/Tag, Middle 70% for a container holding the main text block, Bottom 15% for Footer/Handle.
    *   *The Image-Dominant Minimalist:* Full canvas background with a global 30% dark vignette layer. Text stacked vertically in the bottom-left safe zone, with the logo and handle grouped together in the bottom-right.
*   **Asset Injection:** Ensure the background image wrapper and the branding logo point to absolute file URLs under `[home-directory]/workspace/design/assets/` using the layout markup pattern. File paths must be fully qualified absolute URIs (e.g., using three forward slashes: `file:///Users/...`):
    ```html
    <div style="background-image: url('file://[absolute_path_to_asset]'); background-size: cover; background-position: center; position: relative;">
      <div style="position: absolute; inset: 0; background: linear-gradient(180deg, rgba(0,0,0,0.3) 0%, rgba(0,0,0,0.6) 100%); z-index: 1;"></div>
      <!-- Content containers using z-index: 2 sit here safely above the overlay -->
    </div>
    ```

### 4. Render Images Programmatically (Playwright)
*   Ensure directory targets are fully created: `[home-directory]/workspace/design/output/` using `mkdir -p`.
*   **Asset Load Enforcement:** To avoid blank images or un-rendered logos caused by race conditions, you are strictly forbidden from capturing a screenshot before assets have finished painting. 
    *   The Playwright orchestration logic must explicitly use the network idle lifecycle setup (`waitUntil: 'networkidle'`) or execute an explicit wait condition verifying the visual visibility of the `.logo-container img` selector.
*   For each slide, invoke the Playwright engine to capture the graphic at the exact viewport size with a slight execution safety buffer:
    ```bash
    npx playwright screenshot --wait-for-timeout=500 --viewport-size="[width_px],[height_px]" file:///tmp/canvas_slide_X.html [home-directory]/workspace/design/output/slide_X.png
    ```
*   *Alternative Script Path:* If a specialized orchestration script is required, run your local Playwright script (`node render.js` or `python render.py`) to process the batch headlessly.
*   *Optional Post-Processing:* If specified by layout rules, run `magick` (ImageMagick) commands to compress, convert to JPEG, or apply styling overlays.

### 5. Clean Up Temporary Assets
*   Silently remove all generated `/tmp/canvas_slide_*.html` pages using shell commands to leave a pristine environment.

---

## 2. Dynamic Input Schema (The Post Context)

The orchestration layer must pass configurations wrapped within the explicit delimiters `[BEGIN DATA PAYLOAD]` and `[END DATA PAYLOAD]`. The JSON supports optional local background assets mapping to `[home-directory]/workspace/design/assets/`:

```json
{
  "platform": "instagram_portrait",
  "dimensions": {
    "width": 1080,
    "height": 1350
  },
  "content": {
    "topic_tag": "System Architecture",
    "handle": "@yourbrand",
    "slides": [
      {
        "type": "hero_hook",
        "title": "93% OF MOBILE USER INTERFACES CLASH WITH PLATFORM METADATA.",
        "subtitle": "Here is how to fix your safe-zones.",
        "background_image": "./assets/background_primary.jpg"
      },
      {
        "type": "main_headline",
        "title": "The Compression Trap",
        "body": "Feeds aggressively compress thin typography. Always opt for weights above 700 to maintain direct daylight legibility.",
        "background_image": "./assets/photo_workspace.png"
      }
    ]
  }
}
```

## 3. Human-In-The-Loop Informational Output (Guardrails)
- Before invoking the rendering process, output a clean terminal checklist summarizing the slides to be built, their matched typography weight transitions, and safe-zone validations. This step is informational and does not halt programmatic execution.
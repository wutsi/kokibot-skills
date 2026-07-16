---
name: "design-md-generator"
description: "Generates or updates a machine-readable design contract file (DESIGN.md) containing product UI specs, mandatory local brand assets (logos/backgrounds only), specialized social typography scales, and cross-channel social media templates."
metadata:
  categories: 
    - design
  keywords: 
    - design system
    - DESIGN.md
    - brand guidelines
    - design tokens
    - social media typography
    - asset downloader
---

# Skill: design-md-generator

This skill processes brand assets, websites, or visual instructions and codifies them into a highly structured `DESIGN.md` file. This file acts as a permanent, machine-readable visual contract for both engineering and content generation agents. Additionally, **it strictly mandates the local download and preservation of core visual assets** (logos, key backgrounds) to a dedicated assets directory, keeps code out of the assets directory, and defines an exact, highly legible typography matrix optimized for high-compression social media feeds.

## !!! SYSTEM CONSTRAINTS & TOOL RESTRICTIONS (READ FIRST) !!!
*   **NEVER USE THE `web_fetch` TOOL:** Under no circumstances should you invoke `web_fetch` or any automated markdown-parsing web tools when a URL is provided[cite: 1]. 
*   **MANDATORY ALTERNATIVE:** You must fetch raw website content or download assets exclusively by running `curl`, `wget`, or equivalent terminal commands inside your execution sandbox[cite: 1]. This task requires raw source material and binary asset streams which high-level fetch tools strip away or fail to save[cite: 1].

---

## 0. Trigger Conditions

This skill is automatically triggered when the user expresses any of the following intents:
*   **Design System Creation:** Requesting to build, define, initialize, or document a new design system, brand guidelines, or visual guidelines[cite: 1].
*   **File Generation:** Explicitly asking to generate, write, update, or bootstrap a `DESIGN.md` file or its visual HTML preview[cite: 1].
*   **Asset Codification & Localization:** Providing brand assets, colors, typography details, logo assets, or a website URL and wanting to download assets locally and transform them into a formal design contract[cite: 1].
*   **Social & Layout Guidelines:** Requesting safe-zone standards, mobile layout parameters, or visual templates for cross-channel content[cite: 1].

*Keywords to listen for:* `create design system`, `generate DESIGN.md`, `brand guidelines`, `design tokens`, `visual contract`, `extract styles from website`, `generate design preview`, `download logo`, `save brand assets`, `social media typography`[cite: 1].

---

## 1. Execution Protocol

When triggered, the agent must execute the following sequence:

1. **Verify & Ingest Context**: 
   * Check if a valid `brand_context` (text, guidelines, or URL) is provided[cite: 1].
   * **If missing or blank:** Stop execution immediately[cite: 1]. Prompt the user: *"Please provide a website URL, brand guidelines, or a description of your brand assets so I can generate your DESIGN.md."*[cite: 1] Do not proceed to Step 2 until this context is supplied[cite: 1].
   * **If a URL is provided:** Fetch the raw HTML using a low-level command like `curl` (remembering the absolute ban on the `web_fetch` tool)[cite: 1].
     * *Single-Page Application (SPA) Fallback:* If the returned HTML is a minimal shell, scan the raw source code for linked `.css` assets, inline styles, asset paths, or Tailwind configurations to extract primary color tokens, typography scales, and layout aesthetics[cite: 1].
   * **Identify Scope:** Assess whether social media guidelines or channels are mentioned in the source context[cite: 1]. If present, set `include_social` to `true` to trigger the social media frontmatter and markdown sections[cite: 1].

2. **Mandatory Asset Localization (Media Assets Only)**:
   * Scan the raw HTML, input text, styling sheets, or context for references to the brand's primary assets (e.g., logo_primary, primary background/hero graphics, or favicons)[cite: 1].
   * **Strict Blocking Guardrail:** At least one core visual asset (such as a primary logo) **must** be present or identified[cite: 1]. If no image URLs, SVGs, or local assets are found in the provided context, **stop execution immediately**[cite: 1]. Prompt the user: *"This skill requires at least one core visual asset (such as a primary logo image URL or SVG) to generate the visual contract. Please provide the asset details to continue."*[cite: 1]
   * **Target Directory:** Create the destination directory: `$HOME/workspace/design/assets/` using a shell command (`mkdir -p`)[cite: 1].
   * **Asset Isolation Constraint:** **Only binary or vector image assets explicitly referenced in the `DESIGN.md` (e.g., logo and background image assets) may be stored in the `/assets/` folder.**[cite: 1] Do not output external CSS stylesheets, JavaScript files, or HTML scripts into this directory[cite: 1]. All preview styling and scripting logic must reside inline within the HTML preview file[cite: 1].
   * **Download Execution:** Save the identified binary or vector assets using a direct terminal command like `curl -L -o`[cite: 1].
     * Clean and rename the files systematically (e.g., `logo_primary.png` or `logo_primary.svg`, `background_primary.jpg`)[cite: 1].
   * **Update References:** Map these newly downloaded local relative paths (e.g., `./assets/logo_primary.png`) to the `brand.assets` keys in the YAML block[cite: 1]. *No external/remote image URLs are allowed to remain in the final document's assets section[cite: 1].*

3. **Draft Token Block**: 
   * Construct a valid semantic YAML frontmatter block mapping out `light` and `dark` themes, typography scales (including the specialized social typography tokens), layout spacing, localized asset paths, and conditional social media specs[cite: 1].
   * **Dynamic Versioning:** If a `DESIGN.md` already exists, read its current version[cite: 1]. If the existing file's frontmatter is unreadable, corrupt, or missing, fallback to defaulting to `1.0.0`[cite: 1]. Increment the patch version (e.g., `1.1.0` to `1.1.1`) for minor token adjustments, or the minor version (e.g., `1.1.0` to `1.2.0`) if new layout rules, local assets, or social platforms are added[cite: 1].

4. **Write System Guidelines**: Below the frontmatter, write the human-readable Markdown guidelines covering Visual Vibe, UI Components, Theme Transitions, and Social Media Guardrails (fully detailed with the new typography rules)[cite: 1].

5. **Draft HTML Preview Page**: Generate an interactive, highly polished, self-contained `preview.html` file using the newly generated design tokens and localized assets[cite: 1]. 
   * **The preview file must include:**
     * A CSS block injecting the light and dark tokens as native CSS custom properties (`--color-bg`, `--color-text`, etc.)[cite: 1].
     * References to the localized media assets in `$HOME/workspace/design/assets/` (e.g., displaying the downloaded logo)[cite: 1].
     * **Embedded Code Constraint:** All CSS layout declarations, theme toggle logic, and preview interactions must be written directly inline (within `<style>` and `<script>` blocks) inside `preview.html`[cite: 1]. No styles or interactive scripts should be compiled into external `.css` or `.js` files inside `/assets/`[cite: 1].
     * A real-time Light/Dark theme toggle control[cite: 1].
     * Visual swatches showing the active color palette[cite: 1].
     * Typography scale layout showcasing UI scales side-by-side with the new **Social Typography Scale** (Hero, Headline, Subhead, and Micro-Meta) to visually validate legibility.
     * Rendered interactive components (Buttons with hover states, Cards, and layout spacing grid indicators)[cite: 1].
     * Interactive social media layout canvas simulator showing the visual safe-zone overlay boxes based on the spacing rules defined in the system[cite: 1].
     * **Bulletproof Icon Architecture:** To prevent broken, missing, or blocked icons, do not use external icon fonts (such as FontAwesome)[cite: 1]. Instead, use inline SVGs or the Lucide CDN script link `<script src="https://unpkg.com/lucide@latest"></script>` resolved via `lucide.createIcons();` at the end of the page[cite: 1].

6. **File Generation (Instant Write & Overwrite)**: 
   * **Backup Strategy:** If a `DESIGN.md` already exists, immediately copy it to the backup directory: `$HOME/workspace/design/bak/yyyy/MM/dd/DESIGN-HHmm.md` (substituting actual system date and time values)[cite: 1].
   * **Direct Write:** Proceed to write/overwrite the updated files directly to `$HOME/workspace/design/DESIGN.md` and `$HOME/workspace/design/preview.html`[cite: 1].

---

## 2. Output Schema Template

The generated `DESIGN.md` file must strictly adhere to this structural schema:

```markdown
---
name: "[Brand/Project Name]"
description: "Design system and brand guidelines source of truth."
version: "[Dynamic Version - e.g., 1.0.0 or incremented version]"
brand:
  name: "[Name]"
  assets:
    logo_primary: "./assets/logo_primary.[ext]"
    background_primary: "./assets/background_primary.[ext]"
colors:
  light:
    system_background: "#ffffff"
    system_background_secondary: "#f5f5f7"
    label: "#1d1d1f"
    secondary_label: "#86868b"
    accent: "[Primary interactive color]"
    border: "#d2d2d7"
  dark:
    system_background: "[Pure black or deep dark slate]"
    system_background_secondary: "[Elevated container color]"
    label: "[Near-white crisp color]"
    secondary_label: "#86868b"
    accent: "[High-contrast color matching light accent]"
    border: "[Subtle dark line divider]"
typography:
  font_family: "-apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, sans-serif"
  sizes:
    hero: "48px"
    header: "32px"
    body: "16px"
    caption: "12px"
  # Core Social Media Typography Tokens
  social:
    font_family_fallback: "[Impact-friendly heavy sans-serif recommended for compressed media, e.g., 'Inter Black', 'League Spartan', 'Arial Black']"
    scale:
      hero_hook:
        size: "96px"
        line_height: "1.0"
        weight: "900" # Extra Black / Heavy
      main_headline:
        size: "64px"
        line_height: "1.1"
        weight: "800" # Extra Bold
      subhead_body:
        size: "32px"
        line_height: "1.4"
        weight: "500" # Medium
      micro_meta:
        size: "20px"
        line_height: "1.2"
        weight: "700" # Bold
spacing:
  base_grid: "8px" # Multiples of 8px (8, 16, 24, 32, 48, 64)
# Note: Include this block only if include_social == true
social_media:
  platforms:
    instagram:
      carousel_and_post: "1080x1350 (4:5 Portrait) or 1080x1080 (1:1 Square)"
      stories_and_reels: "1080x1920 (9:16 Vertical)"
    facebook:
      feed_post: "1200x630 (1.91:1 Landscape) or 1080x1350 (4:5)"
      stories: "1080x1920 (9:16 Vertical)"
    linkedin:
      image_and_pdf_slides: "1080x1350 (4:5 Portrait) or 1200x627 (1.91:1)"
    tiktok:
      video_overlay_canvas: "1080x1920 (9:16 Vertical)"
---

# [Brand Name] Design & Brand System

This document is the visual source of truth. Read these rules before generating any UI code or marketing graphics.

## 1. Visual Vibe
*   [Clear visual description of core aesthetics - high density, cozy editorial, minimalist, etc.]
*   [How whitespace and margins are managed across layouts.]

## 2. Adaptive Theme Transitions (UI Only)
*   **True Black/Dark Canvas:** Background sets to `colors.dark.system_background`.
*   **Layer Elevation:** 
    *   Level 0 (Canvas): Background
    *   Level 1 (Cards/Shelves): Secondary Background
    *   Level 2 (Modals/Dropdowns): Higher gray/slate elevation offset.
*   **Image Dimming:** Dim heavy visual graphics by 5-10% to protect night readability.

## 3. UI Component Guidelines
*   **Buttons:** Standardized border-radiuses, hover state outlines, and primary vs. secondary ghost styling.
*   **Cards:** Border widths, subtle shadows, and light/dark theme structural borders.

## 4. Social Media Asset Standards & Typography (Cross-Channel)

All generated static, carousel, or motion graphics must comply with platform-specific safe-zone dimensions and robust, high-contrast typography rules to prevent copy from being obscured or unreadable on mobile screens.

### 4.1. Font Translation Strategy
*   **Thicker Weight Enforcement:** To survive aggressive feed-based JPEG/MP4 compression artifacts on mobile, avoid thin or hairline font cuts for social graphics.
*   **Conversion Standard:** If the primary brand body font is lighter than 400 weight (Regular), translate the text to a thick, high-impact neo-grotesque or geometric sans-serif (such as `typography.social.font_family_fallback` at 700+ weight) for social templates.

### 4.2. Social Scale Matrix
*   **Hero Hook:** `96px` | Line-height `1.0` | Weight `900` — For giant single-sentence quotes, shocking statements, or massive stats on text-only intro slides.
*   **Main Headline:** `64px` | Line-height `1.1` | Weight `800` — For standard multi-slide covers, core visual hooks, and title graphics.
*   **Subhead / Body:** `32px` | Line-height `1.4` | Weight `500` — For concise supporting details, bullets, or highly digestible callout sentences.
*   **Micro-Meta:** `20px` | Line-height `1.2` | Weight `700` — For brand handles (@username), clean CTA buttons, page cues, and corporate URLs.

### 4.3. Legibility & Contrast Rules (Mobile-First)
1. **The 30-Word Limit:** To ensure comfortable viewing on outdoor mobile displays, limit a single slide’s content to a maximum of 30 words. If the message is longer, split it into a carousel slide progression.
2. **Double-Contrast Rule (WCAG AAA / Outdoor):** Do not rely on color contrast alone. Multi-line headers must maintain a minimum color contrast ratio of 7:1 against background canvases (complying with WCAG AAA under direct sunlight environments). If complex backgrounds or dynamic color blends are used, use an inline high-contrast backing block or dark visual vignette beneath the text block.
3. **Line-Height Bounds:** To avoid text-clashing on wrapped mobile screens, multi-line headers (`Hero Hook` and `Main Headline`) must strictly observe a minimum line-height of `1.0` and a maximum of `1.2`. Any spacing wider than `1.2` degrades vertical safe zones and causes layout overflows.

### 4.4. Dynamic Safe-Zones & Margins
*   **Instagram & Facebook Stories/Reels (9:16):** 
    *   *Top Safe-Zone Margin:* Keep the top **220px** completely free of critical copy (reserved for profile avatars and platform icons).
    *   *Bottom Safe-Zone Margin:* Keep the bottom **310px** free of text overlays (reserved for engagement buttons, caption text, and sound indicators).
    *   *Grid Preview (3:4 Ratio):* Ensure key content on Reels fits within the center **1080x1440px** space so it looks correct on profile grids.
*   **TikTok (9:16 Video Overlays):**
    *   *Right Margin Safe-Zone:* Leave a **120px** margin on the right side to prevent text from sliding under the engagement buttons (Like, Comment, Share).
    *   *Bottom Safe-Zone:* Reserve the bottom **350px** for the creator's username and video description wrapper. Keep primary text positioned strictly in the upper-middle quadrant of the screen.
*   **LinkedIn & Instagram Carousels (4:5 Portrait):**
    *   Apply a uniform **10% padding** (108px) around all edges. 
    *   Ensure the "Page Number indicator" (e.g., "3/5") or swipe cue arrows have a dedicated line at the bottom center.

### Visual Style Prompts
*   *Grid Abstract:* "[Provide a precise, high-contrast prompt formula for image generation]"
*   *Warm Gradient:* "[Provide a precise gradient/lighting prompt formula]"

### Copy & Hook Guidelines
*   **Formatting:** Use a single sentence hook, generous spacing, and a maximum of 2 emojis per post.
*   **CTA Placement:** Place the primary goal on the final carousel slide or at the end of the caption text.

## 5. Layout Guardrails
*   **Localization Margin:** Ensure all flexbox layouts handle layout expansion (such as French translation expansion factors) safely without hardcoding widths.

## 6. Do's and Don'ts
*   **DO** keep key text in 9:16 layouts centered within the 1080x1350 vertical envelope.
*   **DO** preserve design system colors across all social formats.
*   **DON'T** let text crawl near the top and bottom quarters of mobile canvases where native UI tags overlap.
*   **DON'T** use multi-color background patterns directly behind small text layers.
```

## 3. Human-In-The-Loop Approval (Guardrails)
- Before executing the final file-writes, output a clean, summarized terminal diff of the changes (tokens updated, assets downloaded, and version changes) for user review. This step is informational and does not halt programmatic execution.

- Output Protocol (On Write Success): Provide the user with clear, actionable copy-paste terminal outputs containing the exact local paths. Use this exact output format:

```markdown
SUCCESS: Design system successfully codified.

📂 Markdown Source:
[home-directory]/workspace/design/DESIGN.md

🖥️ Interactive HTML Preview
[home-directory]/workspace/design/preview.html
```
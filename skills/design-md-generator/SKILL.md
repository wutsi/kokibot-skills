---
name: "design-md-generator"
description: "Generates or updates a machine-readable design contract file (DESIGN.md) containing product UI specs and cross-channel social media templates."
keywords: 
  - design system
  - DESIGN.md
  - brand guidelines
  - design tokens
---

# Skill: design-md-generator

This skill processes brand assets, websites, or visual instructions and codifies them into a highly structured `DESIGN.md` file. This file acts as a permanent, machine-readable visual contract for both engineering and content generation agents. Additionally, it generates an interactive, self-contained HTML preview of the design system for immediate visual validation.

## !!! SYSTEM CONSTRAINTS & TOOL RESTRICTIONS (READ FIRST) !!!
*   **NEVER USE THE `web_fetch` TOOL:** Under no circumstances should you invoke `web_fetch` or any automated markdown-parsing web tools when a URL is provided. 
*   **MANDATORY ALTERNATIVE:** You must fetch the raw website content exclusively by running `curl` or equivalent terminal commands inside your execution sandbox. This task requires raw HTML, CSS styles, variables, and structural DOM metadata, which high-level fetch tools strip away.

---

## 0. Trigger Conditions

This skill is automatically triggered when the user expresses any of the following intents:
*   **Design System Creation:** Requesting to build, define, initialize, or document a new design system, brand guidelines, or visual guidelines.
*   **File Generation:** Explicitly asking to generate, write, update, or bootstrap a `DESIGN.md` file or its visual HTML preview.
*   **Asset Codification:** Providing brand assets, colors, typography details, logo assets, or a website URL and wanting to transform them into a formal design contract or machine-readable tokens.
*   **Social & Layout Guidelines:** Requesting safe-zone standards, mobile layout parameters, or visual templates for cross-channel content.

*Keywords to listen for:* `create design system`, `generate DESIGN.md`, `brand guidelines`, `design tokens`, `visual contract`, `extract styles from website`, `generate design preview`.

---

## 1. Execution Protocol

When triggered, the agent must execute the following sequence:

1. **Verify & Ingest Context**: 
   * Check if a valid `brand_context` (text, guidelines, or URL) is provided.
   * **If missing or blank:** Stop execution immediately. Prompt the user: *"Please provide a website URL, brand guidelines, or a description of your brand assets so I can generate your DESIGN.md."* Do not proceed to Step 2 until this context is supplied.
   * **If a URL is provided:** Fetch the raw HTML using a low-level command like `curl` (remembering the absolute ban on the `web_fetch` tool).
     * *Single-Page Application (SPA) Fallback:* If the returned HTML is a minimal shell, scan the raw source code for linked `.css` assets, inline styles, asset paths, or Tailwind configurations to extract primary color tokens, typography scales, and layout aesthetics.
   * **Identify Scope:** Assess whether social media guidelines or channels are mentioned in the source context. If present, set `include_social` to `true` to trigger the social media frontmatter and markdown sections.
2. **Draft Token Block**: 
   * Construct a valid semantic YAML frontmatter block mapping out `light` and `dark` themes, typography scales, layout spacing, and conditional social media specs.
   * **Dynamic Versioning:** If a `DESIGN.md` already exists, read its current version. Increment the patch version (e.g., `1.1.0` to `1.1.1`) for minor token adjustments, or the minor version (e.g., `1.1.0` to `1.2.0`) if new layout rules or social platforms are added. If creating a new file, default to `1.0.0`.
3. **Write System Guidelines**: Below the frontmatter, write the human-readable Markdown guidelines covering Visual Vibe, UI Components, Theme Transitions, and Social Media Guardrails.
4. **Draft HTML Preview Page**: Generate an interactive, highly polished, self-contained `preview.html` file using the newly generated design tokens. 
   * **The preview file must include:**
     * A CSS block injecting the light and dark tokens as native CSS custom properties (`--color-bg`, `--color-text`, etc.).
     * A real-time Light/Dark theme toggle control.
     * Visual swatches showing the active color palette.
     * Typography scale layout showcasing Hero, Header, Body, and Caption sizing.
     * Rendered interactive components (Buttons with hover states, Cards, and layout spacing grid indicators).
     * Interactive social media layout canvas simulator showing the visual safe-zone overlay boxes based on the spacing rules defined in the system.
     * **Bulletproof Icon Architecture:** To prevent broken, missing, or blocked icons, do not use external icon fonts (such as FontAwesome) or local SVG file linkages. Instead, use one of the following:
       * *Inline SVGs (Offline-Safe):* Render UI and state icons using raw `<svg>` blocks configured with standard utility dimensions (e.g., `width="20" height="20" fill="none" stroke="currentColor"`).
       * *Lucide Icons CDN:* Inject the unpkg distribution script `<script src="https://unpkg.com/lucide@latest"></script>` at the end of the markup and run `lucide.createIcons();` to resolve `<i data-lucide="..."></i>` nodes instantly.
5. **File Generation (Instant Write & Overwrite)**: 
   * Ensure directory targets are fully created using a dynamic file-system command (`mkdir -p`) before writing.
   * **Backup Strategy:** If a `DESIGN.md` already exists, immediately copy it to the backup directory: `$HOME/workspace/design/bak/yyyy/MM/dd/DESIGN-HHmm.md` (substituting actual system date and time values).
   * **Direct Write:** Proceed to write/overwrite the updated file directly to `$HOME/workspace/design/DESIGN.md` and `$HOME/workspace/design/preview.html` without asking the user for confirmation.

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
    logo_primary: "[Direct URL to stable SVG/PNG favicon or asset]"
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

## 4. Social Media Asset Standards (Cross-Channel)

All generated static, carousel, or motion graphics must comply with platform-specific safe-zone dimensions to prevent critical copy from being obscured by native user interfaces.

![Platform Safe-Zone Blueprint]([Insert stable URL or keep placeholder for reference image])

### Dynamic Safe-Zones & Margins
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
- Before overwriting an existing `DESIGN.md` or generating a new preview file in the user's workspace, the agent must output a summarized diff or checklist of planned changes to the terminal.

- **Output Protocol (On Write Success):** Provide the user with clear, actionable copy-paste terminal outputs containing the exact local paths. Use this exact output format:

```markdown
SUCCESS: Design system successfully codified.

📂 Markdown Source:
[home-directory]/workspace/design/DESIGN.md

🖥️ Interactive HTML Preview
[home-directory]/workspace/design/preview.html
```
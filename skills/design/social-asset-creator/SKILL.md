---
name: social-asset-creator
description: Use when generating platform-specific social media images or multi-slide carousels for Facebook, Instagram, WhatsApp, TikTok, LinkedIn, or YouTube that must match exact pixel dimensions, safe zones, and brand fonts/colors — for feed posts, stories, reel covers, link previews, carousel slides, or video thumbnails.
metadata:
    categories:
        - design
---

# Social Media Post & Carousel Image Generation

## Overview

Generates high-quality, platform-specific social post images and multi-slide carousels: reads the central design
system, stages background images into the local workspace, injects copy into per-platform HTML slide templates, and
renders via the **Playwright CLI (`playwright-cli`)**. Prints a plain-text list of absolute file paths to all
generated assets on `stdout` — downstream scripts must parse `stdout` to locate the rendered files.

## When to Use

* Adapting the same copy/background into multiple platform aspect ratios at once (no manual cropping).
* Multi-slide carousels: tutorials, slide decks, episodic promo cards (LinkedIn Document posts, Instagram Carousels).
* Rendering brand-compliant graphics at scale where generative image models fail (layout hallucination, misspelled
  text, wrong fonts).

## Input Parameters

| Parameter               | Type   | Required | Values / Description                                                                                             |
|:------------------------|:-------|:---------|:-----------------------------------------------------------------------------------------------------------------|
| Target platform         | String | Yes      | `facebook` \| `instagram` \| `whatsapp` \| `tiktok` \| `linkedin` \| `youtube`                                   |
| Placement type          | String | Yes      | `feed` \| `story` \| `reel_cover` \| `link_preview` \| `carousel_slide` \| `community_post` \| `video_thumbnail` |
| Slides Data             | Array  | Yes      | Objects with content per slide. Single-item array = static post.                                                 |
| ↳ Hook                  | String | Yes*     | Primary attention-grabbing text (e.g. "Stop Scrolling!"). Required on Slide 1.                                   |
| ↳ Headline              | String | No       | Main title / value proposition.                                                                                  |
| ↳ Sub Head              | String | No       | Supporting/secondary text.                                                                                       |
| ↳ CTA                   | String | No       | Call-to-action text (usually final slide only).                                                                  |
| ↳ Background image path | String | No       | Local path or remote URL for the slide background.                                                               |

**Validation:** an invalid platform/placement combo (e.g. TikTok `link_preview`) falls back to that platform's `feed`
spec. Multiple slides passed to a non-carousel placement fall back to a single static image using only slide 1.

## Platform Specifications

> **Safe zone:** for `story` and `reel_cover`, center text/critical assets within the inner 1080 x 1350 px area to
> avoid native app UI overlays.

| Platform  | Placement                      | Dimensions  | Ratio  | Notes                            |
|:----------|:-------------------------------|:------------|:-------|:---------------------------------|
| Instagram | feed (portrait/carousel)       | 1080 x 1350 | 4:5    | Recommended for carousels        |
| Instagram | feed (square/carousel)         | 1080 x 1080 | 1:1    |                                  |
| Instagram | story / reel_cover             | 1080 x 1920 | 9:16   |                                  |
| Facebook  | feed (portrait/carousel)       | 1080 x 1350 | 4:5    |                                  |
| Facebook  | feed (square/carousel)         | 1080 x 1080 | 1:1    |                                  |
| Facebook  | link_preview                   | 1200 x 630  | 1.91:1 |                                  |
| Facebook  | story                          | 1080 x 1920 | 9:16   |                                  |
| TikTok    | feed / reel_cover              | 1080 x 1920 | 9:16   |                                  |
| WhatsApp  | feed                           | 1080 x 1080 | 1:1    |                                  |
| WhatsApp  | story                          | 1080 x 1920 | 9:16   |                                  |
| LinkedIn  | feed (portrait/text post)      | 1080 x 1350 | 4:5    |                                  |
| LinkedIn  | carousel_slide (document post) | 1080 x 1080 | 1:1    | Standard square, multi-page docs |
| LinkedIn  | link_preview                   | 1200 x 628  | 1.91:1 |                                  |
| YouTube   | video_thumbnail                | 1280 x 720  | 16:9   |                                  |
| YouTube   | community_post                 | 1080 x 1080 | 1:1    |                                  |
| YouTube   | reel_cover                     | 1080 x 1920 | 9:16   |                                  |

## Typography Scale

Baseline canvas height: **1350px**. For lower target resolutions (e.g. 720p thumbnail), scale all pixel values by
`Target Height / 1350`. Use `vw`/`vh` or fixed px; document sizing is forbidden.

| Element  | Size    | Weight    | Notes                                                             |
|:---------|:--------|:----------|:------------------------------------------------------------------|
| Hook     | 72–96px | 800 / 900 | Uppercase or high-contrast badge; must anchor attention instantly |
| Headline | 64–80px | 700       | Bold, clearly structured                                          |
| Sub Head | 36–48px | 500 / 400 | Sized to handle up to 2–3 lines                                   |
| CTA      | 32–40px | 700       | Pill/rounded button, padding `24px 48px`                          |

## Execution Protocol

Run these steps in strict sequential order. Do not loop or re-draft generated code.

**Step 0 — Environment check:** run `scripts/check_env.sh`. Halts with an explicit error if `playwright-cli` is
missing.

```bash
scripts/check_env.sh
```

**Step 1 — Read design system:** read `[home-directory]/DESIGN.md` (YAML frontmatter + Markdown body, per the
`design-md-creator` skill's contract). Extract `typography`, `colors`, and `spacing` from the frontmatter. If the
file doesn't exist, halt and tell the user to run `design-md-creator` first.

**Step 2 — Stage backgrounds:** generate an asset ID `asset_[YYYYMMDDHHMMSS]` (current UTC, e.g. `date -u
+%Y%m%d%H%M%S`) and its output dir `[home-directory]/workspace/output/asset_[UniqueId]/`. For each slide with a
background image path, run `scripts/stage_background.sh` to download/copy it into that dir. Use the script's
printed local path (not the original URL/path) in Step 3.

```bash
scripts/stage_background.sh "[path-or-url]" "[home-directory]/workspace/output/asset_[UniqueId]" [slide-index]
```

**Step 3 — Generate HTML:** for each slide, write a self-contained HTML file
(`[home-directory]/workspace/output/asset_[UniqueId]/temp_slide_N.html`) with the platform dimensions, background
style, and injected copy (hook, headline, subHead, cta):

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

**Step 4 — Render & report:** run `scripts/render_assets.sh` once. It renders every `temp_slide_N.html` to
`slide_N.png` at the target dimensions (`playwright-cli open → resize → screenshot → close` per slide) and prints
the plain-text list of absolute asset paths to stdout.

```bash
scripts/render_assets.sh "[home-directory]/workspace/output/asset_[UniqueId]" [Insert Evaluated Width] [Insert Evaluated Height]
```

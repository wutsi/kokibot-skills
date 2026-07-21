---
name: "design-md-creator"
description: "Use when creating or updating a DESIGN.md design-token file — triggers on UI/design-system prompts, a live website URL or CSS file to extract tokens from, an uploaded .pptx brand deck, or a request to update/iterate on an existing DESIGN.md."
metadata:
    categories:
        - design
---

# design-md-creator

## Overview

Builds/updates `[home-directory]/DESIGN.md`: a YAML-frontmatter + Markdown file capturing a brand's design tokens
(colors, typography, spacing, components) and the prose rationale behind them. Spec:
[Google Labs DESIGN.md](https://github.com/google-labs-code/design.md/blob/main/docs/spec.md) v0.0.1.

## Rules

1. Read/write only `[home-directory]/DESIGN.md`. Never a temp path, cwd, or alternate name.
2. Version: no existing file → `1.0.0`; token-value-only edit → bump patch; structural change (added/removed section
   or component) → bump minor. Read the existing file first to know the current version.
3. Output = YAML frontmatter (tokens) + Markdown body (rationale), always both.
4. Markdown `##` sections must appear in this exact order, omitting any with no data — never reorder/duplicate:
   Overview (or Brand & Style) → Colors → Typography → Layout (or Layout & Spacing) → Elevation & Depth (or
   Elevation) → Shapes → Components → Do's and Don'ts.
5. Hex as `#RRGGBB`/`#RRGGBBAA`; every dimension has a CSS unit (`px`/`em`/`rem`); quote hex codes and signed/unit
   values (`"-0.02em"`) to avoid YAML parse errors; reference tokens as `"{colors.primary}"`.
6. Never use `web_fetch`/`WebFetch` for token extraction — it summarizes pages through markdown conversion and
   drops/paraphrases `<style>` blocks, which can silently report "no tokens found" on pages that have real CSS. Use
   `curl`/`wget` instead.
7. Flatten component states as sibling keys — `button-primary`, `button-primary-hover` — never nested.

## Workflow

1. Read `[home-directory]/DESIGN.md` if it exists, to get the current version baseline.
2. Ingest input by type:
    - **URL:** `curl`/`wget` the page, then also fetch any `<link rel="stylesheet">` target — tokens often live only
      in the linked CSS. No `curl`/`wget` available → abort with
      `[ERROR] No compatible web fetch tool available to retrieve live page content. Aborting design generation.`
    - **.pptx:** use an available extraction tool/skill to dump text/shape/slide data. None available → abort with
      `[ERROR] No compatible tool or skill available to process .pptx files. Aborting design generation.`
    - **Update request:** diff the new input against the existing file's content.
3. Map extracted values into the schema: `colors` (primary/secondary/tertiary/neutral), `typography` (levels with
   `fontFamily`/`fontSize`/`fontWeight`/`lineHeight`/`letterSpacing`), `spacing`/`rounded` (`xs`–`full` scale),
   `components`.
4. Bump `version` per rule 2.
5. Write the Markdown body per rule 4, keeping prose color/type names traceable to their token keys.

## Common Mistakes

| Mistake                                     | Fix                                              |
|---------------------------------------------|--------------------------------------------------|
| Using `web_fetch`/`WebFetch` on a URL       | `curl`/`wget` raw HTML instead (rule 6).         |
| Fetching only the page HTML                 | Also fetch linked `<link rel="stylesheet">` CSS. |
| Unquoted hex/dimension values in YAML       | Quote them (rule 5).                             |
| Nesting `hover`/`active` under a parent key | Flat sibling keys (rule 7).                      |
| Reordering/duplicating `##` sections        | Fixed order, omit missing (rule 4).              |
| Skipping the version bump                   | Always bump per rule 2.                          |

## Example

```markdown
---
version: 1.0.0
name: "Daylight Prestige"
description: "A high-contrast professional interface layout."
colors:
  primary: "#1A1C1E"
  neutral: "#F7F5F2"
typography:
  body-md:
    fontFamily: "Public Sans"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.6
spacing:
  md: "16px"
rounded:
  sm: "4px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.neutral}"
    rounded: "{rounded.sm}"
  button-primary-hover:
    backgroundColor: "{colors.neutral}"
---

## Overview

Premium workspace platform targeting deep professional density.

## Colors

- **Primary (#1A1C1E):** headlines and core text.
- **Neutral (#F7F5F2):** page backgrounds.

## Typography

Public Sans; body copy at 1.6 line-height for readability.

## Layout

8px spacing scale for padding, alignment, and gutters.

## Elevation & Depth

Tonal background shifts and contrast borders, not shadows.

## Shapes

4px edge roundness throughout.

## Components

### Buttons

Primary CTA uses a full background fill from `{colors.primary}`.

## Do's and Don'ts

- Do maintain WCAG AA contrast (4.5:1 body text).
- Don't mix sharp and organic corner styles on one screen.
```

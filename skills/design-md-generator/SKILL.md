---
name: "design-md-generator"
description: "Generates or updates a machine-readable design contract file (DESIGN.md) containing product UI specs, mandatory local brand assets (logos/backgrounds only), specialized social typography scales, and cross-channel social media templates."
metadata:
    categories:
        - design
---

# Skill: design-md-generator

## Overview

This skill systematically constructs a unified, production-ready `DESIGN.md` file based on a brand concept, user
description, or UI prompt. The generated file bridges human-readable design rationale with machine-readable design
tokens using a hybrid YAML/Markdown structure.

- Specification
  Authority: [Google Labs DESIGN.md Spec](https://github.com/google-labs-code/design.md/blob/main/docs/spec.md)
- **Current Spec Version:** `0.0.1`

---

## Core System Directives

### 1. File Storage Location

* **Strict Target Path:** The resulting file must always be read from and written directly to
  `[home-directory]/DESIGN.md`. Do not write to temporary subdirectories or alternative file names.

### 2. Version Incrementing Rule

* **State Preservation:** Before attempting an increment, the agent must ensure the contents of the existing
  `[home-directory]/DESIGN.md` (if any) have been explicitly read into the current context window.
* **Semantic Iteration:**
    * If updating an existing custom layout version string, increment its value appropriately (e.g., `v1.0.0` becomes
      `v1.0.1`, or append an incremental revision count).

### 3. Dual-Nature Output Requirement

Every generated file must consist of exactly two parts:

* **YAML Frontmatter:** Machine-readable design tokens mapping colors, typography, spacing, shapes, and component
  overrides.
* **Markdown Body:** Human-readable prose explaining the design choices and styling guardrails using strict `##` header
  sequences.

### 4. Strict Sequence Constraint

Markdown sections cannot be reordered, duplicated, or interleaved. If data for a section is missing or irrelevant, omit
the section entirely. The parsed output sequence must strictly be:

1. `---` YAML Frontmatter Delimiters
2. `## Overview` (Alternative allowed: `## Brand & Style`)
3. `## Colors`
4. `## Typography`
5. `## Layout` (Alternative allowed: `## Layout & Spacing`)
6. `## Elevation & Depth` (Alternative allowed: `## Elevation`)
7. `## Shapes`
8. `## Components`
9. `## Do's and Don'ts`

### 5. Syntax Rules

* **Color Formats:** Hex notation (`#RRGGBB` or `#RRGGBBAA`) is the default standard for tool compliance.
* **Dimension Scales:** Suffix all sizes with valid CSS units (`px`, `em`, `rem`).
* **Quotation Guardrails:** Always wrap Hex codes (`"#1A1C1E"`) and dimensions with symbols or negative numbers (e.g.,
  `letterSpacing: "-0.02em"`) in double quotes to prevent YAML parsing crashes.
* **Token References:** Cross-reference primitive tokens inside the `components` block using curly braces and object
  pathing: `"{colors.primary}"`.

---

## Operational Execution Loop

### Step 1: Context Ingestion

Before writing or modifying any token configurations, the agent must inspect the working environment and extract active
design requirements via one of the two designated ingestion routing pathways:

#### Pathway A: Live Web Page URL

If the user provides a website link:

1. Use `curl` or `wget` to fetch the web page or the provided raw stylesheets (`.css`) directly.
    * **NEVER user `web_fetch` tool** since it's converting content to markdown and losing structural fidelity.
    * **CRITICAL:** If the environment lacks a local `curl` or `wget` binary, output the error message:
      `[ERROR] No compatible web fetch tool available to retrieve live page content. Aborting design generation.` and
      terminate execution immediately.
2. If relying on text extraction, isolate dominant palette hex values, declared font-family names, and structural
   spacing configurations. Avoid parsing raw, minified single-line JavaScript strings.

#### Pathway B: PowerPoint Deck Layout File

If the user provides a `.pptx` file

1. **Tool Verification:** Verify the availability of local parser tools, document extraction engines, or presentation
   processing skills. **CRITICAL:** If no dedicated layout extraction or text conversion tools are available in the
   current environment, output the error message:
   `[ERROR] No compatible tool or skill available to process .pptx files. Aborting design generation.` and terminate
   execution immediately.
2. If available, invoke the extraction pipeline to dump text metadata blocks, shape schemas, and slide structures.
3. Review the structural data to build the design baseline.

*Baseline System Scan:* If ingestion succeeds, check `[home-directory]/DESIGN.md` for a legacy token baseline to
cross-reference previous structural versions.

### Step 2: Extract Design Input & Delta Processing

Analyze the delta between the raw incoming user prompt and the ingested system context. Isolate the target updates (
e.g., changing a primary color hex vs. appending a new social template component block).

### Step 3: Formulate the Token Schema & Increment Version

Calculate the new incremented version or revision code based on the ingested file state. Map configurations directly
into the YAML schema layout format:

* Include the freshly updated version or `revision: <integer>` identifier tracking parameters.
* `colors`: `primary`, `secondary`, `tertiary`, `neutral`.
* `typography`: Level mappings containing `fontFamily`, `fontSize`, `fontWeight`, `lineHeight`, and `letterSpacing` (
  including custom social media scaling arrays).
* `spacing` & `rounded`: Sizing scales using logical keys (`xs`, `sm`, `md`, `lg`, `xl`, `full`).
* `components`: Standard components and custom cross-channel social templates, matching structural token rules.

### Step 4: Handle Component Aliases & Variants

Map atomic styles to standard component states flatly.

* *Note:* Never nest interactive states under a parent key. Use sequential sibling keys: `button-primary`,
  `button-primary-hover`, and `button-primary-active`.

### Step 5: Write Descriptive Prose Sections

Draft clean documentation within the strict markdown layout sequence. Ensure descriptive color names used in the prose
map explicitly back to token keys.

---

## Code Reference Layout

When executing this skill, your final text output must match this exact blueprint structural shape:

```markdown
---
version: alpha
name: "Daylight Prestige"
description: "A high-contrast professional interface layout."
colors:
  primary: "#1A1C1E"
  secondary: "#6C7278"
  tertiary: "#B8422E"
  neutral: "#F7F5F2"
typography:
  headline-md:
    fontFamily: "Public Sans"
    fontSize: "32px"
    fontWeight: 600
    lineHeight: 1.2
  body-md:
    fontFamily: "Public Sans"
    fontSize: "16px"
    fontWeight: 400
    lineHeight: 1.6
spacing:
  sm: "8px"
  md: "16px"
rounded:
  sm: "4px"
  md: "8px"
components:
  button-primary:
    backgroundColor: "{colors.primary}"
    textColor: "{colors.neutral}"
    rounded: "{rounded.sm}"
    padding: "12px"
  button-primary-hover:
    backgroundColor: "{colors.secondary}"
---

## Overview

The design system defines the visual identity of a premium workspace platform. It targets deep professional density.

## Colors

The palette is rooted in high-contrast neutrals and a single crisp interaction highlight.

- **Primary (#1A1C1E):** Deep ink used for headlines and core text surfaces.
- **Secondary (#6C7278):** Sophisticated slate used for borders, subtle captions, and metadata.
- **Tertiary (#B8422E):** Earthy red driver for primary action item highlights.
- **Neutral (#F7F5F2):** Warm limestone layer foundational for all page backgrounds.

## Typography

Leverages Public Sans across clean geometric line heights.

- **Headlines:** Set in Bold variants to maximize visual importance.
- **Body:** Regular variants utilizing a clean 1.6 multiplier to ensure structural readability.

## Layout

The layout uses a strict 8px spacing scale framework to manage padding, structural alignment, and gutter parameters.

## Elevation & Depth

Depth is conveyed using clean tonal background shifting and solid contrast borders rather than explicit shadows.

## Shapes

Components leverage minimal 4px edge roundness to establish an intentional, structural layout rhythm.

## Components

### Buttons

Primary call-to-actions adapt full background fills inherited from structural token pairs.

## Do's and Don'ts

- Do maintain WCAG AA contrast ratios (4.5:1 for standard body text variations).
- Do use the primary highlight exclusively for major user actions.
- Don't mix sharp elements and organic heavy corner behaviors within a single screen.
```

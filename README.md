# Omarchy Manual iOS home-screen icon

Safari “Add to Home Screen” for [https://omarchy.org/manual/](https://omarchy.org/manual/) currently shows a gray **T** instead of the Omarchy mark.

That is not an iOS bug. The live site never ships an `apple-touch-icon`, so iOS invents a monogram from the document title:

```
<title>Welcome to Omarchy! — The Omarchy Manual</title>
```

Safari treats **The Omarchy Manual** as the app name. First letter: **T**.

This repo is a ready-to-open patch against the official website source:

- Website: https://omarchy.org
- Source: https://github.com/omacom-io/omarchy-site
- Template that owns `<head>`: `templates/layout.html.erb`
- Generated (and committed) pages: `manual/**`

It is **not** a fork of the whole site. It is the assets, the exact markup change, and the steps to land it upstream.

## What’s in here

```
upstream/                  Official files copied from omarchy.org / omarchy-site / omarchy
  icon.svg                 Official compact mark (green #9ece6a)
  favicon.png              Current 300×300 tab favicon (RGBA, hollow center)
  layout.html.erb          Current manual <head> template (the file to patch)
  opengraph.png            Current social card
  social.png
  omarchy-distro-*         Mark / ASCII from the distro repo

brand/                     Official brand kit from omarchy-site/brand
  omarchy-logo.svg         Same compact mark
  omarchy-logo.png         4096² PNG of the mark
  omarchy-wordmark.svg     Wide OMARCHY wordmark — do not use as the app icon
  omarchy-wordmark.png

generated/                 Ready-to-ship home-screen icons (opaque, padded)
  apple-touch-icon.png     180×180 — this is the iOS fix
  icon-192.png             Android / manifest
  icon-512.png             Android / splash
  icon-maskable-512.png    Safer padding for adaptive icons
  preview-1024.png         Review / PR screenshot
  mark-transparent-1200.png

patches/
  head-snippet.html        Drop-in <head> tags
  layout.html.erb          Full patched template
  site.webmanifest         Web app manifest

scripts/generate-icons.sh  Rebuild generated/ from upstream/icon.svg
scripts/decode-icons.sh    Recreate generated/*.png from generated-b64/
```

Colours used for the generated icons:

| Token        | Hex       | Why                                      |
|--------------|-----------|------------------------------------------|
| Mark         | `#9ece6a` | Official icon.svg fill                   |
| Background   | `#1a1b26` | Tokyo Night / Omarchy dark canvas        |

The mark is a hollow geometric frame. Transparency is flattened onto `#1a1b26` so iOS cannot fill the holes with black. ~20% padding keeps the rounded-square mask from clipping the strokes.

After cloning, materialize the PNGs:

```bash
./scripts/decode-icons.sh
```

Or rebuild from the official SVG (needs ImageMagick):

```bash
./scripts/generate-icons.sh
```

## Why the existing favicon is not enough

Live `<head>` today (from `templates/layout.html.erb`):

```html
<title><%= h title %> — The Omarchy Manual</title>
<link rel="icon" href="/assets/images/favicon.png">
```

Missing, and required:

1. `<link rel="apple-touch-icon">` — iOS ignores `rel="icon"` for home-screen tiles
2. Opaque 180×180 PNG — the current favicon is 300×300 with a transparent center
3. `apple-mobile-web-app-title` — stops Safari suggesting “The Omarchy Manual”
4. Optional: manifest + `apple-mobile-web-app-capable` so it opens like an app

## Patch the website

### 1. Copy the generated icons into omarchy-site

```bash
git clone https://github.com/aleccool213/omarchy-manual-homescreen-icon
cd omarchy-manual-homescreen-icon
./scripts/decode-icons.sh

# in a sibling checkout of omacom-io/omarchy-site:
cp generated/apple-touch-icon.png  ../omarchy-site/assets/images/apple-touch-icon.png
cp generated/icon-192.png          ../omarchy-site/assets/images/icon-192.png
cp generated/icon-512.png          ../omarchy-site/assets/images/icon-512.png
cp generated/icon-maskable-512.png ../omarchy-site/assets/images/icon-maskable-512.png
cp generated/apple-touch-icon.png  ../omarchy-site/apple-touch-icon.png
cp patches/site.webmanifest        ../omarchy-site/site.webmanifest
```

The extra root `apple-touch-icon.png` is a belt-and-suspenders path. Older iOS still probes `/apple-touch-icon.png` even when the `<link>` is present.

### 2. Edit `templates/layout.html.erb`

Replace:

```html
<link rel="icon" href="/assets/images/favicon.png">
```

with the contents of `patches/head-snippet.html`.

A fully patched copy of the current template is at `patches/layout.html.erb`.

Do the same on every other static `<head>` that only has the favicon, at least:

- `index.html` (homepage)
- any news / themes / foundation layouts that duplicate the tag

### 3. Rebuild the committed manual HTML

The pages under `manual/` are generated and checked in. Changing the ERB alone will not update the live site until:

```bash
cd omarchy-site
# gem install kramdown kramdown-parser-gfm
# imagemagick is already a documented build dependency
bin/build-manual
# or, offline against a local omarchy checkout:
bin/build-manual ../omarchy/manual
```

Confirm the tags landed:

```bash
rg -n "apple-touch-icon|webmanifest|apple-mobile-web-app-title" \
  templates/layout.html.erb index.html manual/index.html
```

### 4. Open the upstream PR

Suggested title:

```
Add apple-touch-icon so iOS home-screen saves use the Omarchy mark
```

Suggested body is in `PR.md`.

Repo to PR against: **https://github.com/omacom-io/omarchy-site**  
(Not `omacom/omarchy` — that is the distro.)

## After it ships: fix the phone

iOS freezes the icon at add-time. Updating the site does not restyle an existing shortcut.

1. Delete the current “Omarchy Manual” icon
2. In Safari, open https://omarchy.org/manual/ and pull-to-refresh
3. Share → Add to Home Screen
4. Accept the suggested name **Omarchy** (from `apple-mobile-web-app-title`)
5. If it is still a T: Settings → Safari → Advanced → Website Data → search `omarchy` → Delete, then add again

## Attribution

Omarchy name, mark, and website source belong to DHH / Omacom. Copied here only so this patch can be reproduced without hunting files across two repos. If you ship this upstream, keep their license and authorship.

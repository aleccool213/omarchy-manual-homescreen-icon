# Suggested pull request against omacom-io/omarchy-site

**Title:** Add apple-touch-icon so iOS home-screen saves use the Omarchy mark

**Against:** https://github.com/omacom-io/omarchy-site (default branch)

Copy the markdown inside the fenced block below into the GitHub PR body.

## Why

Adding https://omarchy.org/manual/ to an iPhone home screen currently
produces a gray monogram tile with the letter **T**.

Safari does that when a site has no `apple-touch-icon`. It invents a
letter from the document title. Every manual page is titled
`… — The Omarchy Manual`, so the letter is T.

The site already has `/assets/images/favicon.png` and `/icon.svg`.
iOS does not use either of those for home-screen icons.

## What

- Opaque 180×180 `apple-touch-icon.png` of the official mark
  (`#9ece6a` on `#1a1b26`, with padding so the rounded-square mask
  does not clip the strokes). Transparency is flattened — iOS fills
  alpha with black and the current favicon is hollow in the center.
- 192 / 512 manifest icons plus `site.webmanifest`.
- `apple-mobile-web-app-title="Omarchy"` so the suggested shortcut
  name is not "The Omarchy Manual".
- Root `/apple-touch-icon.png` because older iOS still probes it.

Icons were generated from the official `icon.svg` already in this
repo. Rebuild with ImageMagick:

```
magick icon.svg -background '#1a1b26' -alpha remove -alpha off \
  -resize 108x108 -gravity center -extent 180x180 \
  -strip assets/images/apple-touch-icon.png
```

## Files

- `templates/layout.html.erb` — new head tags
- `index.html` — same tags on the marketing homepage
- `site.webmanifest`
- `assets/images/apple-touch-icon.png`
- `assets/images/icon-192.png`
- `assets/images/icon-512.png`
- `apple-touch-icon.png` (root copy)
- regenerated `manual/**` via `bin/build-manual`

## Test

1. Open a preview URL in Safari on iPhone.
2. Share → Add to Home Screen.
3. Preview tile should be the green mark on dark, not a letter.
4. Suggested name should be "Omarchy".
5. `curl -sI https://<preview>/assets/images/apple-touch-icon.png` → 200 image/png

# Asset sources

All of these are official Omarchy files, copied 2026-08-31 so this patch kit is self-contained.

## Website (omacom-io/omarchy-site)

| Local path | Origin |
|---|---|
| `upstream/icon.svg` | https://omarchy.org/icon.svg |
| `brand/omarchy-logo.svg` | https://github.com/omacom-io/omarchy-site/blob/master/brand/omarchy-logo.svg |
| `brand/omarchy-wordmark.svg` | https://github.com/omacom-io/omarchy-site/blob/master/brand/omarchy-wordmark.svg |
| `upstream/layout.html.erb` | https://github.com/omacom-io/omarchy-site/blob/master/templates/layout.html.erb |
| tab favicon | https://omarchy.org/assets/images/favicon.png |
| Open Graph card | https://omarchy.org/assets/images/opengraph.png |
| social.png | https://omarchy.org/assets/images/social.png |
| brand PNG (4096) | https://github.com/omacom-io/omarchy-site/blob/master/brand/omarchy-logo.png |
| wordmark PNG | https://github.com/omacom-io/omarchy-site/blob/master/brand/omarchy-wordmark.png |

Large binary brand/OG PNGs are linked rather than vendored here. The mark SVG is the source of truth and is vendored.

## Distro (basecamp/omarchy, also omacom/omarchy)

| Local path | Origin |
|---|---|
| `upstream/omarchy-distro-logo.svg` | https://github.com/basecamp/omarchy/blob/master/logo.svg |
| `upstream/omarchy-distro-icon.txt` | https://github.com/basecamp/omarchy/blob/master/icon.txt |
| `upstream/omarchy-distro-logo.txt` | https://github.com/basecamp/omarchy/blob/master/logo.txt |
| distro icon.png | https://github.com/basecamp/omarchy/blob/master/icon.png |

## Generated here (not upstream)

`generated/*.png` — official mark composited onto `#1a1b26` with padding. Rebuild with `scripts/generate-icons.sh` or restore with `scripts/decode-icons.sh`.

# ACRE Lab website

Website for the Autonomy, Controls, and Robotics Engineering (ACRE) Lab at NC State University. The lab uses control theory to design safe, reliable, and performant autonomous systems.

Built with [Quarto](https://quarto.org) as a static site and published to GitHub Pages by a GitHub Actions workflow (`.github/workflows/publish.yml`) on every push to `main`. `README.md` is the guide for lab members and covers day-to-day updates.

## Commands

- `quarto preview` runs a live local preview.
- `quarto render` builds the site into `_site/` (git-ignored). Run it after any change and fix every warning before finishing.

## Who edits this site

The PI (a Julia/controls researcher, comfortable with code) and a student who edits only through the GitHub web interface. Keep the student-facing workflow simple:

- Routine updates must stay "edit or copy one small file". Never require running code, scripts, or local tools for routine updates.
- If you change a content workflow (papers, news, people, robots, courses, highlight videos), update the matching section of `README.md` in the same change.

## Structure

| Path | Purpose |
| --- | --- |
| `_quarto.yml` | Site title, navbar, footer, format options |
| `theme.scss` | All colors, fonts, and layout rules (single source of styling) |
| `assets/head.html` | Google Fonts links |
| `index.qmd` | Home page: hero, "What we do", News, Research highlights |
| `_research-highlights.qmd` | Videos on the home page (included by `index.qmd`; not rendered alone) |
| `research.qmd`, `join.qmd` | Static pages |
| `teaching.qmd` | Courses, one `::: {.course}` block each (heading, **Offered** line, description) |
| `publications.qmd`, `publications.bib`, `ieee-newest-first.csl` | Publications, generated from the BibTeX file in IEEE style |
| `news.qmd`, `news/posts/*.qmd` | One file per news item |
| `people.qmd`, `people/*.qmd`, `people/photos/` | One file per person (`status: pi`, `phd`, `undergrad-masters`, or `alumni`; `order: N` within each section; role in `subtitle`) |
| `robots.qmd`, `robots/*.qmd`, `robots/photos/` | One file per robot (`order: N`) |
| `assets/logo/` | Vector logo (SVG, PDF) and high-resolution PNGs in red, white, and black |

## Design system

Follow the NC State brand palette (https://brand.ncsu.edu/designing-for-nc-state/color/). Wolfpack Red predominates and Wolfpack Black is the secondary color.

- Wolfpack Red `#CC0000`, Reynolds Red `#990000` and deep red `#7E0000` (hover states), Wolfpack Black `#000000`
- Body text `#333333`, secondary text `#4D4D4D`, rules `#CCCCCC`, light fill `#F2F2F2` (all approved Wolfpack Black tints)
- Headings: Barlow Semi Condensed (echoes the logo lettering). Body: Source Serif 4.
- The only bold element is the full-width red hero on the home page. Keep everything else quiet: white background, black headings, thin rules. Do not add gradients, drop shadows, grids of identical rounded cards, tracked-out all-caps labels, or decorative animation.
- Maintain WCAG AA contrast, visible keyboard focus, responsive layout down to phone width, and `prefers-reduced-motion`.
- Put styles in `theme.scss` using the existing SCSS variables. Avoid inline styles.

## Things that are easy to break

- **Publications grouping.** Pandoc runs citeproc after Lua filters, so `assets/group-by-year.lua` runs citeproc itself inside its `Pandoc` function, inserts year headings, then clears the bibliography metadata so Quarto's own pass does not rebuild the list. It takes each entry's year from the BibTeX data, so it works with any style that sorts newest first. It also reads `month` fields straight from the `.bib` file, because Pandoc ignores full month names such as `{December}`, and passes the corrected references to citeproc so the style can sort by month within a year.
- **Citation style.** `ieee-newest-first.csl` is the official IEEE CSL style with three changes: a newest-first `<sort>` in `<bibliography>` (year, then month), an `issued` macro that prints only the year, and `text-case="title"` on titles and venue names. The second change matters because Pandoc converts English BibTeX titles to sentence case, which lowercases unbraced proper nouns ("lyapunov"); title case restores them. `theme.scss` styles the `[n]` label column (`.csl-left-margin`, `.csl-right-inline`).
- **Listing CSS selectors.** Quarto prefixes listing ids with `listing-`, so people styles target `[id^="listing-people-"]` (plus `#listing-people-alumni` for smaller alumni photos) and robots styles target `#listing-robots`. People listing ids must keep the `people-` prefix; renaming any listing id in a `.qmd` file means checking `theme.scss`.
- **People bios.** People files use `subtitle` (not `description`) for the role. With no `description`, Quarto uses the body's first paragraph, as plain text, as the listing text, and `max-description-length` in `people.qmd` keeps it from being cut off. Adding a `description` field to a person file replaces their bio on the People page.
- **Home page layout.** `index.qmd` uses `page-layout: custom` and raw HTML for the hero. Link targets in raw HTML are rewritten from `.qmd` to `.html` by Quarto, but check after editing.
- **Videos.** Use the Quarto `video` shortcode (YouTube or Vimeo URL, or a file in `assets/videos/`) and always include a `title`. Keep uploaded video files small (under about 25 MB); GitHub rejects files over 100 MB.
- **Logo.** The SVG files in `assets/logo/` are a vector trace of the original wolf mark with lettering rebuilt from the open-source Barlow font. Use these files; do not re-trace or redraw the logo. Use the white versions on red or dark backgrounds.

## Content rules

- Do not invent facts about the lab: people, papers, awards, grants, or results. Use clearly marked placeholders (`PLACEHOLDER` or `EXAMPLE` in an HTML comment) and tell the PI what needs real content.
- Robot specifications on `robots/*.qmd` come from manufacturer pages and datasheets. Do not add specs you cannot verify. The Unitree Go2 page lists typical values; the lab's exact variant (Air, Pro, or Edu) is unconfirmed.
- Do not embed or hotlink third-party product photos. Photos on robot pages should be the lab's own (or properly licensed and credited). Until then, pages use `robots/photos/placeholder.svg`.
- Footer links and email contain `YOUR-` and `your-email@ncsu.edu` placeholders until the PI supplies real ones. Search for `PLACEHOLDER`, `EXAMPLE`, `YOUR-`, and `your-email` to find unfinished items.

## Working style

- Make changes on a new git branch and describe them in the commit message. Do not push directly to `main` unless asked.
- Match the existing patterns (front matter fields, file naming such as `2026-10-title.qmd` for news) rather than introducing new ones.
- Keep the site dependency-light. It currently needs only Quarto; avoid adding build steps that require Python, Node, or Julia for routine updates.

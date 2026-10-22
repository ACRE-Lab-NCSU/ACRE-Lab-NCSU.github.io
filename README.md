# ACRE Lab website

Source for the Autonomy, Controls, and Robotics Engineering (ACRE) Lab website, built with [Quarto](https://quarto.org). Every page is a plain text file. When a change is saved (committed) to the `main` branch on GitHub, the site rebuilds and publishes itself in a minute or two.

## Updating the site from GitHub (no software needed)

Open the file you want in the GitHub repository, click the pencil icon (**Edit this file**), make your change, and click **Commit changes**. To add a new file, use **Add file → Create new file** or **Upload files**.

### Add a paper

1. Open `publications.bib`.
2. Paste the paper's BibTeX entry at the end of the file. You can copy it from Google Scholar (Cite → BibTeX), the publisher's page, or Crossref.
3. Optional: add a `month` field, such as `month = {December}`, `month = dec`, or `month = {12}`. It is used only to sort papers within a year (newest first) and is not shown in the citation. Papers without a month go at the end of their year.
4. Commit. Papers are sorted and grouped by year automatically, and the five newest also appear in "Recent publications" on the home page.

Tip: to make a paper's title a link, add a `url` field to its BibTeX entry, such as `url = {https://arxiv.org/abs/2604.04235},`. If there is no `url` but there is a `doi` field (just the DOI, such as `doi = {10.1109/TAC.2026.1234567},`), the title links to `https://doi.org/` plus the DOI. The link is not printed as text, and it works on both the Publications page and the home page.

Tip: give each entry a unique key (the text right after `@article{`), such as `lastname2026topic`.

Tip: titles are shown in title case. If a word comes out with the wrong capitalization (for example "f-16" instead of "F-16"), wrap it in braces in the BibTeX, such as `{F-16}`. Braces keep text exactly as typed, which also works for a whole field, such as `journal = {{arXiv preprint arXiv:2604.04235}}`.

### Add a news item

1. Open the `news/posts` folder and open any existing post.
2. Copy its contents, then go back and choose **Add file → Create new file**.
3. Name it with the date, such as `news/posts/2026-11-award.qmd`, and paste in the copied text.
4. Change the `title`, `date`, and `description` at the top, and write the post below the second `---` line.
5. Commit. The five newest items also appear on the home page.

### Add or update a person

1. Upload a photo (square works best) to `people/photos/`.
2. Copy an existing file in `people/` (for example `example-student.qmd` for a Ph.D. student, or `example-undergrad.qmd` for an undergraduate or master's student) to a new name, such as `people/jane-doe.qmd`.
3. Edit the top section:
   - `title`: the person's name
   - `subtitle`: their role, such as "PhD student, started Fall 2026"
   - `image`: `photos/your-photo.jpg`
   - `status`: which section of the People page the person appears in:
     - `pi`: Principal Investigator
     - `phd`: Ph.D. Students
     - `undergrad-masters`: Undergraduate and Master's Students
     - `alumni`: Alumni
   - `order`: a number that controls the order within that section (smaller comes first)
4. Write a short bio below the second `---` line. The **first paragraph** appears under the person's name on the People page, so keep it to 2 to 4 sentences. Anything after it (links, contact info, more detail) appears only on the person's own page, which visitors reach by clicking their name. Alumni show only their name and subtitle.
5. Commit.

When someone graduates, change their `status` line to `status: alumni` and update the subtitle. When an undergraduate or master's student starts a Ph.D. in the lab, change `status: undergrad-masters` to `status: phd`.

### Add or update a robot

1. Upload a landscape photo (about 3:2 looks best) to `robots/photos/`.
2. Copy an existing file in `robots/` (for example `unitree-go2.qmd`) to a new name, such as `robots/new-robot.qmd`.
3. Edit the top section:
   - `title`: the robot's name
   - `description`: one or two sentences shown on the Robots page
   - `image`: `photos/your-photo.jpg`
   - `order`: a number that controls the order on the page (smaller comes first)
4. Below the second `---` line, write the robot's page: overview, specifications, links to papers, and videos (see below).
5. Commit.

### Add a research highlight video (home page)

Open `_research-highlights.qmd`. It contains instructions at the top and two gray placeholder boxes.

1. Replace a `<div class="video-placeholder">...</div>` line with a video line:
   - YouTube or Vimeo: `{{< video https://www.youtube.com/watch?v=YOUR_VIDEO_ID title="What the video shows" >}}`
   - A video file: upload the `.mp4` to `assets/videos/`, then use `{{< video assets/videos/my-video.mp4 title="What the video shows" >}}`
2. Edit the title and caption under it.
3. To add another highlight, copy a whole `::: {.highlight}` block (down to its closing `:::`) inside the outer `::: {.highlights}` block.
4. Commit.

An "Unlisted" YouTube video is a good choice: anyone with the link can watch it, but it does not show up in YouTube search. Keep uploaded `.mp4` files under about 25 MB, because GitHub rejects files over 100 MB and large files slow down the repository. The same video line works on any page, including robot pages.

### Add or update a course

1. Open `teaching.qmd`.
2. To add a course, copy one whole block from `::: {.course}` down to its closing `:::` and paste it where you want it on the page. Edit the course number and title (the `##` line), the **Offered** line, and the description.
3. When a course is taught again, add the semester to its **Offered** line, for example `Fall 2025, Fall 2026`.
4. To link a syllabus, upload the PDF to `assets/syllabi/` (**Add file → Upload files**), then add a line such as `**Syllabus:** [PDF](assets/syllabi/ece-492-fall-2025.pdf)` right after the **Offered** line. Each course block already has a commented-out example: delete the `<!--` and `-->` and fix the file name.
5. Commit.

### Edit the text of a page

Research, Join us, and the home page are ordinary text files (`research.qmd`, `join.qmd`, `index.qmd`). Formatting uses Markdown: `## Heading`, `**bold**`, `[link text](https://example.com)`, and `![Caption](assets/figure.png)` for images. Upload images to the `assets/` folder first.

Placeholder text is marked with `PLACEHOLDER` comments, and sample entries (people, news, papers) are marked `EXAMPLE` or named "example". Search the repository for those words to find everything that still needs your content.

## Previewing changes on your own computer (optional)

1. Install [Quarto](https://quarto.org/docs/get-started/).
2. Clone the repository and run `quarto preview` in its folder. The site opens in your browser and refreshes as you save.

## First-time setup (one time, by the lab PI)

1. Create a GitHub repository and upload these files to the `main` branch.
2. In the repository, go to **Settings → Pages** and set **Source** to **GitHub Actions**.
3. The first push triggers a build. The site address appears under **Settings → Pages** and in the **Actions** tab.
4. To let a student edit: **Settings → Collaborators → Add people**. To review changes before they go live, go to **Settings → Branches** and add a protection rule for `main` that requires pull requests.
5. Search the files for `YOUR-` and `your-email@ncsu.edu` and replace them with real links (see `_quarto.yml` for the footer links).

## Project layout

| Path | What it is |
| --- | --- |
| `index.qmd` | Home page |
| `research.qmd`, `join.qmd` | Research and Join us pages |
| `teaching.qmd` | Teaching page: one block per course |
| `publications.bib` | Every paper (edit this to update `publications.qmd`) |
| `news/posts/` | One file per news item |
| `people/` | One file per person, with photos in `people/photos/` |
| `robots/` | One file per robot, with photos in `robots/photos/` |
| `_research-highlights.qmd` | The videos in the Research highlights section of the home page |
| `theme.scss` | Colors, fonts, and layout |
| `_quarto.yml` | Site title, navigation, and footer |
| `assets/logo/` | The lab logo as vector files (SVG, PDF) and high-resolution PNGs |
| `assets/` | Other images, videos (`assets/videos/`), and the script that groups papers by year |

## Design notes

Colors come from the [NC State brand palette](https://brand.ncsu.edu/designing-for-nc-state/color/): Wolfpack Red `#CC0000`, Wolfpack Black `#000000`, and the approved shade `#333333` for body text. Headings use Barlow Semi Condensed and body text uses Source Serif 4, both loaded from Google Fonts. Change the palette or fonts at the top of `theme.scss`.

## Logo files

`assets/logo/` holds the logo in three colors (red, white, black), each as the full logo and as the wolf mark alone:

- **SVG** is for the web. It stays sharp at any size, and this site uses it.
- **PDF** is vector too, for posters, papers, and print. Most slide software (PowerPoint, Keynote, Google Slides) also accepts SVG.
- **PNG** is a high-resolution version with a transparent background (4000 px wide for the full logo, 2000 px for the mark) for places that do not take vector files.

Use the white versions on red or dark backgrounds. The wolf mark is a vector trace of the original artwork, and the lettering is rebuilt from the open-source Barlow typeface (SIL Open Font License) so its edges are clean at any size.

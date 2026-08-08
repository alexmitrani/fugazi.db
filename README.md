# fugazi.db

`fugazi.db` is a data-only R package: the primary source data behind the
[Fugazi Live Series](https://www.dischord.com/fugazi_live_series) - show
listings, venue coordinates, tag/duration data, and discography metadata -
scraped or hand-curated from the FLS website and other sources.

It contains **no processing code**. All cleaning, classification, and
modelling of this data happens in the companion package,
[Repeatr](https://github.com/alexmitrani/Repeatr), which depends on
`fugazi.db` for its raw inputs and produces the derived datasets behind the
[Fugazetteer](https://alexmitrani.shinyapps.io/Fugazetteer/) Shiny app.

## Installation

```r
# install.packages("remotes")
remotes::install_github("alexmitrani/fugazi.db")
```

## What's here

Six lazy-loaded data objects - see `vignette("Data-Catalogue", package = "fugazi.db")`
for a full description of each table, its columns, and the keys used to join
them together.

| Object | Description |
|---|---|
| `fls_data` | One row per show: date, venue, attendance, tracklist, and more |
| `fls_tags_raw` | Per-track duration data, parsed from personal MP3 tag exports |
| `songvarslookup` | Per-song discography metadata (release, vocals, instrumental) |
| `releases` | Per-release metadata (release date, colour code, rating) |
| `song_tempo_bpm_data` | Per-song tempo (BPM) |
| `fls_venue_geocoding` | Venue coordinates |

`data-raw/` holds the plain, human-editable source files these objects are
built from (not part of the installed package) - see Repeatr's
`vignette("Rebuilding-the-Data")` for the refresh workflow.

## Data source and copyright

Show dates, venues, attendance, setlists, and any free-text show notes come
from the [Fugazi Live Series](https://www.dischord.com/fugazi_live_series)
website, copyright Dischord Records. Permission to redistribute this data
openly has been requested and is pending a reply - see
[`LICENSE`](LICENSE) for the current copyright status. Venue geocoding,
corrections, and re-organization into the tables shipped here are original
work by the package maintainer.

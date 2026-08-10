# fugazi.db

`fugazi.db` is a data-only R package containing tidy, corrected reference
data documenting the live performance history of the band Fugazi: show
listings, venue coordinates, track durations, and discography metadata. It
ships no functions - only data - so using it is just a matter of installing
the package and referring to its tables like any other data frame.

## Data source and copyright

Show dates, venues, attendance, and setlists are drawn primarily from the
[Fugazi Live Series](https://www.dischord.com/fugazi_live_series), an
archive maintained by **Dischord Records**, Fugazi's label, and are
copyright Dischord Records. Discography metadata comes from Wikipedia, and
track durations were extracted from a personally tagged MP3 collection.
Venue geocoding and the cleaning, correction, and re-organization of the
raw data into the tables shipped here are original work by the package
maintainer.

Permission to redistribute the Fugazi Live Series data openly has been
requested and is pending a reply - see [`LICENSE`](LICENSE) for the current
copyright status and terms.

## Installation

### If you already use R

```r
# install.packages("remotes")
remotes::install_github("alexmitrani/fugazi.db")
```

### New to R?

If you don't already have R and RStudio installed, follow these steps:

1. **Install R.** Download and run the installer for your operating system
   from [the Comprehensive R Archive Network
   (CRAN)](https://cran.r-project.org/). This installs the R language
   itself.
2. **Install RStudio Desktop.** Download and run the free installer from
   [posit.co/download/rstudio-desktop](https://posit.co/download/rstudio-desktop/).
   RStudio is the application you'll use to write and run R code; it
   requires R (step 1) to already be installed.
3. **Open RStudio.** You'll see a window with several panes - one of them,
   labelled "Console", is where you'll type commands.
4. **Install the `remotes` package**, which lets R install packages
   directly from GitHub. In the Console, type the line below and press
   Enter:

   ```r
   install.packages("remotes")
   ```
5. **Install `fugazi.db`.** In the Console, type the line below and press
   Enter:

   ```r
   remotes::install_github("alexmitrani/fugazi.db")
   ```
6. **Load the package** whenever you want to use its data:

   ```r
   library(fugazi.db)
   shows
   ```

   Typing `shows` on its own and pressing Enter should print the
   show-listings table.

## What's here

Six lazy-loaded data objects - see `vignette("Data-Catalogue", package = "fugazi.db")`
for a full description of each table, its columns, and the keys used to join
them together.

| Object | Description |
|---|---|
| `shows` | One row per show: date, venue, price/currency, attendance, sound quality |
| `locations` | Venue coordinates (latitude/longitude, WGS 84) |
| `durations` | Per-track duration data, keyed by `gid`, parsed from personal MP3 tag exports |
| `discography` | Per-release metadata (release date) |
| `songs` | Per-song studio discography metadata (release, vocals, instrumental) |
| `bands` | One row per show and band Fugazi played with, keyed by `gid` |

Each table is a fact table - corrected and reformatted, but not joined,
summarized, or modelled. Data is refreshed periodically by the maintainer
as new shows are documented or corrections are made to the underlying
sources.

An interactive map and dashboard built on this data is available at
[Fugazetteer](https://alexmitrani.shinyapps.io/Fugazetteer/).

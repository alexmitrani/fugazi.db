# fugazibase

`fugazibase` is a package of tidy data documenting the live performance history of the band Fugazi. 
The data includes details of all the live shows, which songs were played and the durations of 
each track of each live recording, which other bands accompanied Fugazi on each occasion, 
the venue locations, and details of the Fugazi studio discography.  
    

## Data sources

The primary source is the [Fugazi Live Series](https://www.dischord.com/fugazi_live_series) website. 
The Fugazi Live Series data is supplemented with data from other sources, 
for instance to establish the coordinates of the venue locations. 

## Installation

### If you already use R

```r
# install.packages("remotes")
remotes::install_github("alexmitrani/fugazibase")
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
5. **Install `fugazibase`.** In the Console, type the line below and press
   Enter:

   ```r
   remotes::install_github("alexmitrani/fugazibase")
   ```
6. **Load the package** whenever you want to use its data:

   ```r
   library(fugazibase)
   shows
   ```

   Typing `shows` on its own and pressing Enter should print the
   show-listings table.

## What's here

Six lazy-loaded data objects - see `vignette("Data-Catalogue", package = "fugazibase")`
for a full description of each table, its columns, and the variables that can be used to join
them together.

| Object | Description |
|---|---|
| `shows` | One row per show: date, venue, price/currency, attendance, sound quality |
| `locations` | Venue coordinates (latitude/longitude, WGS 84) |
| `durations` | Per-track duration data, extracted from MP3 metadata |
| `discography` | Release dates for the Fugazi studio albums and EPs |
| `songs` | Details of each song in the studio discography: release, vocals, instrumentals |
| `bands` | One row per show and band that played with Fugazi |

Each table is a set of data - corrected and reformatted, but not joined,
summarized, or modelled. 

An interactive web application based on this data can be found at
[Fugazetteer](https://alexmitrani.shinyapps.io/Fugazetteer/).

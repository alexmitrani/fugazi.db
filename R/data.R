#' fugazi.db: Primary Data for the Fugazi Live Series
#'
#' A data-only package of primary source data on the Fugazi Live Series -
#' show listings, venue coordinates, tag/duration data, and discography
#' metadata. Contains no processing code; see the companion package
#' \href{https://github.com/alexmitrani/Repeatr}{Repeatr} for the functions
#' that clean, classify, and model this data. See
#' \code{vignette("Data-Catalogue", package = "fugazi.db")} for a full
#' description of every table and the keys used to join them together.
#'
#' @import lubridate
#' @keywords internal
"_PACKAGE"

# Show data ------------------------------------------------------------

#' Fugazi Live Series show data
#'
#' One row per show, as scraped from the Fugazi Live Series website (via
#' \code{Repeatr::scrape_fls_shows()}), with country/city/venue name
#' inconsistencies against the venue-geocoding data already corrected by
#' hand.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id}
#' \item{fls_id}{Fugazi Live Series id}
#' \item{show_date}{Show date}
#' \item{venue}{Venue}
#' \item{door_price}{Door price}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by}
#' \item{original_source}{Original source}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' \item{played_with}{Bands played with, comma-separated}
#' \item{fls_notes}{Any official note shown on the show's page, `NA` when the show has none}
#' \item{tour}{The touring period the show belongs to, scraped from the FLS listing pages' own tour headings}
#' \item{city}{City, scraped from the FLS listing pages. Not yet disambiguated for cities that share a name with another tour stop (Portland, Columbia, etc.)}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, or Australian state/territory), where applicable (`NA` outside those three countries)}
#' \item{country}{Country, scraped from the FLS listing pages}
#' \item{track_1-track_n}{Tracks, one column per track slot up to the widest tracklist in the data}
#' }
#' @section Provenance: Raw-scraped. `venue`/`city`/`country` values are hand-corrected against `fls_venue_geocoding`'s spelling (a one-time cleanup - see `Repeatr`'s `vignette("Rebuilding-the-Data")`); everything else is exactly as scraped.
#' @examples
#' fls_data
"fls_data"

# Tag/duration data ------------------------------------------------------

#' Fugazi Live Series tag/duration data
#'
#' Per-track duration data, parsed from a personally-tagged MP3 collection
#' exported with \href{https://kid3.kde.org/}{kid3}. Track names with known
#' typos/inconsistencies (e.g. multiple spellings of the same song) have
#' been hand-corrected to a single canonical spelling; every other field is
#' exactly as exported.
#'
#' @source Personal MP3 collection, tagged against Fugazi Live Series recordings.
#' @format dataframe with one row for each track in the tagged collection.
#' \describe{
#' \item{track}{Track number within its album/show}
#' \item{artist}{Artist tag, always "Fugazi"}
#' \item{album}{Album tag, in the form "YYYYMMDD Venue, City, State, Country" - the raw text is not itself parsed into structured fields here; `Repeatr`'s show data (joined by `gid`) is the authoritative source for venue/city/subdivision/country}
#' \item{name}{Track/song name, as tagged (hand-corrected for known typos)}
#' \item{duration}{Track duration, an hms `Period` object}
#' \item{seconds}{Track duration in seconds}
#' \item{minutes}{Track duration in minutes, rounded to 2 decimal places}
#' }
#' @section Provenance: Raw-hand-curated. Track names are hand-corrected for known typos/spelling variants (a one-time cleanup - see `Repeatr`'s `vignette("Rebuilding-the-Data")`); duration is mechanically parsed from the kid3 export, not otherwise altered.
#' @examples
#' fls_tags_raw
"fls_tags_raw"

# Discography metadata --------------------------------------------------

#' Fugazi songs data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables
#' attributing lead vocals are simplifications in some cases where lead
#' vocals were shared.
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{track_number}{The track number for the song on the release}
#' \item{song}{The name of the song - the join key used to attach this data to `Repeatr`'s show data, not a hardcoded id column, so it can't drift out of sync with song identity assigned there}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' }
#' @section Provenance: Raw-hand-curated. Edited by hand against Wikipedia.
#' @examples
#' songvarslookup
"songvarslookup"

#' Fugazi releases data
#'
#' Per-release metadata for the Fugazi discography.
#'
#' @format dataframe with one row for each release.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order}
#' \item{release}{release name}
#' \item{variable}{release name in snake_case, for use as a variable name}
#' \item{releasedate}{release date}
#' \item{release_date_source}{source of the release date}
#' \item{colour_code}{hex colour code, hand-assigned for use in graphs}
#' \item{rym_rating}{rateyourmusic.com rating, scaled to the interval between 0 and 1}
#' }
#' @section Provenance: Raw-hand-curated. `colour_code` is a manual assignment; `rym_rating` is sourced from rateyourmusic.com.
#' @examples
#' releases
"releases"

#' Song tempo BPM data
#'
#' @source Tempos of selected songs measured with the 'liveBPM' app for Android and also finger tapping with a timer.
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{song}{The name of the song}
#' \item{tempo_bpm}{The tempo of the song in beats per minute}
#' }
#' @section Provenance: Raw-hand-curated. Manually compiled per-song tempo.
#' @examples
#' song_tempo_bpm_data
"song_tempo_bpm_data"

# Venue coordinates -------------------------------------------------------

#' Fugazi Live Series venue geocoding data
#'
#' Venue coordinates for the Fugazi Live Series, a periodically-refreshed
#' local snapshot of a private Google Sheet used to look up and confirm
#' venue locations on Google Maps.
#'
#' @format dataframe with one row for each known venue.
#' \describe{
#' \item{country}{Country}
#' \item{city}{City - disambiguated as "City (ST)"/"City (Country)" for cities that share a name with another tour stop (Portland, Columbia, Croydon, Oxford, Newcastle)}
#' \item{venue}{Venue name}
#' \item{googlemaps_hyperlink}{Link to the venue's location on Google Maps, where looked up this way}
#' \item{find1}{Helper column used while looking up coordinates on Google Maps}
#' \item{find2}{Helper column used while looking up coordinates on Google Maps}
#' \item{find3}{Helper column used while looking up coordinates on Google Maps}
#' \item{y}{Latitude}
#' \item{x}{Longitude}
#' \item{test_coordinates}{Helper column used while looking up coordinates on Google Maps}
#' }
#' @section Provenance: Raw-hand-curated. Periodically re-synced from a private Google Sheet; also includes a small number of venues consolidated in from two now-retired sources (`fugazi-small.csv`'s coordinate fallback and `othervariables_patch.csv`'s per-show rescue rows) as part of a one-time cleanup - see `Repeatr`'s `vignette("Rebuilding-the-Data")`.
#' @examples
#' fls_venue_geocoding
"fls_venue_geocoding"

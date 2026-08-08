#' fugazi.db: Tidy Data from the Fugazi Live Series
#'
#' tidy data derived from the Fugazi Live Series and related sources -
#' show listings, venue coordinates, durations, and discographical information.
#' See \code{vignette("Data-Catalogue", package = "fugazi.db")} for a full
#' description of every table and the keys used to join them together.
#'
#' @import lubridate
#' @keywords internal
"_PACKAGE"

# Show data ------------------------------------------------------------

#' Fugazi Live Series show data
#'
#' One row per show, as scraped from the Fugazi Live Series website (via
#' \code{Repeatr::scrape_fls_shows()}) and cleaned/corrected by
#' \code{Repeatr::Repeatr_1()} - country/city/venue name inconsistencies
#' against the venue-geocoding data corrected by hand, coordinates and sound
#' quality joined in. Free-text show notes are deliberately excluded (see
#' this package's \code{LICENSE}).
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id - a slug built from city, country, and date (e.g. "washington-dc-usa-90387"); the primary key of this table and of every other table in this package that has a `gid` column}
#' \item{flsid}{Fugazi Live Series id}
#' \item{date}{Show date}
#' \item{venue}{Venue}
#' \item{doorprice}{Door price}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by}
#' \item{original_source}{Original source}
#' \item{tour}{The touring period the show belongs to, scraped from the FLS listing pages' own tour headings}
#' \item{city}{City - plain city name (e.g. "Portland", "Columbia", "Croydon"); see `subdivision`/`country` to disambiguate cities that share a name with another Fugazi tour stop}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, or Australian state/territory), where applicable (`NA` outside those three countries)}
#' \item{country}{Country}
#' \item{year}{Year}
#' \item{checked}{`1` indicates the coordinates were checked/confirmed by the maintainer; `0` otherwise}
#' \item{x}{Longitude}
#' \item{y}{Latitude}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' \item{seconds}{Total recorded duration of the show, in seconds, where a recording is available}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `othervariables` object, joined with `gid_sound_quality` and duration, minus `fls_notes`). Only covers shows with a resolvable `tour` and coordinates - not literally every show ever scraped, since `Repeatr::Repeatr_1()` filters those out upstream. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' fls_shows
"fls_shows"

# Venue coordinates -------------------------------------------------------

#' Fugazi Live Series venue geocoding data
#'
#' Venue coordinates for the Fugazi Live Series.
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
#' @section Provenance: Raw-hand-curated. A direct, unmodified copy of Repeatr's own `inst/extdata/fls_venue_geocoding_v2.csv` - not necessarily sufficient on its own to reproduce every coordinate in `fls_shows`, since a handful of venues are resolved in `Repeatr::Repeatr_1()` via hardcoded per-venue corrections rather than this table. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' fls_venue_geocoding
"fls_venue_geocoding"

# Tag/duration data ------------------------------------------------------

#' Fugazi Live Series tag/duration data
#'
#' Duration data for each Fugazi Live Series audio track,
#' extracted from MP3 files with \href{https://kid3.kde.org/}{kid3}.
#' Some corrections were made in a few cases.
#'
#' @source Fugazi Live Series.
#' @format dataframe with one row for each track in the tagged collection.
#' \describe{
#' \item{gid}{show id, references \code{\link{fls_shows}}}
#' \item{date}{Show date}
#' \item{track}{Track number within its album/show}
#' \item{song}{Track/song name, as tagged (hand-corrected for known typos)}
#' \item{duration}{Track duration, an hms `Period` object}
#' \item{seconds}{Track duration in seconds}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `fls_tags` object). `gid` is resolved there via `Repeatr::Repeatr_1()`'s authoritative parser for the raw `album` tag text - don't re-parse `album` by hand. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' fls_tags
"fls_tags"

# Discography metadata --------------------------------------------------

#' Fugazi releases data
#'
#' Metadata for the Fugazi discography.
#'
#' @format dataframe with one row for each release.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order, references \code{\link{songvarslookup}}}
#' \item{release}{release name}
#' \item{variable}{release name in snake_case, for use as a variable name}
#' \item{releasedate}{release date}
#' \item{release_date_source}{source of the release date}
#' \item{rym_rating}{rateyourmusic.com rating, scaled to the interval between 0 and 1}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `releasesdatalookup` object, minus the graph-only `colour_code` column and the four synthetic bucket rows). `rym_rating` is sourced from rateyourmusic.com. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' releases
"releases"

#' Fugazi songs data
#'
#' Song data from the Fugazi discography pages on Wikipedia. The variables
#' attributing lead vocals are simplifications in some cases where lead
#' vocals were shared.
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{releaseid}{numeric id of the release the song appears on, references \code{\link{releases}}}
#' \item{track_number}{The track number for the song on the release}
#' \item{song}{The name of the song - a text join key, not a hardcoded id column; see \code{\link{songidlookup}} for a stable numeric `songid`}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{duration_seconds}{The duration of the song in seconds}
#' }
#' @section Provenance: Raw-hand-curated, edited by hand against Wikipedia; read as-is by `Repeatr::Repeatr_1()`. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' songvarslookup
"songvarslookup"

#' Song tempo BPM data
#'
#' @source Tempos of selected songs measured with the 'liveBPM' app for Android and also finger tapping with a timer.
#' @format dataframe with one row for each song with a personally-measured tempo reading.
#' \describe{
#' \item{song}{The name of the song}
#' \item{tempo_bpm}{The tempo of the song in beats per minute}
#' }
#' @section Provenance: Raw-hand-curated, manually compiled per-song tempo; read as-is by `Repeatr::Repeatr_1()`. Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' song_tempo_bpm_data
"song_tempo_bpm_data"

#' Fugazi song id lookup table
#'
#' A stable numeric `songid` for every song.
#'
#' @format dataframe with one row for each song in the Fugazi discography, except those which never appear in the Fugazi Live Series data.
#' \describe{
#' \item{songid}{numeric id for each song, based on the alphabetical order of the song names}
#' \item{song}{The name of the song}
#' \item{count}{The number of times the song was performed according to the data}
#' }
#' @section Provenance: Derived-classified in `Repeatr` (its `songidlookup` object) - the single source of truth for song identity, computed from the live classified song set, not hand-edited.
#' @examples
#' songidlookup
"songidlookup"

# Bands played with --------------------------------------------------------

#' Fugazi Live Series data on bands that Fugazi played with
#' One row per show and band Fugazi played with.
#' In a few cases extra information was added from other sources.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show and band Fugazi played with.
#' \describe{
#' \item{gid}{show id, references \code{\link{fls_shows}}}
#' \item{fls_id}{Fugazi Live Series id}
#' \item{played_with}{Band name}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `played_with` object). Exported as-is by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' played_with
"played_with"

#' Fugazi Live Series data on bands that Fugazi played with, combined with show data and coordinates
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @source https://arquivomotor.wordpress.com/1994/08/12/bhrif-programacao/
#' @format dataframe with one row for each show and band Fugazi played with.
#' \describe{
#' \item{gid}{show id, references \code{\link{fls_shows}}}
#' \item{fls_link}{link to the corresponding page on the Fugazi Live Series site}
#' \item{year}{year}
#' \item{tour}{tour}
#' \item{date}{date}
#' \item{venue}{Venue}
#' \item{city}{city}
#' \item{country}{country}
#' \item{played_with}{Band name}
#' \item{attendance}{Attendance}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' \item{latitude}{latitude}
#' \item{longitude}{longitude}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `played_with_data` object). Exported as-is by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' played_with_data
"played_with_data"

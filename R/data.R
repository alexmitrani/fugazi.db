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
#' against the venue-geocoding data corrected by hand, sound quality joined
#' in.
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
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `othervariables` object, joined with `gid_sound_quality`, minus `fls_notes`, `year`, `checked`, `x`, `y` - venue coordinates live in \code{\link{fls_venue_geocoding}} instead). Only covers shows with a resolvable `tour` and coordinates - not literally every show ever scraped, since `Repeatr::Repeatr_1()` filters those out upstream. Exported by \code{Repeatr::export_fugazidb_data()}.
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
#' \item{y}{Latitude}
#' \item{x}{Longitude}
#' }
#' @section Provenance: Raw-hand-curated, from Repeatr's own `inst/extdata/fls_venue_geocoding_v2.csv` (minus its Google-Maps-lookup helper columns: `googlemaps_hyperlink`, `find1`, `find2`, `find3`, `test_coordinates`) - not necessarily sufficient on its own to reproduce every coordinate in `fls_shows`, since a handful of venues are resolved in `Repeatr::Repeatr_1()` via hardcoded per-venue corrections rather than this table. Exported by \code{Repeatr::export_fugazidb_data()}.
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
#' \item{track}{Track number within its album/show}
#' \item{song}{Track/song name, as tagged (hand-corrected for known typos); references \code{\link{discography}}}
#' \item{duration}{Track duration, an hms `Period` object}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `fls_tags` object). `gid` is resolved there via `Repeatr::Repeatr_1()`'s authoritative parser for the raw `album` tag text - don't re-parse `album` by hand. Exported (minus `date` - join \code{\link{fls_shows}} on `gid` instead - and `seconds`, which duplicated `duration`; `track` converted from character to integer) by \code{Repeatr::export_fugazidb_data()}.
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
#' \item{releaseid}{numeric id in ascending chronological order, references \code{\link{discography}}}
#' \item{release}{release name}
#' \item{releasedate}{release date}
#' \item{release_date_source}{source of the release date}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `releasesdatalookup` object, minus the graph-only `colour_code` column, the snake_case `variable` column, the rateyourmusic.com-sourced `rym_rating` column, and the four synthetic bucket rows). Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' releases
"releases"

#' Fugazi studio discography data
#'
#' One row per song in the Fugazi studio discography, from Wikipedia. The
#' variables attributing lead vocals are simplifications in some cases where
#' lead vocals were shared.
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{song}{The name of the song - the join key this table (and \code{\link{fls_tags}}) is keyed on}
#' \item{releaseid}{numeric id of the release the song appears on, references \code{\link{releases}}}
#' \item{release_track}{The song's track number on its studio release (distinct from \code{\link{fls_tags}}'s `track`, which numbers a specific live/tagged recording)}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{release_duration}{The song's duration on its studio release, an hms `Period` object (same format as \code{\link{fls_tags}}'s `duration`)}
#' }
#' @section Provenance: Raw-hand-curated in `Repeatr` (its `songvarslookup` object, edited by hand against Wikipedia). Exported (`track_number`/`duration_seconds` renamed to `release_track`/`release_duration`, the latter converted from seconds to a `Period`) by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' discography
"discography"

# Bands played with --------------------------------------------------------

#' Fugazi Live Series data on bands that Fugazi played with
#' One row per show and band Fugazi played with.
#' In a few cases extra information was added from other sources.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show and band Fugazi played with.
#' \describe{
#' \item{gid}{show id, references \code{\link{fls_shows}}}
#' \item{played_with}{Band name}
#' }
#' @section Provenance: Derived-cleaned in `Repeatr` (its `played_with` object). Exported by \code{Repeatr::export_fugazidb_data()}.
#' @examples
#' played_with
"played_with"

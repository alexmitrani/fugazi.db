#' fugazi.db: Tidy Data from the Fugazi Live Series
#'
#' Tidy, corrected reference data documenting the live performance history
#' of the band Fugazi - show listings, venue coordinates, durations, and
#' discography metadata - sourced primarily from the Fugazi Live Series
#' website maintained by Dischord Records. See
#' \code{vignette("Data-Catalogue", package = "fugazi.db")} for a full
#' description of every table and the keys used to join them together.
#'
#' @import lubridate
#' @keywords internal
"_PACKAGE"

# Show data ------------------------------------------------------------

#' Fugazi Live Series show data
#'
#' One row per show, scraped from the Fugazi Live Series website and
#' cleaned by the package maintainer - country/city/venue names corrected
#' against \code{\link{locations}}, sound quality joined in, and the raw
#' door-price text split into a numeric price and its currency.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show.
#' \describe{
#' \item{gid}{show id - a slug built from city, country, and date (e.g. "washington-dc-usa-90387"); the primary key of this table and of every other table in this package that has a `gid` column}
#' \item{flsid}{Fugazi Live Series id}
#' \item{date}{Show date}
#' \item{venue}{Venue}
#' \item{price}{Door price, numeric}
#' \item{currency}{Door price's currency, an ISO 4217 three-letter code (e.g. "USD", "GBP") - `NA` when the door price is unknown. Reflects the currency in use in that country at the time of the show, which may differ from its currency today (several countries' shows predate that country's adoption of the euro).}
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
#' @section Provenance: Only covers shows with a resolvable `tour` and known coordinates - not literally every show ever documented on the Fugazi Live Series website. Venue coordinates are not included here; join \code{\link{locations}} on `country`, `city`, and `venue` to attach them.
#' @examples
#' shows
"shows"

# Venue coordinates -------------------------------------------------------

#' Fugazi Live Series venue geocoding data
#'
#' Venue coordinates for the Fugazi Live Series, hand-curated and verified
#' by the package maintainer.
#'
#' @format dataframe with one row for each known venue.
#' \describe{
#' \item{country}{Country}
#' \item{city}{City - plain city name (e.g. "Portland", "Columbia", "Croydon"), matching \code{\link{shows}}'s `city` column so the two tables join cleanly. Not unique by itself within a country: a handful of cities share a name with another tour stop (Portland, Columbia, Croydon, Newcastle, Oxford, Springfield) - join on `country`, `city`, and `venue` together to identify a specific location.}
#' \item{venue}{Venue name}
#' \item{latitude}{Latitude, in decimal degrees, using the WGS 84 datum}
#' \item{longitude}{Longitude, in decimal degrees, using the WGS 84 datum}
#' }
#' @section Provenance: Coordinates defined by package maintainer using information from the Fugazi Live Series and other sources.
#' @examples
#' locations
"locations"

# Tag/duration data ------------------------------------------------------

#' Fugazi Live Series tag/duration data
#'
#' Duration data for each Fugazi Live Series audio track,
#' extracted from MP3 files with \href{https://kid3.kde.org/}{kid3}.
#' Some corrections were made in a few cases.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each track in the tagged collection.
#' \describe{
#' \item{gid}{show id, references \code{\link{shows}}}
#' \item{track}{Track number within its album/show}
#' \item{song}{Track/song name, as tagged (hand-corrected for known typos); references \code{\link{songs}}}
#' \item{duration}{Track duration, an hms `Period` object}
#' }
#' @section Provenance: `gid` is derived by the package maintainer from each track's raw album tag text using a fixed parsing convention - don't attempt to re-derive it yourself; join \code{\link{shows}} on `gid` instead to attach a show's date and other details.
#' @examples
#' durations
"durations"

# Discography metadata --------------------------------------------------

#' Fugazi releases data
#'
#' Metadata for the Fugazi discography.
#'
#' @format dataframe with one row for each release.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order, references \code{\link{songs}}}
#' \item{release}{release name}
#' \item{releasedate}{release date}
#' \item{release_date_source}{source of the release date}
#' }
#' @examples
#' discography
"discography"

#' Fugazi studio discography data
#'
#' One row per song in the Fugazi studio discography, from Wikipedia. The
#' variables attributing lead vocals are simplifications in some cases where
#' lead vocals were shared.
#'
#' @source https://web.archive.org/web/20201112000517/http://en.wikipedia.org/wiki/Fugazi_discography
#' @format dataframe with one row for each song in the Fugazi discography.
#' \describe{
#' \item{song}{The name of the song - the join key this table (and \code{\link{durations}}) is keyed on}
#' \item{releaseid}{numeric id of the release the song appears on, references \code{\link{discography}}}
#' \item{release_track}{The song's track number on its studio release (distinct from \code{\link{durations}}'s `track`, which numbers a specific live/tagged recording)}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{release_duration}{The song's duration on its studio release, an hms `Period` object (same format as \code{\link{durations}}'s `duration`)}
#' }
#' @examples
#' songs
"songs"

# Bands played with --------------------------------------------------------

#' Fugazi Live Series data on bands that Fugazi played with
#'
#' One row per show and band Fugazi played with. In a few cases extra
#' information was added from other sources.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format dataframe with one row for each show and band Fugazi played with.
#' \describe{
#' \item{gid}{show id, references \code{\link{shows}}}
#' \item{band}{Band name}
#' }
#' @examples
#' bands
"bands"

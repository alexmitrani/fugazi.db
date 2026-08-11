#' fugazibase: Tidy Data from the Fugazi Live Series
#'
#' Tidy, corrected reference data documenting the live performance history
#' of the band Fugazi - show listings, venue coordinates, durations, and
#' discography metadata - sourced primarily from the Fugazi Live Series
#' website maintained by Dischord Records. See
#' \code{vignette("Data-Catalogue", package = "fugazibase")} for a full
#' description of every table and the keys used to join them together.
#'
#' @import lubridate
#' @keywords internal
"_PACKAGE"

# Show data ------------------------------------------------------------

#' Fugazi Live Series show data
#'
#' One row per show. Door price text split into price and currency variables.
#' Subdivision corrected, patched and extended to include Brazilian states.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format Data frame with 1049 observations and 15 variables.
#' \describe{
#' \item{gid}{show id - a slug built from city, country, and date (e.g. "washington-dc-usa-90387"); the primary key of this table and of every other table in this package that has a `gid` column}
#' \item{flsid}{Fugazi Live Series id}
#' \item{date}{Show date, in format YYYY-MM-DD}
#' \item{venue}{Venue}
#' \item{price}{Door price, numeric}
#' \item{currency}{Door price's currency, an ISO 4217 three-letter code (e.g. "USD", "GBP") - `NA` when the door price is unknown. Reflects the currency in use in that country at the time of the show, which may differ from its currency today (several countries' shows predate that country's adoption of the euro).}
#' \item{attendance}{Attendance}
#' \item{recorded_by}{Recorded by}
#' \item{mastered_by}{Mastered by}
#' \item{original_source}{Original source}
#' \item{tour}{The touring period the show belongs to, scraped from the FLS listing pages' own tour headings}
#' \item{city}{City - plain city name (e.g. "Portland", "Columbia", "Croydon"); see `subdivision`/`country` to disambiguate cities that share a name with another Fugazi tour stop}
#' \item{subdivision}{Subnational administrative unit (US state, DC, Canadian province, Australian state/territory, or Brazilian state), where applicable (`NA` elsewhere)}
#' \item{country}{Country}
#' \item{sound_quality}{Sound quality rating: Excellent, Very Good, Good, or Poor}
#' }
#' @section Notes: Venue coordinates are not included here; join \code{\link{locations}} on `country`, `city`, and `venue` to attach them.
#' @examplesIf requireNamespace("dplyr", quietly = TRUE)
#' # to calculate number of shows by sound quality rating:
#' shows |>
#' dplyr::group_by(sound_quality) |>
#' dplyr::summarize(number_shows = dplyr::n()) |>
#' dplyr::ungroup() |>
#' dplyr::arrange(desc(number_shows))
"shows"

# Venue coordinates -------------------------------------------------------

#' Fugazi Live Series venue location data
#'
#' Venue coordinates for the Fugazi Live Series, hand-curated with reference to
#' the available information for each show on the Fugazi Live Series website and elsewhere.
#'
#' @format Data frame with 754 observations and 5 variables.
#' \describe{
#' \item{country}{Country}
#' \item{city}{City name (e.g. "Portland", "Columbia", "Croydon"), matching \code{\link{shows}}'s `city` column so the two tables join cleanly. Not unique by itself within a country: a handful of cities share a name with another tour stop (Portland, Columbia, Croydon, Newcastle, Oxford, Springfield) - join on `country`, `city`, and `venue` together to identify a specific location.}
#' \item{venue}{Venue name}
#' \item{latitude}{Latitude, in decimal degrees, using the WGS 84 datum}
#' \item{longitude}{Longitude, in decimal degrees, using the WGS 84 datum}
#' }
#' @section Notes: Precision of the coordinates will vary
#' depending on the available information in each case.
#' @examplesIf requireNamespace("dplyr", quietly = TRUE)
#' # to calculate number of venues per country
#' locations |>
#' dplyr::group_by(country) |>
#' dplyr::summarize(number_venues = dplyr::n()) |>
#' dplyr::ungroup() |>
#' dplyr::arrange(desc(number_venues))
"locations"

# Duration data ------------------------------------------------------

#' Fugazi Live Series duration data
#'
#' Duration data for each Fugazi Live Series audio track,
#' extracted from MP3 files with \href{https://kid3.kde.org/}{kid3}.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format Data frame with 24513 observations and 4 variables.
#' \describe{
#' \item{gid}{show id. References \code{\link{shows}}}
#' \item{track}{Track number within each album}
#' \item{song}{Track name. References \code{\link{songs}}}
#' \item{duration}{Track duration, an hms `Period` object}
#' }
#' @section Notes: MP3 tags were edited to get a consistent format for each album,
#' and some corrections were made.
#' join \code{\link{shows}} on `gid` to attach a show's date and other details.
#' join \code{\link{songs}} on `song` to attach details of each song.
#' @examples
#' # to calculate total duration summed across all tracks. Duration is converted to seconds,
#' # then summed, then converted back to period format which displays time in normal units.
#' durations |>
#' dplyr::group_by() |>
#' dplyr::summarize(total_duration = lubridate::seconds_to_period(
#' sum(lubridate::period_to_seconds(duration)))) |>
#' dplyr::ungroup()
"durations"

# Discography metadata --------------------------------------------------

#' Fugazi releases data
#'
#' One observation for each studio album or EP.
#'
#' @format Data frame with 11 observations of 3 variables.
#' \describe{
#' \item{releaseid}{numeric id in ascending chronological order, references \code{\link{songs}}}
#' \item{release}{release name}
#' \item{releasedate}{Release date, in format YYYY-MM-DD.}
#' }
#' @section Notes:
#' | Release | Release date source |
#' |---|---|
#' | fugazi | <https://rateyourmusic.com/release/ep/fugazi/fugazi/> |
#' | margin walker | <https://www.dischord.com/release/035/margin-walker> |
#' | 3 songs | <https://musicbrainz.org/release-group/43766318-cb47-4398-a877-0bfcbb09ad5a> |
#' | repeater | <https://fugazi.bandcamp.com/album/repeater-3-songs> |
#' | steady diet of nothing | <https://fugazi.bandcamp.com/album/steady-diet-of-nothing> |
#' | in on the killtaker | <https://www.officialcharts.com/artist/33439/fugazi/> |
#' | red medicine | <https://www.officialcharts.com/artist/33439/fugazi/> |
#' | end hits | <https://www.officialcharts.com/artist/33439/fugazi/> |
#' | the argument | <https://musicbrainz.org/release-group/7b1cb5fb-7ba5-3472-a687-1cb8f2d896e7> |
#' | furniture | <https://musicbrainz.org/release-group/4042fe4e-0444-338b-9f2a-ac80faabcb1f> |
#' | first demo | <https://musicbrainz.org/release-group/753fb03e-65f5-4805-afe9-373ed573cf87> |
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
#' @format Data frame with 92 observations of 8 variables.
#' \describe{
#' \item{song}{The name of the song - can be used to join this table with \code{\link{durations}}}
#' \item{releaseid}{numeric id of the release the song appears on, references \code{\link{discography}}}
#' \item{release_track}{The song's track number on the studio release (distinct from \code{\link{durations}}'s `track`, which numbers a specific live recording)}
#' \item{instrumental}{Indicates whether or not the piece is an instrumental}
#' \item{vocals_picciotto}{indicates whether or not Guy Picciotto sang lead vocals on this track}
#' \item{vocals_mackaye}{indicates whether or not Ian Mackaye sang lead vocals on this track}
#' \item{vocals_lally}{indicates whether or not Joe Lally sang lead vocals on this track}
#' \item{release_duration}{The song's duration on its studio release, an hms `Period` object (same format as \code{\link{durations}}'s `duration`)}
#' }
#' @examples
#' # join the discography and songs data frames, order by releaseid and release_track
#' discography |> dplyr::left_join(songs) |> dplyr::arrange(releaseid, release_track)
"songs"

# Bands played with --------------------------------------------------------

#' Fugazi Live Series data on bands that Fugazi played with
#'
#' One row per show and band Fugazi played with. In a few cases extra
#' information was added from other sources.
#'
#' @source https://www.dischord.com/fugazi_live_series
#' @format Data frame with 1669 observations of 2 variables.
#' \describe{
#' \item{gid}{show id, can be used to join with \code{\link{shows}}}
#' \item{band}{Band name}
#' }
#' @examples
#' # rank the bands by the number of times they played with Fugazi.
#' bands |>
#' dplyr::group_by(band) |>
#' dplyr::summarize(number_shows = dplyr::n()) |>
#' dplyr::ungroup() |>
#' dplyr::arrange(desc(number_shows))
"bands"

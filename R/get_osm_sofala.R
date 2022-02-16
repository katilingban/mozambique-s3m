################################################################################
#
#'
#' Get OSM data for specified aread in Mozambique
#'
#'
#
################################################################################

get_osm_features <- function(area) {
  area |>
    sf::st_bbox() |>
    osmdata::opq() |>
    osmdata::add_osm_feature(key = "highway") |>
    osmdata::osmdata_sf()
}



################################################################################
#
#'
#' Plot small-scale map
#'
#
################################################################################

plot_sofala_map <- function(moz_provinces, 
                              sofala_province, 
                              sofala_district,
                              filename = "outputs/sofala_small_scale.png") {
  png(filename = filename, width = 10, height = 10, units = "in", res = 200)
  
  par(mar = c(0, 0 , 0, 0))
  
  plot(sf::st_geometry(sofala_province), lty = 0)
  plot(sf::st_geometry(moz_provinces), lwd = 5, border = "gray50", add = TRUE)
  plot(sf::st_geometry(sofala_district), add = TRUE)
  plot(sf::st_geometry(sofala_province), lwd = 3, add = TRUE)
  text(
    x = sp::coordinates(sf::as_Spatial(moz_provinces)),
    labels = toupper(moz_provinces$ADM1_PT),
    cex = 2,
    col = "gray70"
  )
  text(
    x = sp::coordinates(sf::as_Spatial(sofala_district)),
    labels = sofala_district$ADM2_PT,
    col = "blue"
  )
  
  dev.off()
}



################################################################################
#
#'
#' Plot Sofala gridded map
#'
#
################################################################################

plot_sofala_grid <- function(moz_provinces, 
                            sofala_province, 
                            sofala_district,
                            sofala_sp_12,
                            sofala_grid_12,
                            filename = "outputs/sofala_grid_12.png") {
  png(filename = filename, width = 10, height = 10, units = "in", res = 200)
  
  par(mar = c(0, 0 , 0, 0))
  
  plot(sf::st_geometry(sofala_province), lty = 0)
  plot(sf::st_geometry(moz_provinces), lwd = 5, border = "gray50", add = TRUE)
  plot(sf::st_geometry(sofala_district), add = TRUE)
  plot(sf::st_geometry(sofala_province), lwd = 3, add = TRUE)
  text(
    x = sp::coordinates(sf::as_Spatial(moz_provinces)),
    labels = toupper(moz_provinces$ADM1_PT),
    cex = 2,
    col = "gray70"
  )
  text(
    x = sp::coordinates(sf::as_Spatial(sofala_district)),
    labels = sofala_district$ADM2_PT,
    col = "blue"
  )
  sp::plot(sofala_sp_12, pch = 20, cex = 1.5, col = "red", add = TRUE)
  sp::plot(sofala_grid_12, lwd = 1.5, border = "darkgreen", add = TRUE)
  
  dev.off()
}
################################################################################
#
#'
#' Plot choropleth maps
#'
#
################################################################################

plot_choropleth_map <- function(var,
                                results_map,
                                main = NULL,
                                n = 11,
                                pal = viridis::viridis(n = n),
                                breaks = "equal",
                                file_path) {
  check_vars <- tryCatch(
    classInt::classIntervals(
      var = results_map[[var]],
      n = n, style = breaks
    ),
    error = function(e) e,
    warning = function(w) w
  )
  
  if (inherits(check_vars, c("error", "warning"))) {
    NULL
  } else {
    png(filename = file_path, width = 10, height = 10, units = "in", res = 200)
    par(mar = c(0,0,0,0))
    
    plot(
      x = results_map[var],
      main = NULL,
      pal = pal,
      nbreaks = n,
      breaks = breaks,
      key.pos = 4,
      lwd = 1.5,
      border = "gray70",
      reset = FALSE
    )
    
    text(
      x = sf::st_centroid(results_map) |> sf::st_coordinates(),
      labels = results_map[["ADM2_PT"]],
      col = "gray50"
    )
    
    title(main = main, cex.main = 0.85, line = -2)
    
    dev.off()
  }
}

plot_choropleth_maps <- function(var,
                                 results_map,
                                 n = 5,
                                 pal = viridis::viridis(n = n),
                                 breaks = "equal",
                                 indicator_list) {
  set <- indicator_list |>
    subset(indicator_variable %in% var) |>
    (\(x)
     paste0(
       tolower(x[["indicator_group"]]), "_", x[["id"]]
     )
    )()
  
  file_paths <- paste0("outputs/choropleth/", set, "_", var, ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% var, select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)
  
  parallel::mcMap(
    f = plot_choropleth_map,
    var = as.list(var),
    results_map = rep(list(results_map), length(var)),
    main = as.list(main),
    n = n,
    pal = rep(list(pal), length(var)),
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}





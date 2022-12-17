
get_div_colours <- colorRampPalette(
  colors = RColorBrewer::brewer.pal(n = 7, name = "RdYlGn"), space = "Lab"
)

get_seq_colours <- colorRampPalette(
  colors = RColorBrewer::brewer.pal(n = 7, name = "YlOrRd"), space = "Lab"
)

get_qual_colours <- colorRampPalette(
  #colors = RColorBrewer::brewer.pal(n = 7, name = "BuPu"), space = "Lab"
  colors = viridis::magma(n = 7), space = "Lab"
)


plot_divergent_map <- function(int_sf, 
                               base_map = sofala_province,
                               main = NULL, 
                               n = 11, 
                               direction = "hi",
                               breaks = "equal", 
                               file_path) {
  png(filename = file_path,width = 10, height = 10, units = "in", res = 200)
  par(mar = c(0,0,0,0))
  plot(
    x = int_sf["var1.pred"],
    main = NULL,
    pal = ifelse(direction == "lo", rev(pal), pal),
    nbreaks = n,
    breaks = breaks,
    key.pos = 4,
    lty = 0
  )
  
  plot(x = sf::st_geometry(base_map), lwd = 2, add = TRUE)
  
  title(main = main, cex.main = 0.85, line = -2)
  
  dev.off()
}

plot_sequential_map <- function(int_sf, 
                                base_map = sofala_province,
                                main = NULL,
                                n = 11, 
                                breaks = "equal", 
                                file_path) {
  png(filename = file_path,width = 10, height = 10, units = "in", res = 200)
  par(mar = c(0,0,0,0))
  plot(
    x = int_sf["var1.pred"],
    main = NULL,
    pal = get_seq_colours(n = n),
    nbreaks = n,
    breaks = breaks,
    key.pos = 4,
    lty = 0
  )
  
  plot(x = sf::st_geometry(base_map), lwd = 2, add = TRUE)
  
  title(main = main, cex.main = 0.85, line = -2)
  
  dev.off()
}


plot_prevalence_map <- function(int_sf, 
                                base_map = sofala_province,
                                main = NULL,
                                n = 11, 
                                breaks = "quantile", 
                                file_path) {
  png(filename = file_path,width = 10, height = 10, units = "in", res = 200)
  par(mar = c(0,0,0,0))
  plot(
    x = int_sf["var1.pred"],
    main = NULL,
    pal = get_seq_colours(n = n),
    nbreaks = n,
    breaks = breaks,
    key.pos = 4,
    lty = 0
  )
  
  plot(x = sf::st_geometry(base_map), lwd = 2, add = TRUE)
  
  title(main = main, cex.main = 0.85, line = -2)
  
  dev.off()
}

plot_qual_map <- function(int_sf, 
                          base_map = sofala_province,
                          main = NULL, 
                          n = 11, 
                          pal = viridis::magma(n = n),
                          breaks = "equal", 
                          file_path) {
  png(filename = file_path,width = 10, height = 10, units = "in", res = 200)
  par(mar = c(0,0,0,0))
  plot(
    x = int_sf["var1.pred"],
    main = NULL,
    pal = pal,
    nbreaks = n,
    breaks = breaks,
    key.pos = 4,
    lty = 0,
    cex = 0.5,
    reset = FALSE
  )
  
  plot(x = sf::st_geometry(base_map), lwd = 2, add = TRUE)
  
  title(main = main, cex.main = 0.85, line = -1)
  
  dev.off()
}


plot_sequential_maps <- function(int_sf, 
                                 base_map = sofala_province,
                                 n = 11, 
                                 breaks = "equal", 
                                 indicator_list) {
  set <- paste0(
    tolower(indicator_list[["indicator_group"]]), "_", indicator_list[["id"]]
  )
  
  file_paths <- paste0("outputs/interpolation/", set, "_", names(int_sf), ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% names(int_sf), select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)
  
  parallel::mcMap(
    f = plot_sequential_map,
    int_sf = int_sf,
    base_map = rep(list(base_map), length(int_sf)),
    main = as.list(main),
    n = n,
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}


plot_divergent_maps <- function(int_sf, 
                                base_map = sofala_province,
                                n = 11,
                                pal = get_qual_colours(n = n),
                                breaks = "equal", 
                                indicator_list) {
  set <- indicator_list |>
    subset(indicator_variable %in% names(int_sf)) |>
    (\(x)
      paste0(
        tolower(x[["indicator_group"]]), "_", x[["id"]]
      )
    )()
    
  file_paths <- paste0("outputs/interpolation/", set, "_", names(int_sf), ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% names(int_sf)) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)
  
  direction <- indicator_list |>
    subset(indicator_variable %in% names(int_sf)) |>
    (\(x) x$direction)()
  
  parallel::mcMap(
    f = plot_divergent_map,
    int_sf = int_sf,
    base_map = rep(list(base_map), length(int_sf)),
    main = as.list(main),
    n = n,
    pal = rep(list(pal), length(int_sf)),
    direction = as.list(direction),
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}

plot_anthro_maps <- function(int_sf, 
                             base_map = sofal_provice,
                             n = 11, 
                             breaks = "quantile", 
                             indicator_list) {
  set <- paste0(
    tolower(indicator_list[["indicator_group"]]), "_", indicator_list[["id"]]
  )
  
  file_paths <- paste0("outputs/interpolation/", set, "_", names(int_sf), ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% names(int_sf), select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)
  
  parallel::mcMap(
    f = plot_prevalence_map,
    int_sf = int_sf,
    base_map = rep(list(base_map), length(int_sf)),
    main = as.list(main),
    n = n,
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}

plot_qual_maps <- function(int_sf, 
                           base_map = sofala_province,
                           n = 11, 
                           pal = viridis::magma(n = n),
                           breaks = "equal", 
                           indicator_list) {
  set <- indicator_list |>
    subset(indicator_variable %in% names(int_sf)) |>
    (\(x)
     paste0(
       tolower(x[["indicator_group"]]), "_", x[["id"]]
     )
    )()
    
  file_paths <- paste0("outputs/interpolation/", set, "_", names(int_sf), ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% names(int_sf), select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)
  
  indicator_list |>
    subset(indicator_variable %in% names(int_sf), select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_detect(pattern = "Mean")
  
  parallel::mcMap(
    f = plot_qual_map,
    int_sf = int_sf,
    base_map = rep(list(base_map), length(int_sf)),
    main = as.list(main),
    n = n,
    pal = rep(list(pal), length(int_sf)),
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}


format_interpolation_result <- function(int_sf, prop) {
  if (prop) {
    int_sf[["var1.pred"]] <- int_sf[["var1.pred"]] * 100
    int_sf
  } else {
    int_sf
  }
}

format_interpolation_results <- function(int_sf, indicator_list) {
  Map(
    f = format_interpolation_result,
    int_sf = int_sf,
    prop = indicator_list |>
      subset(indicator_variable %in% names(int_sf), select = indicator) |>
      (\(x) x$indicator)() |>
      stringr::str_detect(pattern = "Mean", negate = TRUE) |>
      as.list()
  )
}


plot_interpolation_maps <- function(int_sf,
                                    base_map = sofala_province,
                                    n = 11,
                                    breaks = "equal",
                                    indicator_list) {
  set <- paste0(
    tolower(indicator_list[["indicator_group"]]), "_", indicator_list[["id"]]
  )
  
  file_paths <- paste0("outputs/interpolation/", set, "_", names(int_sf), ".png")
  
  main <- indicator_list |>
    subset(indicator_variable %in% names(int_sf), select = indicator) |>
    (\(x) x$indicator)() |>
    stringr::str_wrap(width = 100)

  
  parallel::mcMap(
    f =  lapply(
      X = indicator_list$map_function, FUN = function(x) eval(parse(text = x))
    ),
    int_sf = int_sf,
    base_map = rep(list(base_map), length(int_sf)),
    main = as.list(main),
    n = n,
    pal = lapply(
      X = indicator_list$pal, FUN = function(x) eval(parse(text = x))
    ),
    breaks = breaks,
    file_path = as.list(file_paths)
  )
}





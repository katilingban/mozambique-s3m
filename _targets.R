################################################################################
#
# Project build script
#
################################################################################

# Load packages (in packages.R) and load project-specific functions in R folder
suppressPackageStartupMessages(source("packages.R"))
for (f in list.files(here::here("R"), full.names = TRUE)) source (f)


# Set build options ------------------------------------------------------------



# Groups of targets ------------------------------------------------------------

## Sampling
spatial_sample <- tar_plan(
  moz_country = get_country(),
  moz_provinces = get_provinces(),
  moz_districts = get_districts(),
  moz_posts = get_posts(),
  moz_settlements = mozambique::settlements,
  sofala_province = moz_provinces |> 
    subset(ADM1_PT == "Sofala"),
  sofala_district = moz_districts |>
    subset(ADM1_PT == "Sofala"),
  sofala_settlements = moz_settlements |>
    subset(ADM1_Name == "Sofala"),
  sofala_sp_12 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 12, country = "Mozambique"),
  sofala_grid_12 = sp::HexPoints2SpatialPolygons(sofala_sp_12),
  sofala_sample_12 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_12
    ),
  sofala_sp_13 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 13, country = "Mozambique"),
  sofala_grid_13 = sp::HexPoints2SpatialPolygons(sofala_sp_13),
  sofala_sample_13 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_13
    ),
  sofala_sp_14 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 14, country = "Mozambique"),
  sofala_grid_14 = sp::HexPoints2SpatialPolygons(sofala_sp_14),
  sofala_sample_14 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_14
    ),
  sofala_sp_15 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 15, country = "Mozambique"),
  sofala_grid_15 = sp::HexPoints2SpatialPolygons(sofala_sp_15),
  sofala_sample_15 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_15
    ),
  sofala_sp_16 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 16, country = "Mozambique"),
  sofala_grid_16 = sp::HexPoints2SpatialPolygons(sofala_sp_16),
  sofala_sample_16 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_16
    ),
  sofala_sp_17 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 17, country = "Mozambique"),
  sofala_grid_17 = sp::HexPoints2SpatialPolygons(sofala_sp_17),
  sofala_sample_17 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_17
    ),
  sofala_sp_18 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 18, country = "Mozambique"),
  sofala_grid_18 = sp::HexPoints2SpatialPolygons(sofala_sp_18),
  sofala_sample_18 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_18
    ),
  sofala_sp_19 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 19, country = "Mozambique"),
  sofala_grid_19 = sp::HexPoints2SpatialPolygons(sofala_sp_19),
  sofala_sample_19 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_19
    ),
  sofala_sp_20 = sofala_province |> 
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(d = 20, country = "Mozambique"),
  sofala_grid_20 = sp::HexPoints2SpatialPolygons(sofala_sp_20),
  sofala_sample_20 = sofala_settlements |>
    data.frame() |>
    spatialsampler::get_nearest_point(
      data.x = "Longitude", data.y = "Latitude", query = sofala_sp_20
    )
)

## Read raw data
raw_data <- tar_plan(
  ##
)


## Process data
processed_data <- tar_plan(
  ##
)


## Analysis
analysis <- tar_plan(
  ##
)


## Outputs
outputs <- tar_plan(
  sofala_sample_12_csv = write.csv(
    x = sofala_sample_12, 
    file = "outputs/sofala_sample_12.csv", 
    row.names = FALSE
  ),
  sofala_sample_13_csv = write.csv(
    x = sofala_sample_13, 
    file = "outputs/sofala_sample_13.csv", 
    row.names = FALSE
  ),  
  sofala_sample_14_csv = write.csv(
    x = sofala_sample_14, 
    file = "outputs/sofala_sample_14.csv", 
    row.names = FALSE
  ),  
  sofala_sample_15_csv = write.csv(
    x = sofala_sample_15, 
    file = "outputs/sofala_sample_15.csv", 
    row.names = FALSE
  ),
  sofala_sample_16_csv = write.csv(
    x = sofala_sample_16, 
    file = "outputs/sofala_sample_16.csv", 
    row.names = FALSE
  ),
  sofala_sample_17_csv = write.csv(
    x = sofala_sample_17, 
    file = "outputs/sofala_sample_17.csv", 
    row.names = FALSE
  ),
  sofala_sample_18_csv = write.csv(
    x = sofala_sample_18, 
    file = "outputs/sofala_sample_18.csv", 
    row.names = FALSE
  ),
  sofala_sample_19_csv = write.csv(
    x = sofala_sample_19, 
    file = "outputs/sofala_sample_19.csv", 
    row.names = FALSE
  ),
  sofala_sample_20_csv = write.csv(
    x = sofala_sample_20, 
    file = "outputs/sofala_sample_20.csv", 
    row.names = FALSE
  )
)


## Reports
reports <- tar_plan(
  tar_render(
    name = sample_scenarios_report,
    path = "reports/sampling_scenarios_report.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  )
  #sampling_scenarios_report = rmarkdown::render(
  #  input = "reports/sampling_scenarios_report.Rmd",
  #  output_dir = "outputs",
  #  knit_root_dir = here::here()
  #)
  #tar_target(
  #  name = sampling_scenarios_report,
  #  command = {
  #    moz_provinces; sofala_province; sofala_district; sofala_settlements;
  #    sofala_sp_12; sofala_grid_12; sofala_sample_12;
  #    sofala_sp_13; sofala_grid_13; sofala_sample_13;
  #    sofala_sp_14; sofala_grid_14; sofala_sample_14;
  #    sofala_sp_15; sofala_grid_15; sofala_sample_15;
  #    sofala_sp_16; sofala_grid_16; sofala_sample_16;
  #    sofala_sp_17; sofala_grid_17; sofala_sample_17;
  #    sofala_sp_18; sofala_grid_18; sofala_sample_18;
  #    sofala_sp_19; sofala_grid_19; sofala_sample_19;
  #    sofala_sp_20; sofala_grid_20; sofala_sample_20
  #    rmarkdown::render(
  #      input = "reports/sampling_scenarios_report.Rmd",
  #      output_dir = "outputs",
  #      knit_root_dir = here::here()
  #    )
  #  }
  #)
)

## Deploy targets
deploy <- tar_plan(
  ##
)

## Set seed
set.seed(1977)

# Concatenate targets ----------------------------------------------------------
list(
  spatial_sample,
  raw_data,
  processed_data,
  analysis,
  outputs,
  reports,
  deploy
)
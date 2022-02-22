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

## Sampling design
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
  cidade_da_beira = sofala_district |>
    subset(ADM2_PT == "Cidade Da Beira"),
  cidade_da_beira_osm = get_osm_features(area = cidade_da_beira),
  cidade_da_beira_sp = cidade_da_beira |>
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(country = "Mozambique", n = 25, buffer = 1),
  cidade_da_beira_grid = sp::HexPoints2SpatialPolygons(cidade_da_beira_sp),
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
    ),
  selected_ea_file = download_googledrive(
    filename = "S3M_Selected_EAs_UNICEF.xlsx", overwrite = TRUE
  ),
  selected_ea = readxl::read_xlsx(
    path = selected_ea_file$local_path, sheet = 1
  ),
  selected_ea_sqlite = download_googledrive(
    filename = "S3M_EA maps_UNICEF.sqlite", overwrite = TRUE
  ),
  selected_ea_sf = sf::st_read(dsn = selected_ea_sqlite$local_path),
  training_areas = moz_districts |>
    subset(ADM2_PT %in% c("Cidade De Quelimane", "Nicoadala", "Inhassunge", "Maquival")),
  training_areas_sp = training_areas |>
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(country = "Mozambique", n = 15, buffer = 1),
  training_areas_grid = sp::HexPoints2SpatialPolygons(training_areas_sp)
)


## Form/questionnaire development
questionnaire <- tar_plan(
  ##
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
  cidade_da_beira_sample_csv = write.csv(
    x = data.frame(
      spid = seq_len(length(cidade_da_beira_sp)),
      longitude = cidade_da_beira_sp@coords[ , 1],
      latitude = cidade_da_beira_sp@coords[ , 2]
    ),
    file = "outputs/cidade_da_beira_sample.csv",
    row.names = FALSE
  ),
  training_areas_sample_csv = write.csv(
    x = data.frame(
      spid = seq_len(length(training_areas_sp)),
      longitude = training_areas_sp@coords[ , 1],
      latitude = training_areas_sp@coords[ , 2]
    ),
    file = "outputs/training_area_sample.csv",
    row.names = FALSE
  ),
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
  ),
  tar_render(
    name = sample_cidade_da_beira,
    path = "reports/sampling_cidade_da_beira.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  ),
  tar_render(
    name = selected_ea_review,
    path = "reports/selected_ea_review.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  ),
  tar_render(
    name = sample_training_area,
    path = "reports/training_area_sample.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  )
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
  questionnaire,
  raw_data,
  processed_data,
  analysis,
  outputs,
  reports,
  deploy
)
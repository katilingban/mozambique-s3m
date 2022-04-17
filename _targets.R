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
    filename = "SOFALA_204.sqlite", overwrite = TRUE
  ),
  selected_ea_sf = sf::st_read(dsn = selected_ea_sqlite$local_path),
  urban_ea_sqlite = download_googledrive(
    filename = "EAs_Cidade_da_Beira.sqlite", overwrite = TRUE
  ),
  urban_ea_sf = sf::st_read(dsn = urban_ea_sqlite$local_path),
  training_areas = moz_districts |>
    subset(ADM2_PT %in% c("Cidade De Quelimane", "Nicoadala", "Inhassunge", "Maquival")),
  training_areas_sp = training_areas |>
    sf::as_Spatial() |>
    spatialsampler::create_sp_grid(country = "Mozambique", n = 15, buffer = 1),
  training_areas_grid = sp::HexPoints2SpatialPolygons(training_areas_sp),
  selected_ea_file_updated = download_googledrive(
    filename = "MERGE_DATA_TABLE.xls", overwrite = TRUE
  ),
  selected_ea_updated = readxl::read_xls(
    path = selected_ea_file_updated$local_path, sheet = 1
  ) |>
    (\(x) x[!duplicated(x$AES), c("spid", "Area_Geogr", "CodProv", "Provincia", 
                                  "CodDist", "Distrito", "CodPost", "Posto", 
                                  "CodLocal", "Localidade", "CodBairro", 
                                  "Bairro", "CodN1", "NomeN1", "CodN2", "NomeN2", 
                                  "CodN3", "NomeN3", "AES", "CodAE_2017")])(),
  selected_urban_ea_file = download_googledrive(
    filename = "EAs_Cidade_da_Beira.xls", overwrite = TRUE
  ),
  selected_urban_ea = readxl::read_xls(
    path = selected_urban_ea_file$local_path, sheet = 1
  ) |>
    (\(x) tibble::tibble(spid = 210:(210 + 20), x[ , 1:15], CodN3 = NA, 
                         NomeN3 = NA, 
                         x[ , 16:17]))(),
  selected_ea_complete = create_sampling_list(
    selected_ea_file_updated, selected_urban_ea_file
  )
)


## Form/questionnaire development
questionnaire <- tar_plan(
  ##
  survey_enumerator_list_file = download_googledrive(
    filename = "Lista das Equipes  do E.BASE SOFALA-FINAL.xls", overwrite = TRUE
  ),
  survey_enumerator_list = readxl::read_xls(
    path = survey_enumerator_list_file$local_path, sheet = 1, range = "A2:G53"
  ) |>
    (\(x) x[3:nrow(x), ])() |>
    (\(x) {
      x[ , 3] <- c(rep(1, 3), rep(2, 4), rep(3, 3), rep(4, 4), rep(5, 3), rep(6, 4),
                   rep(7, 3), rep(8, 4), rep(9, 3), rep(10, 4), rep(11, 3), rep(12, 4),
                   rep(13, 3), rep(14, 4))
      x
    })() |>
    subset(select = c(-`EQUIPA/DISTRITOS`, -FUNCAO, -Brigadas)) |>
    (\(x) 
     tibble::tibble(
       enumerator_code = paste0(
         stringr::str_pad(x$`Código/Número de equipa`, width = 2, side = "left", pad = "0"),
         stringr::str_pad(x$`Número de membros`, width = 2, side = "left", pad = "0")
       ),
       x
     )
    )(),
  sofala_xlsform_file = download_googledrive(
    filename = "sofala_s3m_2022041401.xlsx", overwrite = TRUE
  ),
  survey_questions = readxl::read_xlsx(
    path = sofala_xlsform_file$local_path, sheet = "survey"
  ),
  survey_choices = readxl::read_xlsx(
    path = sofala_xlsform_file$local_path, sheet = "choices"
  ),
  survey_codebook = create_codebook(
    survey_questions, survey_choices, raw_data, meta = TRUE
  )
)

## Survey plan
survey_plan <- tar_plan(
  
)


## Read raw data
data_targets <- tar_plan(
  tar_target(
    name = raw_data,
    command = get_data(),
    cue = tar_cue(mode = "always")
  ),
  respondent_data = process_respondent_data(df = raw_data),
  child_data = process_child_data(df = respondent_data),
  respondent_data_clean = clean_respondent_data(respondent_data),
  child_data_clean = clean_child_data(child_data),
  fgh_id_clean = clean_fgh_id(
    respondent_data_clean, endline_sample_list, moz_country
  )
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
  selected_ea_complete_csv = write.csv(
    x = selected_ea_complete,
    file = "outputs/selected_ea_complete.csv",
    row.names = FALSE
  ),
  selected_ea_complete_odk_csv = write.csv(
    x = data.frame(spid_key = selected_ea_complete$spid, selected_ea_complete),
    file = "outputs/selected_ea_complete_odk.csv",
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
  ),
  survey_enumerator_list_csv = write.csv(
    x = survey_enumerator_list,
    file = "outputs/survey_enumerator_list.csv",
    row.names = FALSE
  ),
  survey_codebook_xlsx = openxlsx::write.xlsx(
    x = survey_codebook,
    file = "outputs/sofala_s3m_codebook.xlsx",
    overwrite = TRUE
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
  survey_plan,
  data_targets,
  processed_data,
  analysis,
  outputs,
  reports,
  deploy
)
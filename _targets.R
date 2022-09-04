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
  complete_ea_sf = rbind(selected_ea_sf, urban_ea_sf),
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
  ## Create survey enumerator list
  survey_enumerator_list_file = download_googledrive(
    filename = "Lista das Equipes  do E.BASE SOFALA-FINAL.xls", overwrite = TRUE
  ),
  survey_enumerator_list = readxl::read_xls(
    path = survey_enumerator_list_file$local_path, sheet = 1, range = "A2:G53"
  ) |>
    (\(x) x[3:nrow(x), ])() |>
    (\(x) {
      x[ , 3] <- c(rep(1, 3), rep(2, 4), rep(3, 3), 
                   rep(4, 4), rep(5, 3), rep(6, 4),
                   rep(7, 3), rep(8, 4), rep(9, 3), 
                   rep(10, 4), rep(11, 3), rep(12, 4),
                   rep(13, 3), rep(14, 4))
      x
    })() |>
    subset(select = c(-`EQUIPA/DISTRITOS`, -FUNCAO, -Brigadas)) |>
    (\(x) 
     tibble::tibble(
       enumerator_code = paste0(
         stringr::str_pad(
           x$`Código/Número de equipa`, 
           width = 2, side = "left", pad = "0"
         ),
         stringr::str_pad(
           x$`Número de membros`, 
           width = 2, side = "left", pad = "0"
         )
       ),
       x
     )
    )(),
  ## Retrieve Sofala S3M XLSForm
  sofala_xlsform_file = download_googledrive(
    filename = "sofala_s3m_2022041401.xlsx", overwrite = TRUE
  ),
  ## Create codebook
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
data_raw <- tar_plan(
  tar_target(
    name = raw_data,
    command = get_data(form_name = "sofala_s3m", survey_questions),
    cue = tar_cue(mode = "thorough")
  ),
  raw_data_clean = clean_raw_data(raw_data, survey_codebook, survey_questions),
  # raw_data_clean_translated = translate_raw_data(
  #   raw_data_clean, survey_questions
  # ),
  raw_data_clean_translated = raw_data_clean |>
    (\(x) translate_df_variable(var = "q05_specify", df = x))() |>
    (\(x) translate_df_variable(var = "q06_content", df = x))() |>
    (\(x) translate_df_variable(var = "q07_specify", df = x))() |>
    (\(x) translate_df_variable(var = "gi1_other", df = x))() |>
    (\(x) translate_df_variable(var = "wt2_other", df = x))() |>
    (\(x) translate_df_variable(var = "caha2_other", df = x))() |>
    (\(x) translate_df_variable(var = "wh6a", df = x))() |>
    (\(x) translate_df_variable(var = "wh7a", df = x))() |>
    (\(x) translate_df_variable(var = "bs2a", df = x))() |>
    (\(x) translate_df_variable(var = "bs3a", df = x))() |>
    (\(x) translate_df_variable(var = "bs4a", df = x))() |>
    (\(x) translate_df_variable(var = "pest2_other", df = x))() |>
    (\(x) translate_df_variable(var = "ort5e_specify", df = x))() |>
    (\(x) translate_df_variable(var = "ch5a_other", df = x))() |>
    (\(x) translate_df_variable(var = "liquid_other_specify", df = x))()
)


## Data quality checks
data_checks <- tar_plan(
  ## Tallies for survey progress
  table_sp_total = tally_sp_total(raw_data, selected_ea_complete),
  table_sp_date_total = tally_sp_date_total(
    raw_data, selected_ea_complete
  ),
  table_team_total = tally_team_total(raw_data),
  table_team_date_total = tally_team_date_total(raw_data),
  check_ea_map = raw_data |>
    subset(!is.na(spid)) |>
    (\(x) x$ea_code)() |>
    (\(x) x[!is.na(x)])() |>
    unique() |>
    lapply(FUN = check_ea_geo, raw_data, complete_ea_sf),
  table_check_ea_map = raw_data |>
    subset(!is.na(spid)) |>
    (\(x) x$ea_code)() |>
    unique() |>
    lapply(FUN = check_ea, raw_data, complete_ea_sf) |>
    dplyr::bind_rows() |>
    (\(x) rbind(
      x, 
      data.frame(
        ea = "Total", 
        n_in = sum(x[ , 2]),
        n_out = sum(x[ , 3]),
        total = sum(x[ , 4])
      )
    ))(),
  table_check_ea_out = raw_data |>
    subset(!is.na(spid)) |>
    (\(x) x$ea_code)() |>
    unique() |>
    lapply(FUN = check_ea_table, raw_data, complete_ea_sf, check = "out") |>
    dplyr::bind_rows(), 
  ## Detect univariate outliers for mother anthropometric data
  outlier_weight_mother = raw_data_clean |>
    (\(x) x[outliersUV(x$mweight), ])(),
  outlier_height_mother = raw_data_clean |>
    (\(x) x[outliersUV(x$mheight), ])(),
  outlier_muac_mother = raw_data_clean |>
    (\(x) x[outliersUV(x$mmuac), ])(),
  outlier_summary_univariate_mother = summarise_univariate_outliers_mother(
    outlier_weight_mother, outlier_height_mother, outlier_muac_mother
  ),
  outlier_table_univariate_mother = tally_univariate_outliers_mother(
    outlier_weight_mother, outlier_height_mother, outlier_muac_mother
  ),
  outlier_unique_univariate_mother_total = tally_unique_univariate_outliers_mother(
    outlier_table_univariate_mother, raw_data_clean
  ),
  ## Detect bivariate outliers for mother anthropometric data
  outlier_weight_height_mother = raw_data_clean |>
    (\(x) x[with(x, outliersMD(mweight, mheight)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_weight_muac_mother = raw_data_clean |>
    (\(x) x[with(x, outliersMD(mweight, mmuac)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_height_muac_mother = raw_data_clean |>
    (\(x) x[with(x, outliersMD(mheight, mmuac)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_summary_bivariate_mother = summarise_bivariate_outliers_mother(
    outlier_weight_height_mother, 
    outlier_weight_muac_mother, 
    outlier_height_muac_mother
  ),
  outlier_table_bivariate_mother = tally_bivariate_outliers_mother(
    outlier_weight_height_mother, 
    outlier_weight_muac_mother, 
    outlier_height_muac_mother
  ),
  outlier_unique_bivariate_mother_total = tally_unique_bivariate_outliers_mother(
    outlier_table_bivariate_mother, raw_data_clean
  ),
  outlier_unique_mother_total = tally_total_unique_outliers_mother(
    outlier_table_univariate_mother,
    outlier_table_bivariate_mother,
    raw_data_clean
  ),
  ## Detect univariate outliers for child anthropometric data
  outlier_weight = raw_data_clean|>
    subset(age_months >= 6 & age < 60) |>
    (\(x) x[outliersUV(x$cweight), ])(),
  outlier_height = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[outliersUV(x$cheight), ])(),
  outlier_muac = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[outliersUV(x$cmuac), ])(),
  outlier_weight_adj = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[outliersUV(x$cweight1), ])(),
  outlier_height_adj = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[outliersUV(x$cheight1), ])(),
  outlier_muac_adj = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[outliersUV(x$cmuac1), ])(),
  outlier_summary_univariate = summarise_univariate_outliers(
    outlier_weight, outlier_height, outlier_muac
  ),
  outlier_table_univariate = tally_univariate_outliers(
    outlier_weight, outlier_height, outlier_muac
  ),
  outlier_unique_univariate_total = tally_unique_univariate_outliers(
    outlier_table_univariate, raw_data_clean
  ),
  outlier_summary_univariate_adj = summarise_univariate_outliers(
    outlier_weight_adj, outlier_height_adj, outlier_muac_adj
  ),
  outlier_table_univariate_adj = tally_univariate_outliers_adj(
    outlier_weight_adj, outlier_height_adj, outlier_muac_adj
  ),
  outlier_unique_univariate_total_adj = tally_unique_univariate_outliers(
    outlier_table_univariate_adj, raw_data_clean
  ),
  ## Detect bivariate outliers for child anthropometric data
  outlier_weight_height = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[with(x, outliersMD(cweight, cheight)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_weight_muac = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[with(x, outliersMD(cweight, cmuac)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_height_muac = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |> 
    (\(x) x[with(x, outliersMD(cheight, cmuac)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_weight_age = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[with(x, outliersMD(cweight, age_months)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_height_age = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[with(x, outliersMD(cheight, age_months)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_muac_age = raw_data_clean |>
    subset(age_months >= 6 & age_months < 60) |>
    (\(x) x[with(x, outliersMD(cmuac, age_months)), ])() |>
    (\(x) x[!is.na(x$id), ])(),
  outlier_summary_bivariate = summarise_bivariate_outliers(
    outlier_weight_height, outlier_weight_muac, outlier_height_muac,
    outlier_weight_age, outlier_height_age, outlier_muac_age
  ),
  outlier_table_bivariate = tally_bivariate_outliers(
    outlier_weight_height, outlier_weight_muac, outlier_height_muac,
    outlier_weight_age, outlier_height_age, outlier_muac_age
  ),
  outlier_unique_bivariate_total = tally_unique_bivariate_outliers(
    outlier_table_bivariate, raw_data_clean
  ),  
  outlier_unique_total = tally_total_unique_outliers(
    outlier_table_bivariate,
    outlier_table_bivariate,
    raw_data_clean
  ),
  ## Flag child anthropometric zscores
  child_data_zscore = raw_data_clean |>
    subset(age_months < 60 & age_months >= 6) |>
    calculate_zscore(),
  child_data_zscore_clean = child_data_zscore |>
    dplyr::filter(
      !id %in% c(outlier_table_univariate$id, outlier_table_bivariate$id) | 
        flag == 0
    ),
  child_data_zscore_adj = raw_data_clean |>
    subset(age_months < 60 & age_months >= 6) |>
    calculate_zscore_adj(),
  flag_zscore_total = child_data_zscore |>
    dplyr::filter(flag_zscore != 0) |>
    nrow(),
  flag_zscore_prop = (flag_zscore_total / nrow(child_data_zscore)) |>
    scales::percent(accuracy = 0.1),
  flag_zscore_adj_total = child_data_zscore_adj |>
    dplyr::filter(flag_zscore != 0) |>
    nrow(),
  flag_zscore_adj_prop = (flag_zscore_adj_total / nrow(child_data_zscore_adj)) |>
    scales::percent(accuracy = 0.1),
  ## Test for normality
  shapiro_wfaz = shapiro.test(x = child_data_zscore_clean$wfaz),
  shapiro_hfaz = shapiro.test(x = child_data_zscore_clean$hfaz),
  shapiro_wfhz = shapiro.test(x = child_data_zscore_clean$wfhz),
  ## Test skewness and kurtosis of child anthropometric zscores
  skewKurt_wfaz = child_data_zscore |>
    (\(x) skewKurt(x$wfaz))(),
  skew_wfaz_class = classify_skew_kurt(x = skewKurt_wfaz$s),
  kurt_wfaz_class = classify_skew_kurt(x = skewKurt_wfaz$k),
  skewKurt_wfaz_adj = child_data_zscore |>
    dplyr::filter(
      !id %in% c(outlier_table_univariate$id, outlier_table_bivariate$id) | 
        flag_zscore == 0
    ) |>
    (\(x) skewKurt(x$wfaz))(),
  skew_wfaz_adj_class = classify_skew_kurt(x = skewKurt_wfaz_adj$s),
  kurt_wfaz_adj_class = classify_skew_kurt(x = skewKurt_wfaz_adj$k),
  skewKurt_hfaz = child_data_zscore |>
    (\(x) skewKurt(x$hfaz))(),
  skew_hfaz_class = classify_skew_kurt(x = skewKurt_hfaz$s),
  kurt_hfaz_class = classify_skew_kurt(x = skewKurt_hfaz$k),
  skewKurt_hfaz_adj = child_data_zscore |>
    dplyr::filter(
      !id %in% c(outlier_table_univariate$id, outlier_table_bivariate$id) | 
        flag_zscore == 0
    ) |>
    (\(x) skewKurt(x$hfaz))(),
  skew_hfaz_adj_class = classify_skew_kurt(x = skewKurt_hfaz_adj$s),
  kurt_hfaz_adj_class = classify_skew_kurt(x = skewKurt_hfaz_adj$k),
  skewKurt_wfhz = child_data_zscore |>
    (\(x) skewKurt(x$wfhz))(),
  skew_wfhz_class = classify_skew_kurt(x = skewKurt_wfhz$s),
  kurt_wfhz_class = classify_skew_kurt(x = skewKurt_wfhz$k),
  skewKurt_wfhz_adj = child_data_zscore |>
    dplyr::filter(
      !id %in% c(outlier_table_univariate$id, outlier_table_bivariate$id) | 
        flag_zscore == 0
    ) |>
    (\(x) skewKurt(x$wfhz))(),
  skew_wfhz_adj_class = classify_skew_kurt(x = skewKurt_wfhz_adj$s),
  kurt_wfhz_adj_class = classify_skew_kurt(x = skewKurt_wfhz_adj$k),
  whz_mad = with(
    child_data_zscore |>
      dplyr::filter(!flag_zscore %in% c(2, 3, 6, 7) | !is.na(flag_zscore), 
                    oedema == 2, !is.na(wfhz)),
    mad(wfhz)
  ),
  ## Check zscores against Benford's Law
  bf_wfaz = with(
    child_data_zscore, 
    check_benford_law(x = wfaz, multiplier = 100)
  ),
  bf_hfaz = with(
    child_data_zscore, 
    check_benford_law(x = hfaz, multiplier = 100)
  ),
  bf_wfhz = with(
    child_data_zscore, 
    check_benford_law(x = wfhz, multiplier = 10)
  ),
  ## Assess digit preference score
  dp_weight = with(child_data_zscore, digitPreference(cweight)),
  dp_height = with(child_data_zscore, digitPreference(cheight)),
  dp_muac = with(child_data_zscore, digitPreference(cmuac)),
  ## Assess age heaping
  age_heaping = raw_data_clean |>
    (\(x) ageHeaping(x$age_months))(),
  age_heaping_class = classify_age_heaping(age_heaping),
  ## Assess sex ratio
  sex_ratio = raw_data_clean |> 
    (\(x) sexRatioTest(x$sex, codes = c(1, 2), pop = c(1.03, 1)))(),
  ## Assess age ratio
  age_ratio = raw_data_clean |>
    (\(x) x$age_months[x$age_months >= 6 & x$age_months < 60])() |>
    (\(x) x[!is.na(x)])() |>
    (\(x) ageRatioTest(x = x, ratio = 0.85))()
)


## Process data
data_processed <- tar_plan(
  ## Anthropometric data
  mother_anthro = recode_anthro_mother(raw_data_clean),
  ## Household dietary diversity score
  hdds_vars_map = hdds_map_fg_vars(
    cereals = "hdds1", 
    tubers = "hdds2", 
    vegetables = c("hdds3", "hdds4", "hdds5"), 
    fruits = c("hdds6", "hdds7"), 
    meat = c("hdds8", "hdds9"), 
    eggs = "hdds10", fish = "hdds11", 
    legumes_seeds = "hdds12", 
    milk = "hdds13", 
    oils_fats = "hdds14", 
    sweets = "hdds15", 
    spices = "hdds16"
  ),
  hdds_recoded_data = hdds_vars_map |>
    hdds_recode(.data = raw_data_clean),
  ## Food consumption score
  fcs_vars_map = fcs_map_fg_vars(
    staples = paste0("fcs", 1:4), 
    pulses = "fcs5", 
    vegetables = "fcs14", 
    fruits = "fcs15", 
    meat_fish = paste0("fcs", c(6, 8:9, 11)), 
    milk = "fcs12", 
    sugar = "fcs16", 
    oil = "fcs10", 
    condiments = paste0("fcs", c(7, 13))
  ),
  fcs_recoded_data = fcs_vars_map |>
    fcs_recode(.data = raw_data_clean),
  ## Reduced coping strategies index (rCSI)
  rcsi_recoded_data = rcsi_recode(
    vars = paste0("rcsi", 1:5),
    .data = raw_data_clean,
    na_values = c(88, 99)
  ),
  ## Women's dietary diversity score (WDDS)
  wdds_vars_map = wdds_map_fg_vars(
    staples = c("nutmul1", "nutmul2"),
    grean_leafy = "nutmul10",
    other_vita = c("nutmul11", "nutmul12"),
    fruits_vegetables = c("nutmul13", "nutmul14"),
    organ_meat = "nutmul6",
    meat_fish = c("nutmul7", "nutmul8"),
    eggs = "nutmul9",
    legumes = c("nutmul3", "nutmul4"),
    milk = "nutmul5"
  ),
  wdds_recoded_data = wdds_recode(
    vars = wdds_vars_map,
    .data = raw_data_clean
  ),
  ## Minimum dietary diversity - women (MDD-W)
  mddw_vars_map = mddw_map_fg_vars(
    staples = c("nutmul1", "nutmul2"),
    pulses = "nutmul3",
    nuts_seeds = "nutmul4",
    milk = "nutmul5",
    meat_fish = c("nutmul6", "nutmul7", "nutmul8"), 
    eggs = "nutmul9", 
    green_leafy = "nutmul10",
    other_vita = c("nutmul11", "nutmul12"),
    vegetables = "nutmul13",
    fruits = "nutmul14"
  ),
  mddw_recoded_data = mddw_recode(
    vars = mddw_vars_map,
    .data = raw_data_clean
  ),
  ## Livelihoods coping strategy index (LCSI)
  lcsi_recoded_data = lcsi_recode(
    vars = c(
      "lcs01", "lcs02", "lcs03", "lcs04", "lcs05", "lcs06", "lcs07", 
      "lcs08", "lcs09", "lcs10", "lcs11", "lcs12", "lcs13", "lcs14"
    ),
    .data = raw_data_clean,
    na_values = c(5, 8, 9)
  ),
  ## Primary health questionnaire - depression
  phq_recoded_data = phq_recode(
    vars = paste0("ment", 1:9),
    .data = raw_data_clean,
    na_values = c(88, 99)
  ),
  ## Childcare practices
  ccare_recoded_data = ccare_recode(.data = raw_data_clean),
  ## Immunisation
  imm_recoded_data = imm_recode(
    vars = c(
      "imm3a", "imm3b", "imm3c", "imm3d", "imm3e", "imm4a", "imm4b", "imm4c", 
      "imm5", "imm5a", "imm6a", "imm6b", "imm6c", "imm7a", "imm7b"
    ),
    .data = raw_data_clean
  ),
  ## VAS coverage
  vas_recoded_data = vas_recode(.data = raw_data_clean),
  ## Development milestones
  dev_recoded_data = dev_recode(
    vars = c("des1", "des2"),
    .data = raw_data_clean,
    na_values = c(88, 99)
  ),
  ## Pica
  pica_recoded_data = pica_recode(
    vars = c("pica1", "pica2", "pica3"),
    .data = raw_data_clean,
    na_values = c(8, 9, 88, 99)
  ),
  ## Carer characteristics
  carer_recoded_data = carer_recode(
    .data = raw_data_clean, 
    age_na_values = c(1:14, 88, 99, 100:1000), 
    marital_na_values = c(88, 99),
    education_na_values = c(88, 99)
  ),
  ## Women's empowerment and decision-makin
  wem_recoded_data = wem_recode(raw_data_clean),
  ## Income and occupation
  work_recoded_data = work_recode(
    vars = c("ig1", "q08", "igs1", "igs2"),
    .data = raw_data_clean,
    na_values = list(
      c(88, 99), c(88, 99), 
      c(88, 99), c(7, 88, 99)
    ),
    fill = list(1:6, 1:9, 1:6, 1:6),
    na_rm = rep(list(FALSE), length(vars)),
    prefix = list(
      "income_source", "income_amount", 
      "occupation_carer", "occupation_partner"
    ),
    label = rep(list(NULL), length(vars))
  ),
  ## Time-to-travel
  travel_recode_data = travel_recode(raw_data_clean),
  ## Play
  play_recode_data = play_recode(
    vars = paste0("play", c(paste0(1, letters[1:7]), 2, paste0(3, letters[1:6]))),
    .data = raw_data_clean,
    na_values = c(8, 9)
  ),
  ## Mosquito net
  net_recoded_data = net_recode(
    vars = "cdcg13", 
    .data = raw_data_clean,
    na_values = c(88, 99)
  ),
  ## Water
  water_recoded_data = water_recode(
    vars = c("wt2", "wt3", "wt3a", "wt3b", "wt4", "wt4a", "wt5", "wt6"),
    .data = raw_data_clean,
    na_values = c(88, 99, 888, 999)
  ),
  ## Sanitation
  san_recoded_data = san_recode(
    vars = paste0("lusd", 1:8),
    .data = raw_data_clean,
    na_values = c(8, 9, 88, 99, 888, 999)
  ),
  ## Hygiene
  hygiene_recoded_data = hygiene_recode(
    vars = c(paste0("caha", 1:3), paste0("lusd", 9:11)),
    .data = raw_data_clean,
    na_values = c(8, 9, 88, 99)
  ),
  ## Treatment-seeking - fever
  fever_recoded_data = fever_recode(
    vars = c(paste0("fever", 1:6), "fever6a", "fever7"),
    .data = raw_data_clean
  ),
  ## Treatment-seeking - diarrhoea
  diarrhoea_recoded_data = dia_recode(
    vars = c("ort1", paste0("ort1", letters[1:3]), paste0("ort", 2:4), 
             paste0("ort5", letters[1:5]), "ort6", "ort7"),
    .data = raw_data_clean
  )
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
  ),
  ## Render survey progress report
  tar_render(
    name = survey_progress_report,
    path = "reports/sofala_survey_progress.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  ),
  ## Archive survey progress report
  survey_progress_report_archive = archive_progress_report(
    from = survey_progress_report[1]
  ),
  ## Render data quality report
  tar_render(
    name = data_quality_report,
    path = "reports/sofala_data_quality.Rmd",
    output_dir = "outputs",
    knit_root_dir = here::here()
  ),
  ## Archive data quality report
  data_quality_report_archive = archive_quality_report(
    from = data_quality_report[1]
  ),
  ## Email message for sending survey progress report
  email_progress_message = blastula::render_email(
    input = "reports/email_progress_report.Rmd"
  ),
  ## Email message for sending survey data quality report
  email_quality_message = blastula::render_email(
    input = "reports/email_quality_report.Rmd"
  )
)

## Deploy targets
deploy <- tar_plan(
  ## Deploy daily progress report
  survey_progress_deployed = deploy_progress_report(
    from = survey_progress_report[1],
    to = "docs/survey_progress_report.html"
  ),
  ## Deploy daily report archive
  survey_progress_archive_deployed = archive_progress_report(
    from = survey_progress_deployed, 
    to = paste0("docs/", Sys.Date(), "/progress/index.html") 
  ),
  ## Deploy daily quality report
  data_quality_deployed = deploy_quality_report(
    from = data_quality_report[1],
    to = "docs/data_quality_report.html"
  ),
  ## Deploy daily report archive
  data_quality_archive_deployed = archive_quality_report(
    from = data_quality_deployed, 
    to = paste0("docs/", Sys.Date(), "/quality/index.html") 
  ),
  ## Email daily progress report to recipients
  progress_report_emailed = email_progress_report(
    message = email_progress_message,
    attachment = survey_progress_report[1],
    sender = Sys.getenv("GMAIL_USERNAME"),
    recipient = eval(parse(text = Sys.getenv("REPORT_RECIPIENTS")))
  ),
  ## Email daily quality report to recipients
  quality_report_emailed = email_quality_report(
    message = email_quality_message,
    attachment = data_quality_report[1],
    sender = Sys.getenv("GMAIL_USERNAME"),
    recipient = eval(parse(text = Sys.getenv("REPORT_RECIPIENTS")))
  )
)

## Set seed
set.seed(1977)

# Concatenate targets ----------------------------------------------------------
list(
  spatial_sample,
  questionnaire,
  survey_plan,
  data_raw,
  data_checks,
  data_processed,
  analysis,
  outputs,
  reports,
  deploy
)


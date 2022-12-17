


create_sf_data <- function(.data) {
  .data |>
    subset(!is.na(spid)) |>
    (\(x)
      {
        data.frame(
          x,
          do.call(rbind, x[["geolocation"]])
        )  
      }
    )() |>
    dplyr::rename(latitude = X1, longitude = X2) |>
    subset(select = -geolocation) |>
    sf::st_as_sf(coords = c("longitude", "latitude"), crs = 4326)
}


create_sp_data <- function(.data) {
  .data |>
    subset(!is.na(spid)) |>
    (\(x)
     {
       data.frame(
         x,
         do.call(rbind, x[["geolocation"]])
       )  
    }
    )() |>
    dplyr::rename(latitude = X1, longitude = X2) |>
    subset(select = -geolocation) |>
    (\(x)
      {
        sp::SpatialPointsDataFrame(
          coords = x[ , c("longitude", "latitude")],
          data = x#, 
          #proj4string = CRS(proj)
        )
      }
    )()
}

interpolate_indicator <- function(var, sf_data, int_points) {
  sf_data <- sf_data[!is.na(sf_data[[var]]), ]
  
  gstat::idw(
    formula = eval(parse(text = paste(var, "~", 1, sep = " "))),
    locations = sf_data, newdata = int_points, idp = 2
  )
}


interpolate_indicators <- function(vars, sf_data, int_points, indicator_list) {
  vars <- as.list(indicator_list[["indicator_variable"]])
  sf_data <- rep(list(sf_data), length(vars))
  int_points <- rep(list(int_points), length(vars))
  
  parallel::mcMap(
    f = interpolate_indicator,
    var = vars,
    sf_data = sf_data,
    int_points = int_points,
    mc.cores = 4
  ) |>
    (\(x) { names(x) <- vars; x } )()
}



structure_interpolation_result <- function(int_df, var) {
  int_df |>
    sf::st_drop_geometry() |>
    subset(select = var1.pred) |>
    (\(x) { names(x) <- var; x } )()
}

structure_interpolation_results <- function(int_list) {
  int_df <- int_list
  var    <- as.list(names(int_list))
  
  Map(
    f = structure_interpolation_result,
    int_df = int_df,
    var = var
  ) |>
    dplyr::bind_cols()
}



interpolate_indicators_household <- function(sf_data, int_points,
                                             indicator_list) {
  vars <- indicator_list[["indicator_variable"]]
  
  interpolate_indicators(
    vars = vars, sf_data = sf_data, int_points = int_points
  )
}


interpolate_indicators_carer <- function(sf_data, int_points, indicator_list) {
  vars <- c(
    paste0("carer_", 
      c("age", "sex_1", "sex_2", "single", "married", "civil_union", 
        "divorced_separated", "widowed", "grade1", "grade2", "grade3", "grade4", 
        "grade5", "grade6", "grade7", "grade8", "grade9", "grade10", 
        "grade11", "grade12", "professional", "non_college", "college", 
        "literacy", "with_partner")
    ),
    paste0("partner_",
      c("age", "grade1", "grade2", "grade3", "grade4", "grade5", "grade6", 
        "grade7", "grade8", "grade9", "grade10", "grade11", "grade12", 
        "professional", "non_college", "college", "literacy")
    ),
    paste0("income_source_", 1:6), paste0("income_amount_", 1:9),
    paste0("occupation_carer_", 1:6), paste0("occupation_partner_", 1:7),
    paste0("travel_modes_town_", 1:11),
    paste0("travel_modes_health_facility_", 1:5),
    paste0("travel_modes_local_markets_", 1:5),
    paste0("travel_modes_water_sources_", 1:5),
    paste0("travel_times_", 
      c("health_facility", "local_markets", "water_sources")
    ),
    paste0("ccare_danger_", 1:10), "ccare_danger_score", "ccare_participation",
    paste0("ccare_barriers_", 1:5), paste0("pica_frequency_", 1:5),
    paste0("play1", letters[1:7]), "play2", paste0("play3", letters[1:6]),
    "see", "hear",
    paste0("pica_response_", 1:5), "pica_perception"
  )
  
  interpolate_indicators(
    vars = vars, sf_data = sf_data, int_points = int_points
  )
}


interpolate_indicators_woman <- function(sf_data, int_points) {
  vars <- c(
    paste0("delivery_location_", 1:5), "anc_four", "anc_well", "delivery_well",
    paste0("delivery_assist_", 1:9), "delivery_return",
    paste0("delivery_difficulty_", 1:6), "mother_days_to_pnc",
    "mother_pnc_check", paste0("pnc_mother_", 0:3), "child_days_to_pnc",
    "child_pnc_check", paste0("pnc_child_", 0:3), "nc_protect",
    paste0("pnc_card_", 1:3), "preg_malaria", "preg_anaemia", "preg_more",
    paste0("danger_", 1:10), "danger_all", paste0("labor_", 1:6),
    paste0("newborn_", 1:8),
    "mal_prevalence", "mal_no_treatment", 
    "mal_appropriate_treatment", "folate", "tt_any", "tt_two_more",
    "idk1", "idk2",
    paste0("pmtct", 1:3), "fp_use", "fp_wait_time_appropriate", 
    paste0("benefit_next_", 1:7), paste0("benefit_first_", 1:9), 
    paste0("multiparity_danger_", 1:9), "fp_wait_abort_appropriate",
    "von1_no_choice", "von1_little_choice", "von1_some_choice", 
    "von1_lots_choices", "von2_no", "von2_little", "von2_enough", 
    "von2_a_lot", "von3_never", "von3_sometimes", "von3_almost",
    "von3_always", "von4_freely", "von4_freely_consent", 
    "von4_husband_consent", "von4_someone_consent",
    paste0("phq_", c("no_depression", "minimal_to_mild", "major", "severe")),
    paste0("alcohol_frequency_", 1:5), "wdds", "mddw",
    "bmi", "bmi_underweight", "bmi_overweight", "bmi_obese",
    "muac_undernutrition"
  )
  
  interpolate_indicators(
    vars = vars, sf_data = sf_data, int_points = int_points
  )
}


interpolate_indicators_child <- function(sf_data, int_points) {
  vars <- c(
    "diarrhoea_episode", "diarrhoea_treatment",
    paste0("diarrhoea_poc_", 1:6), "diarrhoea_treatment_ors",
    paste0("diarrhoea_treatment_", 1:10),
    "rti_episode", "rti_treatment", paste0("rti_poc_", 1:6),
    paste0("rti_treatment_", 1:5),
    "fever_episode", "fever_treatment", paste0("fever_poc_", 1:6),
    "fever_rdt", "fever_smear", "fever_test", "fever_test_result",
    paste0("fever_malaria_", 1:7), "fever_malaria_intake",
    "imm_card1", "imm_card2", "bcg_card_recall", "opv1_card_recall", 
    "opv2_card_recall", "opv3_card_recall", "opv4_card_recall", 
    "dpt1_card_recall", "dpt2_card_recall", "dpt3_card_recall", 
    "rub1_card_recall", "rub2_card_recall", "pcv1_card_recall", 
    "pcv2_card_recall", "pcv3_card_recall", "vorh1_card_recall", 
    "vorh2_card_recall", "imm_full_recall", "imm_appropriate_recall",
    "bcg_card_only", "opv1_card_only", "opv2_card_only", "opv3_card_only",
    "opv4_card_only", "dpt1_card_only", "dpt2_card_only", "dpt3_card_only",
    "rub1_card_only", "rub2_card_only", "pcv1_card_only", "pcv2_card_only", 
    "pcv3_card_only", "vorh1_card_only", "vorh2_card_only", "imm_full_card", 
    "imm_appropriate_card", "vita_at_least_once", "vita_0", "vita_1",
    "vita_2", "deworm", "meal_frequency", "fg_dairy", "fg_starch", "fg_vita",
    "fg_other_fruit_veg", "fg_legumes", "fg_meat", "fg_eggs", "fg_score",
    "bf_ever", "bf_early", "bf_continuing", "bf_exclusive", "icfi_score", 
    "icfi_good", "iycf_good", "hfaz", "global_stunting", "moderate_stunting",
    "severe_stunting", "wfaz", "global_underweight", "moderate_underweight",
    "severe_underweight", "wfhz", "global_wasting_whz", "moderate_wasting_whz",
    "severe_wasting_whz", "mmuac", "global_wasting_muac", "moderate_wasting_muac",
    "severe_wasting_muac", "oedema"
  )
  
  interpolate_indicators(
    vars = vars, sf_data = sf_data, int_points = int_points
  )
}
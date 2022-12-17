################################################################################
#
#'
#' Create indicator list
#'
#
################################################################################

create_indicator_list <- function(id = c("household", "carer", "woman", "child")) {
  id <- match.arg(id)
  
  # Household indicators -------------------------------------------------------
  if (id == "household") {
    ## Variable names ----------------------------------------------------------
    vars <- c(
      "hh_size", paste0("roof_type_", 1:9), paste0("floor_type_", 1:9),
      "overcrowded", "own_home", "electricity", paste0("cooking_fuel_", 1:8),
      paste0("lighting_fuel_", 1:7), paste0("cooking_location_", 1:3),
      "separate_kitchen", "radio", "tv", "cellphone", "computer", "bicycle",
      "motorcycle", "motorcar", "fridge", "food_preserver",
      "association_member", "association_presentation_attendance",
      "association_member_participant", "presentation_facilitator_1",
      "presentation_facilitator_2", "association_information_usage",
      "q07FamilyPlanning", "q07FoodNutrition", "q07Health", "q07Hygiene",                         
      "q07Latrines", "q07SocialProtection", "q07Vaccine", "q07WaterTreatment",
      "q07Other", "q07Any", 
      paste0("ge", 1:10) |> 
        lapply(FUN = paste0, c("_men", "_women", "_both")) |> 
        unlist(),
      paste0("water_", c(
        "surface", "unimproved", "limited", "basic", "sufficient")
      ), 
      paste0("water_sufficient_reasons_", 1:3), 
      "water_collection_time", "water_filter_use", "water_filter_adequate",
      paste0("san_", c("open", "unimproved", "limited", "basic")),
      "hygiene_wash_recent", paste0("handwash_event_", 1:6),
      paste0(
        "hygiene_", 
        c("wash_appropriate", "child_defecation")
      ),
      paste0("diaper_disposal_", 1:8), "hygiene_child_diaper",
      "hdds", "fcs", "fcs_poor", "fcs_borderline", "fcs_acceptable",
      "rcsi", "rcsi_minimal", "rcsi_stressed", "rcsi_crisis",
      "lcsi", "lcsi_secure", "lcsi_stress", "lcsi_crisis", "lcsi_emergency",
      paste0("corn_", 0:4), paste0("rice_", 0:4), paste0("millet_", 0:4), 
      paste0("sorghum_", 0:4), paste0("cassava_", 0:4), 
      paste0("sweet_potato_", 0:4), paste0("legumes_", 0:4),
      "net_any", "net_adequate", paste0("net", 1:4)
    )
    ## Labels ------------------------------------------------------------------
    labs <- c(
      "Mean household size", 
      paste0("Proportion of households with roof made of ", 
        c("cane/leaf/straw/grass", "zinc", "luzalite", "aluminium", "wood", 
          "cement", "plastic", "calamine", "other")
      ),
      paste0("Proportion of households with floor made of ", 
        c("earth/sand", "dung", "wood planks", "palm/bamboo",
          "parquet or polished wood", "vinyl or asphalt strips",
          "ceramic tiles", "cement", "carpet")
      ),
      "Proportion of households that are overcrowded",
      "Proportion of households who own the home they live in",
      "Proportion of households with electricity",
      paste0("Proportion of households by type of cooking fuel - ",
        c("Electricity", "Gas", "Paraffin", "Wood", "Coal/charcoal", "Solar",
          "Dung", "Other")
      ),
      paste0("Proportion of households by type of lighting fuel - ",
        c("Electricity", "Gas", "Paraffin", "Candles", "Solar", "Flashlight",
          "Other")
      ),
      "Proportion of households that cook food inside the house",
      "Proportion of households that cook in a separate house or hut",
      "Proportion of households that cook food outside the house",
      "Proportion of households that have a separate kitchen",
      paste0("Proportion of households that own a ",
        c("radio", "television", "cellphone", "computer", "bicycle",
          "motorcycle", "motorcar", "fridge", "food preserver")
      ),
      "Proportion of households with a member who is part of a community association within the past year",
      "Proportion of households with a member who participated in a community association presentation within the past year",
      "Proportion of households with a member who is either a part of a community association or participated in a community association presentation in the past year",
      "Community association presentation facilitated by a non-governmental organisation",
      "Community association presentation facilitated by a government health institution",
      "Proportion of households with a member who has used the information obtained from community association presentations",
      "Proportion of households with a member who participated in family planning community activities",
      "Proportion of households with a member who participated in food and nutrition community activities",
      "Proportion of households with a member who participated in health community activities",
      "Proportion of households with a member who participated in hygiene community activities",
      "Proportion of households with a member who participated in latrines-building community activities",
      "Proportion of households with a member who participated in social protection community activities",
      "Proportion of households with a member who participated in vaccination community activities",
      "Proportion of households with a member who participated in water treatment community activities",
      "Proportion of households with a member who participated in other community activities",
      "Proportion of households with a member who participated in any community activities",
      "Proportion of households in which men decide the appropriate age to marry",
      "Proportion of households in which women decide the appropriate age to marry",
      "Proportion of households in which both men and women decide the appropriate age to marry",
      "Proportion of households in which men decide the use of condoms",
      "Proportion of households in which women decide the use of condoms",
      "Proportion of households in which both men and women decide the use of condoms",
      "Proportion of households in which men decide on household responsibilities",
      "Proportion of households in which women decide on household responsibilities",
      "Proportion of households in which both men and women decide on household responsibilities",
      "Proportion of households in which men decide on the number of children to have",
      "Proportion of households in which women decide on the number of children to have",
      "Proportion of households in which both men and women decide on the number of children to have",
      "Proportion of households in which men decide on family/land chores",
      "Proportion of households in which women decide on family/land chores",
      "Proportion of households in which both men and women decide on family/land chores",
      "Proportion of households in which men decide on the administrative of finances",
      "Proportion of households in which women decide on the administration of finances",
      "Proportion of households in which both men and women decide on the administration of finances",
      "Proportion of households in which men decide on how to raise children",
      "Proportion of households in which women decide on how to raise children",
      "Proportion of households in which both men and women decide on how to raise children",
      "Proportion of households in which men decide on hitting/spanking children",
      "Proportion of households in which women decide on hitting/spanking children",
      "Proportion of households in which both men and women decide on hitting/spanking children",
      "Proportion of households in which men decide on seeking healthcare for pregnancy",
      "Proportion of households in which women decide on seeking healthcare for pregnancy",
      "Proportion of households in which both men and women decide on seeking healthcare for pregnancy",
      "Proportion of households in which men decide on seeking healthcare for child",
      "Proportion of households in which women decide on seeking healthcare for child",
      "Proportion of households in which both men and women decide on seeking healthcare for child",
      "Proportion of households with a surface water source",
      "Proportion of households with an unimproved water source",
      "Proportion of households with a limited water source",
      "Proportion of households with a basic water source",
      "Proportion of households with a sufficient water source",
      "Proportion of households that have experienced water not being available at the source",
      "Proportion of households that have experienced water being too expensive",
      "Proportion of households that have experienced water source not being accessible",
      "Mean water collection time in minutes",
      "Proportion of households that use a water filter",
      "Proportion of households that use an adequate water filter",
      "Proportion of households that practice open defecation",
      "Proportion of households with unimproved toilet facility",
      "Proportion of households with limited toilet facility",
      "Proportion of households with basic toilet facility",
      "Proportion of household respondents who washed their hands recently",
      paste0("Proportion of household respondents who report washing their hands ",
        c("after using latrine/defecation", 
          "after cleaning up faeces of children", "before preparing food",
          "before giving food to children", "before eating", 
          "at other instances")
      ),
      "Proportion of household respondents who washed their hands with soap and water or with ashes recently",
      "Proportion of household respondents who recently had their child defecate in an appropriate location",
      paste0("Proportion of household respondents by disposal  method of soiled diapers - ",
        c("Discarded diaper in latrine", 
          "Washed with water and discarded the water in the latrine",
          "Washed with water and discarded the water in the sink",
          "Washed with water and discarded water in the yard",
          "Discarded the diaper in the trash",
          "Discarded the diaper in the yard", 
          "Buried", "Other")
      ),
      "Proportion of household respondents who recently washed their child's soiled diapers at the appropriate frequency",
      "Mean household dietary diversity score",
      "Mean food consumption score",
      "Proportion of households with poor food security based on food consumption score",
      "Proportion of households with borderline food security based on food consumption score",
      "Proportion of households with acceptable food security based on food consumption score",
      "Mean reduced coping strategy index",
      "Proportion of households with minimal level of food insecurity based on reduced coping strategies index",
      "Proportion of households with stressed level of food insecurity based on reduced coping strategies index",
      "Proportion of households with crisis level of food insecurity based on reduced coping strategies index",
      "Mean livelihoods coping strategy index",
      "Proportion of households with secure level of food security based on livelihoods coping strategies index",
      "Proportion of households with stressed level of food insecurity based on livelihoods coping strategies index",
      "Proportion of households with crisis level of food insecurity based on livelihoods coping strategies index",
      "Proportion of households with emergency level of food insecurity based on livelihoods coping strategies index",
      "Proportion of households with no corn reserves",
      "Proportion of households with less than one month of corn reserves",
      "Proportion of households with 1 to 3 months of corn reserves",
      "Proportion of households with 4 to 6 months of corn reserves",
      "Proportion of households with more than 6 months of corn reserves",
      "Proportion of households with no rice reserves",
      "Proportion of households with less than one month of rice reserves",
      "Proportion of households with 1 to 3 months of rice reserves",
      "Proportion of households with 4 to 6 months of rice reserves",
      "Proportion of households with more than 6 months of rice reserves",
      "Proportion of households with no millet reserves",
      "Proportion of households with less than one month of millet reserves",
      "Proportion of households with 1 to 3 months of millet reserves",
      "Proportion of households with 4 to 6 months of millet reserves",
      "Proportion of households with more than 6 months of millet reserves",
      "Proportion of households with no sorghum reserves",
      "Proportion of households with less than one month of sorghum reserves",
      "Proportion of households with 1 to 3 months of sorghum reserves",
      "Proportion of households with 4 to 6 months of sorghum reserves",
      "Proportion of households with more than 6 months of sorghum reserves",
      "Proportion of households with no cassava reserves",
      "Proportion of households with less than one month of cassava reserves",
      "Proportion of households with 1 to 3 months of cassava reserves",
      "Proportion of households with 4 to 6 months of cassava reserves",
      "Proportion of households with more than 6 months of cassava reserves",
      "Proportion of households with no sweet potato reserves",
      "Proportion of households with less than one month of sweet potato reserves",
      "Proportion of households with 1 to 3 months of sweet potato reserves",
      "Proportion of households with 4 to 6 months of sweet potato reserves",
      "Proportion of households with more than 6 months of sweet potato reserves",
      "Proportion of households with no legumes reserves",
      "Proportion of households with less than one month of legumes reserves",
      "Proportion of households with 1 to 3 months of legumes reserves",
      "Proportion of households with 4 to 6 months of legumes reserves",
      "Proportion of households with more than 6 months of legumes reserves",
      "Proportion of households with at least one mosquito net",
      "Proportion of households with adequate number of mosquito nets",
      "Proportion of households with no mosquito nets",
      "Proportion of households with mosquito nets less than the number of beds/sleeping mats",
      "Proportion of households with one mosquito net for every bed/sleeping mat",
      "Proportion of households with more mosquito nets than the number of beds/sleeping mats"
    )
    ## Indicator set -----------------------------------------------------------
    indicator_set <- c(
      rep("Housing characteristics", 41), 
      rep("Household assets", 9), 
      rep("Household participation in associations", 16), 
      rep("Household decision making", 30),
      rep("Water, sanitation, and hygiene", 33),
      "Household dietary diversity score",
      rep("Food consumption score", 4), 
      rep("Reduced coping strategy index", 4),
      rep("Livelihoods coping strategies index", 5), 
      #"Food insecurity experience scale",
      rep("Food stocks", 35),
      rep("Mosquito net ownership", 6)
    )
    
    ## Mapping function --------------------------------------------------------
    map_function <- c(
      rep("plot_qual_map", 19), "plot_divergent_map",
      rep("plot_qual_map", 30), rep("plot_divergent_map", 3),
      rep("plot_qual_map", 2),  rep("plot_divergent_map", 11),
      rep("plot_qual_map", 30), rep("plot_divergent_map", 8),
      "plot_qual_map", rep("plot_divergent_map", 72)
    )
    
    direction <- c(
      "lo", rep("hi", 18), "lo", rep("hi", 76), rep("lo", 3), rep("hi", 2),
      rep("lo", 4), rep("hi", 2), rep("lo", 3), rep("hi", 15), rep("lo", 2),
      rep("hi", 4), "lo", rep("hi", 4), rep("lo", 2), rep("hi", 2), 
      rep("lo", 5), rep("hi", 2), rep("lo", 3), rep("hi", 2), rep("lo", 3),
      rep("hi", 2), rep("lo", 3), rep("hi", 2), rep("lo", 3), rep("hi", 2),
      rep("lo", 3), rep("hi", 2), rep("lo", 3), rep("hi", 2)
    )
    
    pal <- ifelse(
      map_function == "plot_qual_map", 
      "get_qual_colours(n = n)", 
      "get_div_colours(n = n)"
    ) |>
      (\(x)
         ifelse(
           direction == "lo", paste0("rev(", x, ")"), x
         )
      )()
    
    indicator_list <- data.frame(
      id = seq_len(length(vars)),
      indicator_group = "Household",
      indicator_set = indicator_set,
      indicator_variable = vars,
      indicator = labs#,
      #map_function = map_function,
      #pal = pal,
      #direction = direction
    )
  }
  
  # Carer indicators -----------------------------------------------------------
  if (id == "carer") {
    ## Variable names ----------------------------------------------------------
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
      paste0("ccare_barriers_", 1:5), 
      paste0("play1", letters[1:7]), "play2", paste0("play3", letters[1:6]),
      "see", "hear", paste0("pica_frequency_", 1:5),
      paste0("pica_response_", 1:5), "pica_perception"
    )
    ## Indicator labels --------------------------------------------------------
    labs <- c(
      "Mean age of carers", 
      paste0("Proportion of carers by sex - ", c("Male", "Female")),
      paste0("Proportion of carers by marital status - ",
        c("Single", "Married", "Civil union", "Divorced/separated", "Widowed")
      ),
      paste0("Proportion of carers by highest educational attainment - ",
        c("Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6",
          "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12",
          "Professional training", "Non-college degree", "College degree",
          "Literacy")
      ),
      "Proportion of carers who live with their partners",
      "Mean age of partners",
      paste0("Proportion of partners by highest educational attainment - ",
        c("Grade 1", "Grade 2", "Grade 3", "Grade 4", "Grade 5", "Grade 6",
          "Grade 7", "Grade 8", "Grade 9", "Grade 10", "Grade 11", "Grade 12",
          "Professional training", "Non-college degree", "College degree",
          "Literacy")
      ),
      paste0("Proportion of carers by income source - ",
        c("Sale of agricultural products and/or animals",
          "Self-employed (commercial, service)",
          "Assitência alimentar/ajuda/ganho ganho/biscate",
          "Fishing", "Salary, pension, remittance", "Other")
      ),
      paste0("Proportion of carers by income amount - ",
        c("No income/or remittances not declared in money",
          "Less than 60-150 Mts per month",
          "From Mts 150.01 to Mts 500.00 per month",
          "From Mts 500.01 to Mts 1500.00 per month",
          "From Mts 1500.01 to Mts 3500.00 per month",
          "From Mts 3500.01 to Mts 5500.00 per month",
          "From Mts 5500.01 to Mts 7500.00 per month",
          "From Mts 7500.01 to Mts 9500.00 per month",
          "More than Mts 9500.00 per month")     
      ),
      paste0("Proportion of carers by occupation - ",
        c("Homemaker", "Your land", "Fishing", "Wage labor", "Business", "Other")       
      ),
      paste0("Proportion of partners by occupation - ",
        c("None", "Your land", "Fishing", "Wage labor", "Business", "Other",
          "I do not have a partner/husband")
      ),
      paste0("Proportion of carers by mode of travel to town - ",
        c("On foot", "Bicycle", "Bus", 
          "My own motorized vehicle (motorcycle, car, etc.)", "Truck",
          "I don't travel", "Boat", "Carro chapa", "Chate", "Comboio", "Moto")
      ),
      paste0("Proportion of carers by mode of travel to health facility - ",
        c("On foot", "Bicycle", "Motorcycle", "Car", "Other")
      ),
      paste0("Proportion of carers by mode of travel to local markets - ",
        c("On foot", "Bicycle", "Motorcycle", "Car", "Other")
      ),
      paste0("Proportion of carers by mode of travel to water source - ",
        c("On foot", "Bicycle", "Motorcycle", "Car", "Other")
      ),
      "Mean travel time in minutes to health facility",
      "Mean travel time in minutes to local markets",
      "Mean travel time in minutes to water sources",
      paste0("Proportion of carers by child danger sign identified - ",
        c("Fever", "Blood in stool", "Diarrhoea with dehydration", 
          "Cough, rapid respiration and/or difficulty breathing", 
          "Unable to drink water, breastfeed, or eat", "Vomiting",
          "Convulsions", "Loss of consciousness", 
          "Fatigue/no response/not wanting to play", "Neck rigidity")       
      ),
      "Mean number of child danger signs identified by carer",
      "Proportion of carers who report that partners support/contribute in taking care of child health care needs",
      paste0("Proportion of carers by reported child health care access barriers - ",
             c("Distance", "Transport", "Money", "Poor treatment at health facility", "Other")       
      ),
      "Proportion of carers who sing songs for or with their child",
      "Proportion of carers who take their child for a walk away from home",
      "Proportion of carers who play games with their child",
      "Proportion of carers who read books or see photos with their child",
      "Proportion of carers who tell stories to their child",
      "Proportion of carers who name things around their child",
      "Proportion of carers who draw things for or with their child",
      "Proportion of carers who provide their child with a bag or a box to keep their things in",
      "Proportion of carers who play with their child while giving them a bath",
      "Proportion of carers who play with their child when feeding",
      "Proportion of carers who play with their child when changing their clothes/diaper",
      "Proportion of carers who play with their child while working at home",
      "Proportion of carers who play with their child while working in the field",
      "Proportion of carers who play with their child during their free time",
      "Proportion of carers who report knowing that children can see from birth",
      "Proportion of carers who report knowing that children can hear from birth",
      paste0("Proportion of carers by the reported frequency of their child eating dirt - ",
        c("0 times", "<1 time per day", "Once per day", "2-5 times per day", 
               "More than 5 times per day")
      ),
      paste0("Proportion of carers by response to their child eating dirt - ",
        c("Stop the child from putting the dirt in their mouth",
          "Remove the dirt from the hands/mouth of the child",
          "Wash the hands of the child with water only",
          "Wash the hands of the child with water and soap/ash",
          "Do not do anything")     
      ),
      "Proportion of carers who believe that eating dirt is bad for their child's health"
    )
    ## Indicator set -----------------------------------------------------------
    indicator_set <- c(
      rep("Carer and partner characteristics", 42),
      rep("Carer and partner income and occupation", 28),
      rep("Travel modalities and time to travel", 29),
      rep("Childcare practices", 17),
      rep("Child development", 16),
      rep("Pica", 11)
    )
    
    indicator_list <- data.frame(
      id = seq_len(length(vars)),
      indicator_group = "Carer",
      indicator_set = indicator_set,
      indicator_variable = vars,
      indicator = labs
    )
  }
  
  # Women indicators -----------------------------------------------------------
  if (id == "woman") {
    ## Indicator variables -----------------------------------------------------
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
    ## Indicator labels --------------------------------------------------------
    labs <- c(
      paste0("Proportion of women of reproductive age by delivery location for her youngest child - ",
        c("Health facility/hospital", "In your own house", 
          "The house of a traditional birth attendant", 
          "House of a neighbour/family member", "Other")
      ),
      "Proportion of women of reproductive age who attended at least 4 antenatal care visits during pregnancy for youngest child",
      "Proportion of women of reproductive age who report being treated well during antenatal care visits",
      "Proportion of women of reproductive age who report being treated well during delivery for youngest child",
      paste0("Proportion of women of reproductive age by the person who assisted during delivery for her youngest child - ",
        c("Doctor", "Nurse", "Midwife", "Other person", "Traditional midwife",
          "Community health worker", "Relative/friend", "Other", "Nobody")
      ),
      "Proportion of women of reproductive age who report that they will come back to health facility for their next delivery",
      paste0("Proportion of women of reproductive age by difficulties in delivery reported - ",
        c("Cost", "Distance", "Stigma (shame)", "Poor roads", "Other", "No")
      ),
      "Mean number of days until post-natal check sought by woman of reproductive age after delivery of her youngest child",
      "Proportion of women of reproductive age who received post-natal check",
      "Proportion of women of reproductive age who didn't receive post-natal check",
      "Proportion of women of reproductive age who received post-natal check immediately after delivery",
      "Proportion of women of reproductive age who received post-natal check within 24 hours of delivery",
      "Proportion of women of reproductive age who received post-natal check more than 24 hours after delivery",
      "Mean number of days until post-natal check sought by woman of reproductive age for child after delivery",
      "Proportion of women of reproductive age whose youngest child received post-natal check",
      "Proportion of women of reproductive age whose youngest child didn't receive post-natal check",
      "Proportion of women of reproductive age whose youngest child received post-natal check immediately after delivery",
      "Proportion of women of reproductive age whose youngest child received post-natal check within 24 hours of delivery",
      "Proportion of women of reproductive age whose youngest child received post-natal check more than 24 hours after delivery",
      "Proportion of women of reproductive age whose youngest child was protected from cold after delivery",
      "Proportion of pregnant women who are able to show her pre-natal card",
      "Proportion of pregnant women who report having a pre-natal card but are not able to show it",
      "Proportion of pregnant women who do not have a pre-natal card",
      "Proportion of pregnant women who report having had malaria",
      "Proportion of pregnant women who report having anaemia",
      "Proportion of pregnant women who report wanting to have more children after current pregnancy",
      paste0("Proportion of pregnant women by pregnancy danger signs identified - ",
        c("Bleeding or vaginal fluid", "Severe headache", "Blurry vision",
          "Swollen hands and feet", "Convulsions", "Fever", "Intense abdominal pain",
          "Loss of consciousness", "Fatigue", "Accelerated/diminished fetal movement")
      ),
      "Proportion of pregnant women who are able to identify all ten pregnancy danger signs",
      paste0("Proportion of pregnant women by actions they will take during labour - ",
        c("Go to the closest hospital", "Ask a nearby relative/family member/neighbour to come help",
          "Call a traditional birth attendant", "Stay alone with your husband/partner",
          "Stay all alone", "Other")
      ),
      paste0("Proportion of pregnant women by newborn danger signs identified - ",
        c("Difficulty breathing", "Jaundice (yellow eyes/skin)",
          "Poor feeding", "Fever/warm body", "Cold body", "Convulsions",
          "Vomiting", "Lack of stooling")
      ),
      "Proportion of women of reproductive age who had malaria during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who didn't receive treatment for malaria during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who received appropriate treatment for malaria during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who received folate tablets during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who received any dose of tetanus toxoid vaccination during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who received two or more doses of tetanus toxoid vaccination during their pregnancy for their youngest child",
      "Proportion of women of reproductive age who received mosquito net during their most recent pregnancy",
      "Proportion of women of reproductive age who slept under a mosquito net during their most recent pregnancy",
      "Proportion of women of reproductive age who received voluntary counselling and testing during her pregnancy for her youngest child or her current pregnancy",
      "Proportion of women of reproductive age who received their voluntary counselling and testing results during her pregnancy for her youngest child or her current pregnancy",
      "Proportion of women of reproductive age who were offered medication to lower the risk of child transmission during her pregnancy for her youngest child or her current pregnancy",
      "Proportion of women of reproductive age who have used or tried a method to delay or avoid pregnancy",
      "Proportion of women of reproductive age who know the appropriate/ideal waiting time after birth before trying to get pregnant again",
      paste0("Proportion of women of reproductive age by reported benefits of waiting for next pregnancy - ",
        c("Less risk to the health of the mother", 
          "Less risk to the health of the child",
          "Avoid poverty", 
          "More probability that your children will be educated",
          "Other",
          "None",
          "Growth/development")
      ),
      paste0("Proportion of women of reproductive age by reported benefits of waiting until after 18 years before getting pregnant - ",
        c("Less risk to the health of the mother", 
          "Less risk to the health of the child",
          "Avoid poverty", 
          "More probability that your children will be educated",
          "Other",
          "None",
          "Education", "Birth complications", "Growth/development")
      ),
      paste0("Proportion of women of reproductive age by reported dangers of having more than 4 children - ",
        c("Maternal mortality",
          "Death of the baby",
          "Poverty",
          "Less probability that the children will be educated",
          "Other",
          "None", "Maternal morbidity", "Birth complications", "It depends")       
      ),
      "Proportion of women of reproductive age who know the appropriate/ideal waiting time to get pregnant after a spontaneous abortion",
      paste0("Proportion of women of reproductive age by levels of freedom of choice they feel they have on what happens to their lives - ",
        c("No choice", "Little choice", "Some choice",  "A lot of choice")
      ),
      paste0("Proportion of women of reproductive age by levels they feel they can decide their own destiny - ",
        c("Not at all", "A little", "Enough",  "A lot")
      ),
      paste0("Proportion of women of reproductive age by levels of ability to decide by themselves without consulting their husbands - ",
        c("Never", "Sometimes", "Almost always",  "Always")
      ),
      paste0("Proportion of women of reproductive age by levels of participation in this survey - ",
        c("I accepted to participate voluntarily and freely", 
          "Yes, but I need the consent of the male head of household", 
          "No, I needed the consent of the male head of household",  
          "I need someone else's consent")
      ),
      "Proportion of women of reproductive age who have no depression",
      "Proportion of women of reproductive age who have minimal to mild depression",
      "Proportion of women of reproductive age who have major depression",
      "Proportion of women of reproductive age who have severe depression",
      paste0("Proportion of women of reproductive age by frequency of alcohol consumption - ",
        c("Never", "Monthly or less", "Between 2-4 times per month",
          "Between 2-3 times per week", "4 or more times per week")       
      ),
      "Mean women's dietary diversity score",
      "Proportion of women of reproductive age who consumed at least 5 food groups in the last 24 hours",
      "Mean women's body mass index",
      "Proportion of women of reproductive age who are underweight based on body mass index",
      "Proportion of women of reproductive age who are overweight based on body mass index",
      "Proportion of women of reproductive age who are obese based on body mass index",
      "Proportion of women of reproductive age who are wasted based on mid-upper arm circumference"
    )
    ## Indicator set -----------------------------------------------------------
    indicator_set <- c(
      rep("Pre-natal, natal and post-natal care", 37),
      rep("Treatment and services during pregnancy", 39),
      rep("Prevention of mother to child transmission", 3),
      rep("Family planning", 28),
      rep("Women's empowerment", 16),
      rep("Women's mental health and alcohol consumption", 9),
      rep("Women's diet and nutritional status", 7)
    )
    
    indicator_list <- data.frame(
      id = seq_len(length(vars)),
      indicator_group = "Woman",
      indicator_set = indicator_set,
      indicator_variable = vars,
      indicator = labs
    )
  }
  
  # Child indicators -----------------------------------------------------------
  if (id == "child") {
    ## Variables names ---------------------------------------------------------
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
      "severe_wasting_whz", "cmuac", "global_wasting_muac", "moderate_wasting_muac",
      "severe_wasting_muac", "oedema"
    )
    ## Indicator labels --------------------------------------------------------
    labs <- c(
      "Proportion of children 0-59 months old who had a diarrhoea episode in the past 2 weeks",
      "Proportion of children 0-59 months old who sought treatment for diarrhoea",
      paste0("Proportion of children 0-59 months old by point-of-care for diarrhoea treatment  - ",
        c("Health facility", "Traditional healer", "Agente Polivalente Elementar",
          "Family member", "Pharmacy", "Other")
      ),
      "Proportion of children 0-59 months old who received oral rehydration solution as treatment for diarrhoea",
      paste0("Proportion of children 0-59 months old by diarrhoea treatment - ",
        c("Pills/syrup", "Injections", "Intravenous Serum", "Rice water",
          "Cereal pap", "Tea made of herbs and roots", "Powdered/fresh milk",
          "Tea/Fruit juice/coconut milk", "Home-made remedy/medicinal herbs",
          "Other")
      ),
      "Proportion of children 0-59 months old who had a cough episode in the past 2 weeks",
      "Proportion of children 0-59 months old who sought treatment for cough",
      paste0("Proportion of children 0-59 months old by point-of-care for cough treatment  - ",
        c("Health facility", "Traditional healer", "Agente Polivalente Elementar",
          "Family member", "Pharmacy", "Other")
      ),
      paste0("Proportion of children 0-59 months old by cough treatment - ",
        c("Antibiotic", "Paracetamol/Panadol/Acetaminophen", "Aspirin",
          "Ibuprofen", "Other")
      ),
      "Proportion of children 0-59 months old who had a fever episode in the past 2 weeks",
      "Proportion of children 0-59 months old who sought treatment for fever",
      paste0("Proportion of children 0-59 months old by point-of-care for fever treatment  - ",
        c("Health facility", "Traditional healer", "Agente Polivalente Elementar",
          "Family member", "Pharmacy", "Other")
      ),
      "Proportion of children 0-59 months old tested for malaria using a rapid diagnostic test",
      "Proportion of children 0-59 months old tested for malaria using a smear test",
      "Proportion of children 0-59 months old tested for malaria with rapid diagnostic test or a smear test",
      "Proportion of children 0-59 months old with a positive rapid diagnostic test or smear test for malaria",
      paste0("Proportion of children 0-59 months old by treatment provided for malaria - ",
        c("Coartem (AL) CP", "Amodiaquina + Artesanato (ASAQ)", "Fansidar CP",
          "Quinino CP", "Quinino INJ", "Artesanato", "Paracetamol Comprimido/Xarope")      
      ),
      "Proportion of children 0-59 months old who took anti-malarial treatment on the same day or the day after onset of fever",
      "Proportion of children 0-59 months old who report having an immunisation card",
      "Proportion of children 0-59 months old who are able to show an immunisation card",
      "Proportion of children 0-59 months old who received BCG based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of OPV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of OPV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of OPV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 4 of OPV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of DPT based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of DPT based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of DPT based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of MMR based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of MMR based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of PCV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of PCV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of PCV based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of VORH based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of VORH based on recall or on immunisation card",
      "Proportion of children 12-23 months old who are fully immunised based on recall or on immunisation card",
      "Proportion of children 0-59 months old who are fully immunised appropriate for their age based on recall or on immunisation card",
      "Proportion of children 0-59 months old who received BCG based on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of OPV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of OPV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of OPV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 4 of OPV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of DPT based on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of DPT based on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of DPT based on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of MMR based on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of MMR based on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of PCV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of PCV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 3 of PCV based on immunisation card",
      "Proportion of children 0-59 months old who received dose 1 of VORH based on immunisation card",
      "Proportion of children 0-59 months old who received dose 2 of VORH based on immunisation card",
      "Proportion of children 12-23 months old who are fully immunised based on immunisation card",
      "Proportion of children 0-59 months old who are fully immunised appropriate for their age based on immunisation card",
      "Proportion of children 6-59 months old who received at least one dose of vitamin A",
      "Proportion of children 6-59 months old who did not receive any dose of vitamin A",
      "Proportion of children 6-59 months old who received only one dose of vitamin A",
      "Proportion of children 6-59 months old who received two doses of vitamin A",
      "Proportion of children 12-59 months old who received deworming treatment",
      "Mean meal frequency for the past 24 hours for children 6-23 months old",
      "Proportion of children 6-23 months old who consumed dairy and dairy products in the past 24 hours",
      "Proportion of children 6-23 months old who consumed starchy staples in the past 24 hours",
      "Proportion of children 6-23 months old who consumed vitamin A-rich fruits and vegetables in the past 24 hours",
      "Proportion of children 6-23 months old who consumed other fruits and vegetables in the past 24 hours",
      "Proportion of children 6-23 months old who consumed legumes, nuts, and seeds in the past 24 hours",
      "Proportion of children 6-23 months old who consumed meat, organ meat, poultry, and fish in the past 24 hours",
      "Proportion of children 6-23 months old who consumed eggs in the past 24 hours",
      "Mean food group score for children 6-23 months old",
      "Proportion of children 0-23 months old who have ever breastfed",
      "Proportion of children 0-23 months old who were initiated to breastfeeding early",
      "Proportion of children 6-23 months old who are continuing to breastfeed",
      "Proportion of children 0-5 months old who are exclusively breastfed",
      "Mean ICFI score for children 6-23 months old",
      "Proportion of children 6-23 months old who practice good/appropriate infant and child feeding",
      "Proportion of children 0-23 months old who practice good/appropriate infant and child feeding",
      "Mean height-for-age z-score of children 6-59 months old",
      "Proportion of children 6-59 months old with height-for-age z-score less than -2",
      "Proportion of children 6-59 months old with height-for-age z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with height-for-age z-score less than -3",
      "Mean weight-for-age z-score of children 6-59 months old",
      "Proportion of children 6-59 months old with weight-for-age z-score less than -2",
      "Proportion of children 6-59 months old with weight-for-age z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with weight-for-age z-score less than -3",
      "Mean weight-for-height z-score of children 6-59 months old",
      "Proportion of children 6-59 months old with weight-for-height z-score less than -2",
      "Proportion of children 6-59 months old with weight-for-height z-score less than -2 and greater than or equal to -3",
      "Proportion of children 6-59 months old with weight-for-height z-score less than -3",
      "Mean mid-upper arm circumference (cms) for children 6-59 months old",
      "Proportion of children 6-59 months old with mid-upper arm circumference less than 12.5 cms",
      "Proportion of children 6-59 months old with mid-upper arm circumference less than 12.5 cms and greater than or equal to 11.5 cms",
      "Proportion of children 6-59 months old with mid-upper arm circumference less than 11.5 cms",
      "Proportion of children 6-59 months old with nutritional oedema"
    )
    ## Indicator set -----------------------------------------------------------
    indicator_set <- c(
      rep("Period prevalence of childhood illnesses and treatment-seeking", 52),
      rep("Child immunisation, vitamain A supplementation, and deworming coverage", 41),
      rep("Meal frequency", 1),
      rep("Food groups", 8),
      rep("Breastfeeding practices", 4),
      rep("Infant and young child feeding", 3),
      rep("Child nutritional status", 17)
    )
    
    indicator_list <- data.frame(
      id = seq_len(length(vars)),
      indicator_group = "Child",
      indicator_set = indicator_set,
      indicator_variable = vars,
      indicator = labs
    )
  }
  
  indicator_list
}


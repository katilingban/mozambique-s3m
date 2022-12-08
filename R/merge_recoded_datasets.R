

merge_recoded_dataset <- function(df_list) {
  Reduce(
    f = function(x, y) merge(x, y, all.x = TRUE),
    x = df_list
  )
}


# df_list <- list(
#   hdds_recoded_data,
#   fcs_recoded_data,
#   rcsi_recoded_data,
#   wdds_recoded_data,
#   mddw_recoded_data,
#   lcsi_recoded_data,
#   phq_recoded_data,
#   ccare_recoded_data,
#   rcsi_recoded_data,
#   dev_recoded_data,
#   carer_recoded_data,
#   wem_recoded_data,
#   work_recoded_data,
#   travel_recoded_data,
#   play_recoded_data,
#   net_recoded_data,
#   water_recoded_data,
#   san_recoded_data,
#   hygiene_recoded_data,
#   fever_recoded_data,
#   diarrhoea_recoded_data,
#   rti_recoded_data,
#   bf_recoded_data,
#   fg_recoded_data,
#   meal_recoded_data,
#   iycf_recoded_data,
#   fies_recoded_data,
#   stock_recoded_data,
#   preg_recoded_data,
#   pmtct_recoded_data,
#   pnet_recoded_data,
#   nc_recoded_data,
#   rh_recoded_data,
#   fp_recoded_data
# )
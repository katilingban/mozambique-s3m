################################################################################
#
#'
#' Get associations indicator set variables
#'
#
################################################################################

association_recode <- function(.data) {
  core_vars <- get_core_variables(raw_data_clean = .data)
  
  association_member <- ifelse(
    .data[["q05"]] %in% c(2, 8:9) | is.na(.data[["q05"]]), 0, 1
  )
  
  association_presentation_attendance <- ifelse(
    .data[["q06"]] %in% c(2, 8:9) | is.na(.data[["q06"]]), 0, 1
  )
  
  association_member_participant <- ifelse(
    association_member == 1 | association_presentation_attendance == 1, 1, 0
  )
  
  presentation_facilitator <- ifelse(
    .data[["q06a"]] %in% c(3:4, 8:9), NA, .data[["q06a"]]
  ) |>
    spread_vector_to_columns(fill = 1:2, prefix = "presentation_facilitator")
  
  association_information_usage <- ifelse(
    .data[["q06b"]] %in% c(2:3, 8:9) | is.na(.data[["q06b"]]), 0, 1
  )
  
  ## we need to recode q07_specify
  q07 <- vector(mode = "character", length = length(.data$q07_specify))
  q07[is.na(.data$q07_specify)] <- NA
  q07[.data$q07_specify == "Saude"] <- "HEALTH"
  q07[.data$q07_specify == "HIV"] <- "HEALTH"
  q07[.data$q07_specify == "Sanidade do meio e higiene"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpezas na zona"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza da escola"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  do mercado"] <- "HYGIENE"
  q07[.data$q07_specify == "Grupo de INAS"] <- "SOCIAL PROTECTION"
  q07[.data$q07_specify == "Planeamento  Familiar"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Limpeza"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no hospital"] <- "HYGIENE"
  q07[.data$q07_specify == "Capanha do covid 19"] <- "HEALTH"
  q07[.data$q07_specify == "Higiene e Saneamento do Meio"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  do mercado  e Sede do partido"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de poço  comunitário  e nas vias de acessos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpezas"] <- "HYGIENE"
  q07[.data$q07_specify == "Palestra de HIV Sida"] <- "HEALTH"
  q07[.data$q07_specify == "Aconselhamento"] <- "HEALTH"
  q07[.data$q07_specify == "Vacina para criancas"] <- "VACCINE"
  q07[.data$q07_specify == "Limpeza de casa e estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de casa e latribas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das vias de acesso e quintal"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza na comunidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpar Rua para nao ser Mordido com cobras"] <- "HYGIENE"
  q07[.data$q07_specify == "Combate à Malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Limpesa de Das ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "HIV e Tuberculose"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento  do  meio"] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento  do meio"] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento  do  meio "] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento do meio"] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento do meio "] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de locais publicos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas vias de acesso e nos quintais"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das vias publicas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza e higiene oral"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza comunitaria"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza do bairro"] <- "HYGIENE"
  q07[.data$q07_specify == "Luta contra Malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza da zona no combate à malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Sensibilização  comunitaria"] <- "HEALTH"
  q07[.data$q07_specify == "Li,peza dentro de casa e no quintal"] <- "HYGIENE"
  q07[.data$q07_specify == "Sensibilizacao as mulheres para participarem nos programas de vacinação"] <- "VACCINE"
  q07[.data$q07_specify == "Limpeza de casa, quintal e estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  do mercado  e vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  do mercado  e centro de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Mãe modelo"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  do posto Administrativo  de mussapassa"] <- "HYGIENE"
  q07[.data$q07_specify == "Reunião e limpeza  de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Evitar queimada"] <- "HEALTH"
  q07[.data$q07_specify == "Lavagem de maos"] <- "HYGIENE"
  q07[.data$q07_specify == "Uso de mascaras"] <- "HEALTH"
  q07[.data$q07_specify == "Limpesa de estrada"] <- "HYGIENE"
  q07[.data$q07_specify == "Promoção de vacinas contra covid 19"] <- "VACCINE"
  q07[.data$q07_specify == "Jornada de limpeza"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza a locais publicos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas casas e tratamento da agua"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de estradas e nabombadeagua"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das Ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  no centro  de saúde  e no mercado"] <- "HYGIENE"
  q07[.data$q07_specify == "Higiene e saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Saude oralve higiene"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza na rua"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza em lugares publicos"] <- "HYGIENE"
  q07[.data$q07_specify == "Chefe do Quarteirão"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza no Bairro"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no hospital e ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza do quarteirão"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza em locais publicos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de posto e hospital"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no mercado e estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no mercado"] <- "HYGIENE"
  q07[.data$q07_specify == "Palestras na zona sobre Higiene"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no posto administrativo"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza na sede  e na Escola."] <- "HYGIENE"
  q07[.data$q07_specify == "Activistas de PIN"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza Nas ruas nas Escolas, nos posto da localidade e hospital"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza na fonte de e tratamento da agua com cloro"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza de casa e lateinas"] <- "HYGIENE"
  q07[.data$q07_specify == "Saneamento da zona"] <- "HYGIENE"
  q07[.data$q07_specify == "Comid 19"] <- "HEALTH"
  q07[.data$q07_specify == "Higiene e saneamento do meio"] <- "HYGIENE"
  q07[.data$q07_specify == "Participa em palestra das mãe moderna para a redução da mal nutrição na comunidade"] <- "FOOD & NUTRITION"
  q07[.data$q07_specify == "Saúde Materno infantil"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  na localidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas estradas e Escolas"] <- "HYGIENE"
  q07[.data$q07_specify == "Construcao de latrinas melhoradas e Tarimbas para conservacao de utensilios domesticos"] <- "LATRINES"
  q07[.data$q07_specify == "Limpeza no quintal"] <- "HYGIENE"
  q07[.data$q07_specify == "Manter a higiene  nas casas e vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de quintal, mercado, estradas e fontenarias"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das ruas na comunida"] <- "HYGIENE"
  q07[.data$q07_specify == "Poupança"] <- "SOCIAL PROTECTION"
  q07[.data$q07_specify == "Limpezas nos caminhos e abertura de valas de drenagem"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das Ruas de accesso as residencias"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de casa"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de casas"] <- "HYGIENE"
  q07[.data$q07_specify == "Cultura de rendimento"] <- "SOCIAL PROTECTION"
  q07[.data$q07_specify == "Saneamento"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de casa e vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Mãe  Modelo e limpeza  no centro  de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de hospital  e mercado"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de estradas e vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  da praça"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no centro  de  saúde  e vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  do centro  de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza comunitário"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de centro de  saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Resolução  de problemas  na comunidade"] <- "OTHER"
  q07[.data$q07_specify == "Construir canoa, fazer limpeza na localidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza na estrada."] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza na escola e na Localidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Agente polivalente"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza de caminhos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza em caminhos"] <- "HYGIENE"
  q07[.data$q07_specify == "Palestra sobre HIV e dts"] <- "HEALTH"
  q07[.data$q07_specify == "Sensibilização das famílias"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza Nos caminhos da povoacao"] <- "HYGIENE"
  q07[.data$q07_specify == "Prevencao contra amalaria"] <- "HEALTH"
  q07[.data$q07_specify == "Prevention de casamento prematuros"] <- "HEALTH"
  q07[.data$q07_specify == "Reunião, limpeza  na escola abertura de vias de acesso"] <- "HYGIENE"
  #q07[.data$q07_specify == "Abertura de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura de  vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de  vias  de  acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de  vias  de  acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de  vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas ruas e bombas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas ruas e no poço"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Uso correcto  de rede mosqueteiras "] <- "HEALTH"
  q07[.data$q07_specify == "Planeamento familiar"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Casamentos prematuro"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Reunions da zona"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza  de vias  de acesso  e centro  de  saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  no centro  de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Vacinação"] <- "VACCINE"
  q07[.data$q07_specify == "Palestra e sensibilizacao Das comunidade em DTS"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza da estrada"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza do Sistema de Abastecimento de Água"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza de pátio no centro de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nos caminhos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  vias de acesso, e fonte de água"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza nas vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Prevencao contra diarreias"] <- "HEALTH"
  q07[.data$q07_specify == "Sensibilizacao das mulheres para cuidar da higiene das criancas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das vias de acesso para as fontenarias"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza nas ruas e mercados"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias publicas"] <- "HYGIENE"
  q07[.data$q07_specify == "Malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Malaria "] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza de estradas , Escolas e Fontenarias"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza nas estradas e escolas"] <- "HYGIENE"
  q07[.data$q07_specify == "Higiene"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias de acesso, poços, limpeza na escola e centro  de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Cultivo de batata de polpa alaranjada"] <- "FOOD & NUTRITION"
  q07[.data$q07_specify == "Sobrevivência "] <- "HEALTH"
  q07[.data$q07_specify == "Apicultura "] <- "FOOD & NUTRITION"
  q07[.data$q07_specify == "Construção de latrinas"] <- "LATRINES"
  q07[.data$q07_specify == "Vacinacao contra covid19"] <- "VACCINE"
  q07[.data$q07_specify == "Limpeza de estradas e fontenarias"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza em casa, conservacao de utensilios domesticos"] <- "HYGIENE"
  q07[.data$q07_specify == "Sensibilizacao sobre Malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Saúde materna e infantil."] <- "HEALTH"
  q07[.data$q07_specify == "Covid 19"] <- "VACCINE"
  q07[.data$q07_specify == "Abertura de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpezado centrode saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Sensibilizar pessoas da necessidade do uso das redes mosquiteiras para prevencao da malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Palestras"] <- "HEALTH"
  q07[.data$q07_specify == "Limpezas de caminhos"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  ,uso de rede mosqueteiros"] <- "HEALTH"
  q07[.data$q07_specify == "Abertura  de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Água e saneamento"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Sensibilizacao sobre planeamento familiar"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Limpeza do Bairro"] <- "HYGIENE"
  q07[.data$q07_specify == "Latrina"] <- "LATRINES"
  q07[.data$q07_specify == "Limpeza  nas ruas,uso adequado  das redes mosqueteiros, e saneamento  do meio"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Aperture de Estrada para prevents malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Higiene e saneamento"] <- "HYGIENE"
  q07[.data$q07_specify == "Ativista da saúde"] <- "HEALTH"
  q07[.data$q07_specify == "Higiene e saneamento na comunidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Sensibilização da comunidade"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza das ruas e centro de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Marido"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Vacinação  contra COVID19"] <- "VACCINE"
  q07[.data$q07_specify == "Vacinação"] <- "VACCINE"
  q07[.data$q07_specify == "Vacinacao"] <- "VACCINE"
  q07[.data$q07_specify == "Malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Alimentação na mulher gravida"] <- "FOOD & NUTRITION"
  q07[.data$q07_specify == "Uso de rede mosquiteira"] <- "HEALTH"
  q07[.data$q07_specify == "Poupanças"] <- "SOCIAL PROTECTION"
  q07[.data$q07_specify == "Abertura  de  vias  de  acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza do Zona"] <- "HYGIENE"
  q07[.data$q07_specify == "Sensibilizacao comunitaria"] <- "HEALTH"
  q07[.data$q07_specify == "Palestra sobre hiv"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza de Abertura de Estradas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza bairro"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso  e limpeza de  poço"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Covid"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza das vias de acesso e na fonte de agua"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Limpeza de quintal, vias de acesso e fontes de agua"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Uso correcto da rede mosquiteira"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza de capim"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  de  vias  acesso  e posto de  socorro"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza das vias de acesso e fontes de agua1"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Comite de agua"] <- "WATER TREATMENT"
  q07[.data$q07_specify == "Pai é APE"] <- "OTHER"
  q07[.data$q07_specify == "Abertura de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura de vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura de  vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de vias  de acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Abertura  de  vias  de  acesso "] <- "HYGIENE"
  q07[.data$q07_specify == "Boas práticas agricolas"] <- "FOOD & NUTRITION"
  q07[.data$q07_specify == "Sensibilização comunitaria de  saúde"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  de  vias de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpezas nas ruas e palestras."] <- "HYGIENE"
  q07[.data$q07_specify == "Uso de redes mosquiteiras para prevencao de malaria"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza  de  vias  acesso  e Sede"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Difundir a informacoes transmitidas nas palestra ou encontros"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza conjunta na aldeia"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de Estrada"] <- "HYGIENE"
  q07[.data$q07_specify == "Lazer limpeza  na comunidade"] <- "HYGIENE"
  q07[.data$q07_specify == "Uso da rede mosquiteira"] <- "HEALTH"
  q07[.data$q07_specify == "Palestra sobre planeamento e vacinacao"] <- "VACCINE"
  q07[.data$q07_specify == "Limpeza de caminhos e ruas"] <- "HYGIENE"
  q07[.data$q07_specify == "Prevenção  de Covid19"] <- "HEALTH"
  q07[.data$q07_specify == "Sensibilizacao comunitária"] <- "HEALTH"
  q07[.data$q07_specify == "Saneamento do meio e planeamento familiar"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "covid 19"] <- "HEALTH"
  q07[.data$q07_specify == "FDC"] <- "SOCIAL PROTECTION"
  q07[.data$q07_specify == "Limpeza de vias  de acesso  e centro  de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Incontinência  urinaria"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza das vias"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza nas casas"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  mercado, vias de  acesso  e no centro de saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "COVID 19"] <- "HEALTH"
  q07[.data$q07_specify == "Limpeza nas estradas e vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "planeamento familiar"] <- "FAMILY PLANNING"
  q07[.data$q07_specify == "Sensibilizao da comunidade para aderir as unidades sanitarias"] <- "HEALTH"
  q07[.data$q07_specify == "Limpezas nas vias de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza no  centro  de  saúde"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza de  hospital  e vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Descriminação"] <- "OTHER"
  q07[.data$q07_specify == "Limpeza  de  vias  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  vias  de  acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  vias acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  vias  de acesso"] <- "HYGIENE"
  q07[.data$q07_specify == "Limpeza  de  vias  acesso , centro  de  saúde"] <- "HYGIENE"
  
  ## Binary variables for each cclass of participatory activity (measure of community mobiiations)
  q07FamilyPlanning <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07FamilyPlanning[q07 == "FAMILY PLANNING"] <- 1
  
  q07FoodNutrition <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07FoodNutrition[q07 == "FOOD & NUTRITION"] <- 1
  
  q07Health <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07Health[q07 == "HEALTH"] <- 1
  
  q07Hygiene <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07Hygiene[q07 == "HYGIENE"] <- 1
  
  q07Latrines <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07Latrines[q07 == "LATRINES"] <- 1
  
  q07SocialProtection <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07SocialProtection[q07 == "SOCIAL PROTECTION"] <- 1
  
  q07Vaccine <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07Vaccine[q07 == "VACCINE"] <- 1
  
  q07WaterTreatment <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07WaterTreatment[q07 == "WATER TREATMENT"] <- 1
  
  q07Other <- vector(mode = "numeric", length = length(.data$q07_specify))
  q07Other[q07 == "OTHER"] <- 1
  
  q07Any <- ifelse(
    q07FamilyPlanning + q07FoodNutrition + q07Health + q07Hygiene + 
      q07Latrines + q07SocialProtection + q07Vaccine + q07WaterTreatment + 
      q07Other > 0, 1, 0
  )
  
  data.frame(
    core_vars, association_member, association_presentation_attendance,
    association_member_participant, presentation_facilitator,
    association_information_usage, q07FamilyPlanning, q07FoodNutrition,
    q07Health, q07Hygiene, q07Latrines, q07SocialProtection, q07Vaccine,
    q07WaterTreatment, q07Other, q07Any
  )
}





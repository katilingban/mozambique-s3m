################################################################################
#
#' 
#' Process and recode water data/indicators
#'
#' Relevant variables:
#'
#'   wt2 - Usually, where do you get your drinking water for the family members of 
#'     the household? integer variables for the following categorial values:
#'     
#'     1=House faucet; 
#'     2=Yard faucet; 
#'     3=Neighbours faucet; 
#'     4=Public faucet; 
#'     5=Water pump; 
#'     6=Well with lid; 
#'     7=Open well; 
#'     8=Protected stream; 
#'     9=Non-protected stream; 
#'     10=Rain; 
#'     11=River/lake/lagoon; 
#'     12=Bottled; 
#'     13=Other; 
#'     88=Don&apos;t know; 
#'     99=No response
#'
#'   wt2_other - Specify other source of drinking water; text entry; will need
#'     translation
#'
#'   wt3 - Who usually goes to this source to collect water for the family?
#'     integer variables for the following categorial values:
#'   
#'     1=Adult males; 
#'     2=Adult females; 
#'     3=Young girls; 
#'     4=Young boys; 
#'     5=Other; 
#'     88=Don&apos;t know; 
#'     99=No response
#'
#'   wt3a - How long does it take for this person to go collect water, counting 
#'     total time of travel to go, come back, and collect water? integer
#'
#'   wt3b	How many times has this person collected water in the past 7 days?
#'     integer
#'
#'   wt4 - In the last month, has there been a moment in which your household 
#'     did not have sufficient water to drink?
#'     
#'     1=Yes, at least one time; 
#'     2=No, it was always sufficient; 
#'     88=Don&apos;t know; 
#'     99=No response
#'
#'   wt4a - What was the principal reason for not being able to access water in 
#'     a sufficient quantity?
#'
#'     1=Water not available at the source; 
#'     2=Water is too expensive; 
#'     3=Source not accessible; 
#'     88=Don&apos;t know; 
#'     99=No response
#'
#'   wt5 - Have you ever done anything to the water to make it cleaner to drink?
#'
#'     1=Yes; 
#'     2=No
#'
#'   wt6 - What do you normally do to make your water cleaner to drink?
#'
#'     1=Boil; 
#'     2=Lixivia/chlorine; 
#'     3=Certeza; 
#'     4=Filter with cloth; 
#'     5=Use water filter (ceramic, sand, compost, etc); 
#'     6=Solar disinfection; 
#'     7=Let stand and sit; 
#'     8=Other; 
#'     88=Don&apos;t know; 
#'     99=No response   
#'     
#
################################################################################
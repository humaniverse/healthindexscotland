#' Rate of Patient Admissions for Alcohol Related Conditions (2021/22)
#'
#' A dataset containing statistics on the rate of patient admissions for
#' all alcohol related admissions in each Council, 2021/22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{alcohol_admissions_per_100k}{Rate of patient admissions per 100k population,
#' based on number of patient admissions and using European Age-sex Standardised Rates.
#' The number of patients is defined as the number of unique individuals treated
#' within the financial year. Patients are counted only once in the financial year
#' in which they have an alcohol-related stay, even though the same patient may
#' be admitted to hospital several times in a year. Mid 2022 population estimates are used.}
#' \item{year}{Financial year}
#'
#' ...
#' }
#' @source \url{https://www.opendata.nhs.scot/dataset/alcohol-related-hospital-statistics-scotland/resource/b0b520e8-3507-46cd-a9b5-cff03007bb57}
#' @source \url{https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/mid-2022#:~:text=Of%20the%2032%20council%20areas,and%20Orkney%20Islands%20with%2022%2C020}
#'
"lives_alcohol_misuse"

#' Percentage of Cancer Screening Uptake (2020-2022)
#'
#' A dataset containing statistics on the percentage of cancer screening uptake
#' in each Council, 2020-2022/
#'
#'
#' @format A data frame with 32 row and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{cancer_screening_uptake}{Percentage of cancer screening uptake. Only
#' bowel cancer screening uptake is included here.}
#' \item{year}{Time period - three year aggregates}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
#'
"lives_cancer_screening"

#' Percentage of Discharges per 1,000 for Cardiovascular Conditions (2022/23)
#'
#' A dataset containing statistics on the percentage of discharges per 1,000 for
#' cardiovascular conditions in each Council, 2022/23.
#'
#'
#' @format A data frame with 32 variables and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{cardiovascular_discharges_per_1k}{Percentage of total cardiovascular discharges per 1k population.
#' Cardiovascular conditions includes angina, coronary heart disease, heart
#' attack, and heart failure. Scottish 2022 mid year population estimates were used}
#' \item{year}{Financial year}
#'
#' ...
#' }
#' @source \url{https://www.opendata.nhs.scot/dataset/scottish-heart-disease-statistics/resource/5379a655-d677-46cf-814d-bc0574ac59e4}
#' @source \url{https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/mid-2022#:~:text=Of%20the%2032%20council%20areas,and%20Orkney%20Islands%20with%2022%2C020}

"lives_cardiovascular_conditions"

#' Percentage of Absolute Child Poverty (2022-2023)
#'
#' A dataset containing statistics on the percentage of children (aged under
#' 16) living in absolute low income families in each Council, 2022-23.
#'
#'
#' @format A data drame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{child_poverty_percentage}{Percentage of children under 16 living in
#' absolute low incomes families (where a household's income is below 60% of
#' the median income in 2010/11, adjusted for inflation).}
#' \item{year}{Financial Year}
#'
#' ...
#' }
#' @source \url{ https://www.gov.uk/government/statistics/children-in-low-income-families-local-area-statistics-2014-to-2023}
#'
"lives_child_poverty"

#' Percentage of Childhood Vaccine Coverage (2023)
#'
#' A dataset containing statistics on childhood vaccine coverage in each Council, 2022/23.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{child_vaccine_coverage_percentage}{Percentage of vaccine coverage. Includes
#' childhood immunisation statistics (6in1, PCV, rotavirus, MenB, (12 months); 6in1, MMR1, Hib/MenC, PCVb,
#' MenB Booster (24 months); 6in1, MMR1, Hib/MenC, 4in1, MMR2 (3-5 years); MMR1,
#' 4in1, MMR2 (4-6 years))}
#' \item{year}{School Year}
#'
#' ...
#' }
#' @source \url{https://publichealthscotland.scot/publications/childhood-immunisation-statistics-scotland/childhood-immunisation-statistics-scotland-quarter-ending-30-june-2024/}
#'
"lives_child_vaccine_coverage"

#' Rate of Drug Related Hospital Stays (2021/22)
#'
#' A dataset containing statistics on the rate of drug related hospital stays in
#' each Council, 2021/22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{drug_related_stays_per_100k}{Rate of hospital stays per 100k population,
#'  using European Age-sex Standardised Rates.A hospital stay, also described as
#'  a continuous inpatient stay or CIS, is defined as an unbroken period of time
#'  that a patient spends as an inpatient or day-case. During a stay a patient
#'  may have numerous episodes as they change consultant, significant facility,
#'  speciality and/or hospital. Stays are counted at the point of discharge, when
#'  all diagnostic information regarding the full stay is available. Mid 2022 population
#'  estimates are used.}
#' \item{year}{Financial year}
#'
#' ...
#' }
#' @source \url{https://www.opendata.nhs.scot/dataset/drug-related-hospital-statistics-scotland/resource/46f9d70b-8517-4af3-b65e-dbcd13dfa388}
#' @source \url{https://www.nrscotland.gov.uk/statistics-and-data/statistics/statistics-by-theme/population/population-estimates/mid-year-population-estimates/mid-2022#:~:text=Of%20the%2032%20council%20areas,and%20Orkney%20Islands%20with%2022%2C020}
#'
"lives_drug_misuse"

#' Percentage of Children with Developmental Concerns (2022-23)
#'
#' A dataset containing statistics on early childhood developmental concerns in
#' each Council, 2022-23.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{developmental_concerns_percent}{Percentage of developmental reviews with
#' a concern in one or more domains, out of total number of recorded reviews while
#' child is 2 and in the cohort.}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.opendata.nhs.scot/dataset/27-30-month-review-statistics/resource/018ba0e1-6562-43bb-82c5-97b6c6cc22d8}
#'
"lives_early_years_development"

#' Percentage of People that Eat Healthy (2016-19)
#'
#' A dataset containing statistics on fruit and vegetable consumption in
#' each Council, 2016-19.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{healthy_eating_percent}{Percentage of people that consume
#' 5 portions or more of fruit and vegetable per day}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{ https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y}
#'
"lives_healthy_eating"


#' Percentage of Job Related Training (2023-24)
#'
#' A dataset containing job related training in Scottish councils.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{job_related_training_perc}{Percentage of all who received job related
#'  training in last 4 wks - aged 16-64}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.nomisweb.co.uk/datasets/apsnew}
"lives_job_training"

#' Rate of infant mortality (2017-2021)
#'
#' A dataset containing statistics on the rate of infant mortality in each
#' Council, 2017-2021.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{infant_mortality_rate_per_1k}{Rate of infants per 1k that have died
#' under the age of 1}
#' \item{year}{Time period - five year aggregate}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
"lives_infant_mortality"

#' Percentage of Babies Born Not at a Healthy Birth Weight (2020-2022)
#'
#' A dataset containing percentage babies born not at a healthy birth weight.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{not_healthy_birth_rate_percentage}{Percentage of babies born not at a healthy birth weight}
#' \item{year}{Time period - three year aggregate}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
"lives_low_birth_weight"

#' Percentage Grade A-C in Maths and English, Provisional National 5 Attainments (2024)
#'
#' A dataset containing statistics on Provisional National 5 Attainments in Maths and English,
#' on results day, in each Council, August 2024
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{national_five_attainment_percent}{Grade A-C percentage in Maths
#' and English (average of the two subjects taken)}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.sqa.org.uk/sqa/105123.html}
#'
"lives_national_five_attainment"

#' Percentage of Adults Overweight/Obese (2016-19)
#'
#' A dataset containing statistics on percentage of adults clinically classed
#' as overweight and obese in each Council, 2016-19.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{adult_overweight_obesity_percentage}{Percentage of adults clinically classed
#' as overweight and obese.}
#' \item{year}{Time frame}
#'
#' ...
#' }
#' @source \url{https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data}
#'
"lives_overweight_obesity_adults"

#' Percentage of Children Overweight/Obese (2022/23)
#'
#' A dataset containing statistics on percentage of children clinically classed
#' as overweight, obese, and severely obese in each Council, 2022/23.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{overweight_obese_percentage}{Percentage of children clinically classed
#' as overweight, obese, and severely obese. BMI is used as the unit of measurement.
#' Based on children in Primary 1 (aged 4-5).}
#' \item{year}{School Year period}
#'
#' ...
#' }
#' @source \url{ https://www.opendata.nhs.scot/dataset/primary-1-body-mass-index-bmi-statistics/resource/4a3daa0f-1580-4a59-ac9e-64d9a31a4429}
#'
"lives_overweight_obesity_children"

#' Percentage of People Meeting Recommended Activity Levels (2018-22)
#'
#' A dataset containing statistics on activity levels in
#' each Council, 2018-22.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{activity_levels_met_percent}{Percentage of people that meet the recommended
#' activity levels}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://statistics.gov.scot/resource?uri=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data}
#'
"lives_physical_activity"

#' Crude Rate of School Exclusion (2019-2021)
#'
#' A dataset containing crude rate of school exclusion rate 1,000 aged 15-19
#' in each Council, 2019-2021.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{pupil_absence_per_1k}{Crude exclusion rate of pupil absence per 1,000
#' students}
#' \item{year}{School year}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
#'
"lives_pupil_absence"

#' Percentage of Current Smokers (2018-22)
#'
#' A dataset containing statistics on smoking status in
#' each Council, 2018-22.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{smoking_percent}{Percentage of people that are current smokers}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{ https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y}
#'
"lives_smoking"

#' Crude Rate of Teenage Pregnancies (2019-2021)
#'
#' A dataset containing crude rate of teenage pregnancies per 1,000 aged 15-19
#' in each Council, 2019-2021.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{teenage_pregnancy_per_1k}{Crude rate of teenage pregnancies per 1,000
#' females aged 15-19}
#' \item{year}{Time period - three year aggregate}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
#'
"lives_teenage_pregnancy"

#' Percentage of People in Unemployment (2021-22)
#'
#' A dataset containing statistics on estimated unemployment rates in each Council, 2021-22. Estimates based on a model
#' which utilises the Annual Population Survey estimates of unemployment along with the Claimant Count averaged over 12 months.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{unemployment_percentage}{Estimated percentage of people that are unemployed.
#' Unemployment is defined as someone aged 16+ without a job who were available
#' to start work in the two weeks following their interview and who had either
#' looked for work in the four weeks prior to interview or were waiting to start
#' a job they had already obtained}
#' \item{year}{Financial Year}
#'
#' ...
#' }
#' @source \url{ https://www.ons.gov.uk/employmentandlabourmarket/peoplenotinwork/unemployment/datasets/modelledunemploymentforlocalandunitaryauthoritiesm01}
#'
"lives_unemployment"

#' Rate of Non-Fatal Workplace Injuries (2022-23)
#'
#' A dataset containing statistics on the rate of non-fatal workplace injuries
#' per 100,000 in each Council, 2022-23.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{non_fatal_injuries_per_100k_employees}{Rate of non-fatal employee
#' injuries per 100k population}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.hse.gov.uk/statistics/tables/index.htm#riddor}
#'
"lives_workplace_safety"

#' Percentage participation of Young People in Education, Training or Employment (2023)
#'
#' A dataset containing data on participation of young people in education, training
#' or employment, by Council (2023).
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{young_people_participation_education_training_employment_percentage}{Percentage
#' of 16-19 year olds in education, training or employment}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
"lives_young_people_training"


#' Child Mental Wellbeing Score (2013)
#'
#' A dataset containing secondary school pupils' mental wellbeing scores (2013).
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{child_mental_wellbeing_score}{Mean mental wellbeing score for S4 pupils.
#' The Warwick–Edinburgh Mental Wellbeing Scale (WEMWBS) used
#' here: scoring is between 14-70 with a higher score indicative of greater
#' positive mental wellbeing}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
"people_child_mental_health"

#' Average Measurement of Life Satisfaction Out of 10 (2022-23 / Orkney Islands
#' (2020-21))
#'
#' A dataset containing statistics of personal ratings on feelings of life
#' satisfaction out of 10, by Council (2022-23) except Orkney Islands (2020-21).
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{life_satisfaction_score_out_of_10}{Average personal ratings on feelings
#' of life satisfaction out of 10, 10 - most satisfied, 1 - least satisfied}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.ons.gov.uk/datasets/wellbeing-local-authority/editions/time-series/versions/4}
"people_life_satisfaction"

#' Air pollution (2023)
#'
#' A dataset containing population-weighted annual mean PM2.5 data for 2023, by
#' Scottish Council Area. Uses the anthropogenic component.
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{air_pollution_weighted}{Population-weighted annual mean PM2.5}
#' \item{year}{Year}
#'
#' ...
#' }
#' @source \url{https://uk-air.defra.gov.uk/data/pcm-data}
#'
"places_air_pollution"

#' Low-level crime (2023-4)
#'
#' A dataset containing statistics on 'low-level crime' per 10,000 people in Scottish
#' Council Areas. England's Health Index defines 'low-level crimes' as bicycle theft
#' and shoplifting. Of the two, Scotland only publishes shoplifting data. There
#' are other crimes listed that could potentially count as 'low-level crimes'
#' but we will avoid making a potentially arbitrary judgement here.
#'
#' @format A data frame with 32 rows and 2 variables:
#' \describe{
#'   \item{ltla24_code}{Local Authority Code}
#'   \item{low_level_crimes_per_10000}{Number of low-level crimes per 10,000 people}
#'   \item{year}{Year}
#' ...
#' }
#' @source \url{https://www.gov.scot/publications/recorded-crime-scotland-2023-24/}
#'
"places_low_level_crime"

#' Personal crime (2023-24)
#'
#' A dataset containing statistics on 'personal crime' per 10,000 people in Scottish
#' Council Areas. 'Personal crime' is defined as
#' - Non-sexual crimes of violence (includes robbery)
#' - Sexual crimes
#' - Damage and reckless behaviour
#'
#' @format A data frame with 32 rows and 2 variables:
#' \describe{
#'   \item{ltla24_code}{Local Authority Code}
#'   \item{personal_crimes_per_10000}{Number of personal crimes per 10,000 people}
#'   \item{year}{Year}
#' ...
#' }
#' @source \url{https://www.gov.scot/publications/recorded-crime-scotland-2023-24/}
#'
"places_personal_crime"

#' Road traffic volume (2023)
#'
#' A dataset containing volume of road traffic (millions of vehicle miles per
#' square kilometre) in Scottish Local Authorities.
#'
#' The raw local authority traffic figures give the total volume (vehicle miles)
#' of traffic across each local authority for the whole year.
#' \describe{
#'   \item{ltla24_code}{Local Authority Code}
#'   \item{traffic_volume}{}
#'   \item{year}{Year}
#' ...
#' }
#' @source \url{https://roadtraffic.dft.gov.uk/}
#'
"places_traffic_volume"

#' Road safety (2022)
#'
#' A dataset containing number of people killed or seriously injured in each
#' Scottish Council Area in 2022 (latest available data), normalised by the area
#' in each Council Area (in square km).
#'
#' @format A data frame with 32 rows and 2 variables:
#' \describe{
#' \item{ltla24_code}{Local Authority Code}
#' \item{road_accident_count_by_area}{Number of people killed or seriously injured, normalised by land area (km^2)}
#' \item{year}{Year}
#' ...
#' }
#' @source \url{https://statistics.gov.scot/data/road-safety}
#'
"places_road_safety"

#' Rough sleeping (2023-24)
#'
#' A dataset containing statistics on number of homelessness applications where
#' at least one member of the household was sleeping rough within the previous
#' three months, normalised per 100,000 residents.
#'
#' @format A data frame with 32 rows and 2 variables:
#' \describe{
#'   \item{ltla24_code}{Local Authority Code}
#'   \item{rough_sleeping_per_10k}{number of homelessness applications where
#' at least one member of the household was sleeping rough within the previous
#' three months, normalised per 100,000 residents.}
#' #'   \item{year}{Year}
#' ...
#' }
#' @source \url{https://www.gov.scot/publications/homelessness-in-scotland-2023-24/}
#'
"places_rough_sleeping"


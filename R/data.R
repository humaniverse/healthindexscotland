#' Rate of Patient Admissions for Alcohol Related Conditions (2021/22)
#'
#' A dataset containing statistics on the rate of patient admissions for
#' all alcohol related admissions in each Council, 2021/22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
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
"hl_alcohol_misuse"

#' Rate of Drug Related Hospital Stays (2021/22)
#'
#' A dataset containing statistics on the rate of drug related hospital stays in
#' each Council, 2021/22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
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
"hl_drug_misuse"

#' Percentage of Children with Developmental Concerns (2022-23)
#'
#' A dataset containing statistics on early childhood developmental concerns in
#' each Council, 2022-23.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
#' \item{developmental_concerns_percent}{Percentage of developmental reviews with
#' a concern in one or more domains, out of total number of recorded reviews while
#' child is 2 and in the cohort.}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{https://www.opendata.nhs.scot/dataset/27-30-month-review-statistics/resource/018ba0e1-6562-43bb-82c5-97b6c6cc22d8}
#'
"hl_early_years_development"

#' Percentage of People that Eat Healthy (2016-19)
#'
#' A dataset containing statistics on fruit and vegetable consumption in
#' each Council, 2016-19.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
#' \item{healthy_eating_percent}{Percentage of people that consume
#' 5 portions or more of fruit and vegetable per day}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{ https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y}
#'
"hl_healthy_eating"

#' Percentage of People Meeting Recommended Activity Levels (2018-22)
#'
#' A dataset containing statistics on activity levels in
#' each Council, 2018-22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
#' \item{activity_levels_met_percent}{Percentage of people that meet the recommended
#' activity levels}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{ https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y}
#'
"hl_physical_activity"

#' Percentage of Current Smokers (2018-22)
#'
#' A dataset containing statistics on smoking status in
#' each Council, 2018-22.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
#' \item{smoking_percent}{Percentage of people that are current smokers}
#' \item{year}{Time period}
#'
#' ...
#' }
#' @source \url{ https://statistics.gov.scot/slice?dataset=http%3A%2F%2Fstatistics.gov.scot%2Fdata%2Fscottish-health-survey-local-area-level-data&http%3A%2F%2Fpurl.org%2Flinked-data%2Fcube%23measureType=http%3A%2F%2Fstatistics.gov.scot%2Fdef%2Fmeasure-properties%2Fpercent&http%3A%2F%2Fpurl.org%2Flinked-data%2Fsdmx%2F2009%2Fdimension%23refPeriod=http%3A%2F%2Freference.data.gov.uk%2Fid%2Fgregorian-interval%2F2016-01-01T00%3A00%3A00%2FP4Y}
#'
"hl_smoking"
#'
#' Crude Rate of Teenage Pregnancies (2019-2021)
#'
#' A dataset containing crude rate of teenage pregnancies per 1,000 aged 15-19
#' in each Council, 2019-2021.
#'
#'
#' @format A data frame with 32 rows and 3 variables:
#' \describe{
#' \item{ltla19_code}{Local Authority Code}
#' \item{teenage_pregnancy_per_1k}{Crude rate of teenage pregnancies per 1,000
#' females aged 15-19}
#' \item{year}{Time period - three year aggregate}
#'
#' ...
#' }
#' @source \url{https://scotland.shinyapps.io/ScotPHO_profiles_tool/}
#'
"hl_teenage_pregnancy"

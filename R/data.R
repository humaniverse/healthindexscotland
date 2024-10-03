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

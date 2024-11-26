library(httr)
library(readxl)
library(dplyr)
library(geographr)
library(ggplot2)

hb_ltla_lookup <- lookup_dz11_ltla19_hb19 |>
  distinct(ltla19_code, hb19_code)

hb_lookup <- boundaries_hb19 |>
  sf::st_drop_geometry()

GET(
  "https://hpspubsrepo.blob.core.windows.net/hps-website/nss/3073/documents/3_genital-chlamydia-gonorrhoea-scotland-2010-2019-tables.xlsx",
  write_disk(tf <- tempfile(fileext = ".xlsx"))
)

chlamydia <-
  read_excel(tf, sheet = "Tables 4a&b", range = "B3:F18") |>
  select(
    hb19_name = `NHS Board`,
    chlamydia_women_rate = `Women Rate per 100,000`,
    chlamydia_men_rate = `Men Rate per 100,000`
  ) |>
  rowwise() |>
  mutate(
    chlamydia_rate_100k = mean(c(chlamydia_women_rate, chlamydia_men_rate))
  ) |>
  ungroup() |>
  select(hb19_name, chlamydia_rate_100k)

gonorrhoea <-
  read_excel(tf, sheet = "Table 9", range = "B3:H18") |>
  slice(-1) |>
  select(
    hb19_name = `NHS Board`, gonorrhoea_rate_100k = `All Rate per 100,000`
  ) |>
  mutate(
    gonorrhoea_rate_100k = if_else(
      gonorrhoea_rate_100k == "*", NA, as.double(gonorrhoea_rate_100k)
    )
  )

sexual_health_hb <-
  chlamydia |>
  left_join(gonorrhoea) |>
  filter(hb19_name != "Scotland") |>
  left_join(hb_lookup) |>
  select(-hb19_name) |>
  relocate(hb19_code)

# chlamydia and gonorrhoea are colinear. Given data is missing for gonorrhoea,
# let's drop this variable and use just chlamydia count.
sexual_health_hb |>
  ggplot(aes(x = chlamydia_rate_100k, y = gonorrhoea_rate_100k)) +
  geom_point(size = 3) +
  theme_minimal()

lives_sexual_health <- sexual_health_hb |>
  select(-gonorrhoea_rate_100k) |>
  left_join(hb_ltla_lookup) |>
  select(ltla24_code = ltla19_code, sexual_health_rate_100k = chlamydia_rate_100k) |>
  arrange(ltla24_code)

usethis::use_data(lives_sexual_health, overwrite = TRUE)

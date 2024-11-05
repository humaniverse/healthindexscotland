library(tidyverse)
library(geographr)
library(osmdata)
library(jsonlite)
library(httr)
library(sf)
library(traveltimeR)

Sys.setenv(TRAVELTIME_ID = "<INSERT YOUR ID HERE>")
Sys.setenv(TRAVELTIME_KEY = "<INSERT YOUR API KEY HERE>")

# ---- Fetch sports centres in Scotland ----
# Bounding box for Scotland
scotland_bb <-
  getbb("Scotland")

# Search for sport centres
sports_centre <-
  opq(scotland_bb, timeout = 1000) |>
  add_osm_feature("leisure", "sports_centre") |>
  osmdata_sf()

# Get Local Authorities in Great Britain for the next step
gb_lad <-
  boundaries_ltla21 |>
  filter(!str_detect(ltla21_code, "^N"))

# Some sport centres are in Northern Ireland - remove them from the dataset
sco_sports <-
  sports_centre$osm_points[gb_lad, ] |>
  select(osm_id) |>
  # Artificially pre-pend some letters so the IDs get interpreted as strings by Travel Time
  mutate(osm_id = paste0("SC", osm_id))

# - Test plot to check sports centre locations -
# gb_lad |>
#   ggplot() +
#   geom_sf(
#     fill = NA,
#     colour = "black"
#   ) +
#   geom_sf(
#     data = sco_sports,
#     inherit.aes = FALSE
#   )

# Local Authorities in Scotland, plus England LADs on the Scottish border
sco_lad <-
  gb_lad |>
  filter(str_detect(ltla21_code, "^S") | ltla21_name %in% c("Northumberland", "Carlisle", "Allerdale"))

# Calculate neighbours for each Scottish Council Area (plus bordering English LADs)
neighbours <- st_touches(sco_lad)

# Test: does Dumfries and Galloway have the correct neighbours?
# sco_lad[neighbours[[5]],]

# Look up the Local Authority each sports centre is in
sco_sports_lad <-
  st_join(sco_sports, sco_lad) |>
  filter(!is.na(ltla21_code)) |>
  mutate(
    # Round coords to 3 decimal points to save memory
    lat = st_coordinates(geometry)[,2] |> round(3),
    lng = st_coordinates(geometry)[,1] |> round(3)
  ) |>
  st_drop_geometry() |>
  as_tibble() |>
  select(
    ltla21_code,
    osm_id,
    lat,
    lng
  )

# ---- Population-weighted centroids for Data Zones ----
# Source: https://spatialdata.gov.scot/geonetwork/srv/api/records/8f370479-5e3d-450b-9064-4a33274f1a52
#
# Original plan was to use Data Zones, but there are quite a lot of them and the
# Travel Time API seems to need us to pass the departure points (i.e. these centroids)
# one at a time. Going to use Intermediate Zones instead to speed this up
# but will keep this block of code here in case useful in future.
#
# GET(
#   "https://maps.gov.scot/ATOM/shapefiles/SG_DataZoneCent_2011.zip",
#   write_disk(tf <- tempfile(fileext = ".zip"))
# )
#
# unzip(tf, exdir = tempdir())
#
# dz11_centroids_raw <- read_sf(file.path(tempdir(), "SG_DataZone_Cent_2011.shp"))
#
# # Convert to lats and longs
# dz11_centroids <-
#   dz11_centroids_raw |>
#   st_transform(crs = 4326) |>
#   mutate(
#     # Round coords to 3 decimal points to save memory
#     lat = st_coordinates(geometry)[,2] |> round(3),
#     lng = st_coordinates(geometry)[,1] |> round(3)
#   ) |>
#   st_drop_geometry() |>
#   select(
#     dz11_code = DataZone,
#     lat,
#     lng
#   )

# ---- Population-weighted centroids for Intermediate Zones ----
# Source: https://spatialdata.gov.scot/geonetwork/srv/api/records/298a25ec-926e-40ca-b74e-60576f8f6dda
GET(
  "https://maps.gov.scot/ATOM/shapefiles/SG_IntermediateZoneCent_2011.zip",
  write_disk(tf <- tempfile(fileext = ".zip"))
)

unzip(tf, exdir = tempdir())

iz11_centroids_raw <- read_sf(file.path(tempdir(), "SG_IntermediateZone_Cent_2011.shp"))

# Convert to lats and longs
iz11_centroids <-
  iz11_centroids_raw |>
  st_transform(crs = 4326) |>
  mutate(
    # Round coords to 3 decimal points to save memory
    lat = st_coordinates(geometry)[,2] |> round(3),
    lng = st_coordinates(geometry)[,1] |> round(3)
  ) |>
  st_drop_geometry() |>
  select(
    iz11_code = InterZone,
    lat,
    lng
  )

# ---- Calculate travel time between data zones and sports centres ----
# Taking each Local Authority in Scotland one at a time,
# calculate the travel distance/time from the Intermediate Zones within that LAD
# to each sports centre in the LAD as well as in neighbouring LADs

# Set up tibbles to store results
sports_centre_travel_time <- tibble()

# Start loop at row 4; the first three rows are the English LADs
# We don't need to calculate travel times within them
for (i in 4:nrow(sco_lad)) {
  current_ltla_code <- sco_lad[i,]$ltla21_code

  current_iz_codes <-
    lookup_dz11_iz11_ltla20 |>
    filter(ltla20_code == current_ltla_code) |>
    distinct(iz11_code) |>
    pull(iz11_code)

  current_iz_centroids <-
    iz11_centroids |>
    filter(iz11_code %in% current_iz_codes)

  # Get sports centres in the current LAD and its neighbouring LADs
  current_neighbours <-
    sco_lad[neighbours[[i]],] |>
    pull(ltla21_code)

  current_sports_centres <-
    sco_sports_lad |>
    filter(ltla21_code %in% c(current_ltla_code, current_neighbours)) |>
    # We'll combine the sports centres with Intermediate Zones - use the same column name for IDs
    rename(id = osm_id)

  # Loop through each Intermediate Zones in the current Local Authority,
  # calculating travel time to the current set of sports centres
  for (iz in 1:nrow(current_iz_centroids)) {
    current_iz_centroid <-
      current_iz_centroids |>
      slice(iz) |>
      rename(id = iz11_code)

    # Need to make a list of locations with the `traveltimeR::make_locations()` function
    # First we must collate the current set of locations into a single dataframe
    current_locations_df <- bind_rows(current_iz_centroid, current_sports_centres)

    # Then use the approach shown in Travel Time's R package readme: https://docs.traveltime.com/api/sdks/r
    current_locations <- apply(current_locations_df, 1, function(x)
      make_location(id = x['id'], coords = list(lat = as.numeric(x["lat"]),
                                                lng = as.numeric(x["lng"]))))
    current_locations <- unlist(current_locations, recursive = FALSE)

    current_search <-
      make_search(
        id = str_glue("search {current_iz_centroid$id}"), # Make up an ID for the search so each search is unique
        departure_location_id = current_iz_centroid$id,
        arrival_location_ids = as.list(current_sports_centres$id),
        travel_time = 10800,  # 3 hours (in seconds)
        properties = list("travel_time"),
        arrival_time_period = "weekday_morning",
        transportation = list(type = "public_transport")
      )

    current_result <- time_filter_fast(locations = current_locations, arrival_one_to_many = current_search)

    # Convert JSON result to a data frame
    current_result_df <- jsonlite::fromJSON(current_result$contentJSON, flatten = TRUE)

    # Some Intermediate Zones can't reach any sports centres - ignore them
    if (length(current_result_df$results$locations[[1]]) > 0) {
      current_travel_time <-
        current_result_df$results$locations[[1]] |>
        as_tibble() |>
        mutate(
          # `travel_time` column is in seconds; convert to minutes
          travel_time_mins = properties.travel_time / 60,
          iz11_code = current_iz_centroid$id
        ) |>
        select(iz11_code, osm_id = id, travel_time_mins)

      sports_centre_travel_time <- bind_rows(sports_centre_travel_time, current_travel_time)
    }

    print(str_glue("Finished IZ {iz} of {nrow(current_iz_centroids)}"))
    Sys.sleep(2)
  }

  # Save progress to disc after each LAD
  # NOTE: Please manually delete these files once the loop completes
  write_csv(sports_centre_travel_time, str_glue("data-raw/healthy-places/sports_centre_travel_time-{i-3}.csv"))

  print(str_glue("Finished Council Area {i - 3} of {nrow(sco_lad) - 3}"))
}

# Save the complete dataset for travel time from Intermediate Zones to sports centres
# This won't be available in the R package itself but want to keep it in the GitHub repo
# since it takes quite a while to calculate
write_csv(sports_centre_travel_time, "data-raw/healthy-places/sports_centre_travel_time.csv")

# sports_centre_travel_time <- read_csv("data-raw/healthy-places/sports_centre_travel_time.csv")

# Look up Local Authorities for each Intermediate Zone and sports centre
lookup_iz_lad <-
  lookup_dz11_iz11_ltla20 |>
  distinct(iz11_code, ltla21_code = ltla20_code, ltla_name = ltla20_name)

sports_centre_travel_time <-
  sports_centre_travel_time |>
  left_join(lookup_iz_lad)

# What are the fastest travel times within each Intermediate Zone?
sports_centre_travel_time_fastest <-
  sports_centre_travel_time |>
  select(-osm_id) |>  # We don't need to know the sports centre ID for this
  group_by(iz11_code) |>
  filter(travel_time_mins == min(travel_time_mins)) |>
  ungroup() |>
  distinct()

# Plot the distribution of fastest travel times within each Local Authority
sports_centre_travel_time_fastest |>
  ggplot(aes(x = travel_time_mins)) +
  geom_histogram(binwidth = 5) +
  facet_wrap(~ltla_name, scales = "free")

# Calculate average travel time for each Local Authority
# Several of the distributions of travel times within Local Authorities are skewed
# so we'll take the median travel time
places_sports_centre_travel_time <-
  sports_centre_travel_time_fastest |>
  group_by(ltla21_code) |>
  summarise(median_travel_time = median(travel_time_mins, na.rm = TRUE)) |>
  ungroup() |>
  mutate(year = year(now())) |>
  rename(ltla24_code = ltla21_code,
         sports_centre_median_travel_time = median_travel_time)

# ---- Save output to data/ folder ----
usethis::use_data(places_sports_centre_travel_time, overwrite = TRUE)

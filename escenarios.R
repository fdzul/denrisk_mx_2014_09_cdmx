# Step 1. load the prediction ####
x <- terra::rast("/Users/fdzul/Dropbox/posdoctorado_INSP/proyectos/risk_mzmv/11.output/pred_class_risk.tif")

# Step 2. load aoi ####
load("~/Dropbox/posdoctorado_INSP/proyectos/risk_mzmv/8.RData/area_of_interes/aoi.RData")

# step 3. load of the alcaldias ####

# Step 3.1. load the pop total ciudad de mexico ####
y <- vroom::vroom("/Users/fdzul/Dropbox/datasets/inegi/scince/Población total Ciudad de México - 09101 por municipio_demarcación territorial.csv")

# Step 3.2. load the minicipalities ####
mun <- rgeomex::AGEM_inegi19_mx |>
    dplyr::filter(CVEGEO %in% c(y$cvegeo))

# Step 4. extract the alcaldias with hight prob ####
mun_high <- mun |>
    dplyr::filter(NOMGEO %in% c("Tlalnepantla de Baz",
                                "Azcapotzalco",
                                "Cuauhtémoc",
                                "Benito Juárez",
                                "Coyoacán",
                                "Venustiano Carranza",
                                "Iztacalco",
                                
                                "Naucalpan de Juárez",
                                "Miguel Hidalgo",
                                "Iztapalapa"))

# mapgl ####

library(mapgl)

mapgl::mapboxgl(style = mapgl::carto_style("positron"),
                center = c(-99.127120, 19.393996),
                zoom = 8) |>
    mapgl::add_image_source(id = "raster-source", 
                            data = x,
                            colors = c("#1f78b4", "#33a02c", 
                                       "#FFFEC6", "#E4744F",
                                       "#e31a1c")) |>
    mapgl::add_raster_layer(id = "raster-layer", 
                            source = "raster-source",
                            raster_opacity = 0.5) |>
    mapgl::add_categorical_legend(legend_title = "Escenarios Epidemiológicos",
                                  values = c("Riesgo Muy Alto", 
                                             "Riesgo Alto",
                                             "Riesgo Medio", 
                                             "Riesgo Bajo", 
                                             "Riesgo Muy Bajo"),
                                  colors = c("#e31a1c", "#E4744F",
                                             "#FFFEC6",
                                             "#33a02c", "#1f78b4"),
                                  circular_patches = FALSE)


# mapview ####

mapview::mapview(x,
                 col.regions = rev(c("#e31a1c", 
                                     "#E4744F",
                                     "#FFFEC6",
                                     "#33a02c",
                                     "#1f78b4")),
                 alpha.regions = 0.3,
                 alpha = 0.1,
                 layer.name = "Escenarios",
                 trim = TRUE,
                 label = FALSE,
                 na.color = NA)

# leaflet ####
pal <- leaflet::colorFactor(palette =  rev(c("#e31a1c", 
                                             "#E4744F",
                                             "#FFFEC6",
                                             "#33a02c",
                                             "#1f78b4")),
                            domain = c("Riesgo Muy Alto", 
                                       "Riesgo Alto",
                                       "Riesgo Medio", 
                                       "Riesgo Bajo", 
                                       "Riesgo Muy Bajo"))

leaflet::leaflet() |>
    leaflet::addProviderTiles("CartoDB.Positron") |>
    leaflet::addRasterImage(x,
                            colors = rev(c("#e31a1c", 
                                           "#E4744F",
                                           "#FFFEC6",
                                           "#33a02c",
                                           "#1f78b4")),
                            opacity = 0.6) 
   

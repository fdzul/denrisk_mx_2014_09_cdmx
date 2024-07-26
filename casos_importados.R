
# Step 1. load the dengue sdm  ####
x <- terra::rast("/Users/fdzul/Dropbox/posdoctorado_INSP/proyectos/risk_mzmv/11.output/pred_dengue.tif")

# Step 2. load the aoi and dataset final ####
load("~/Dropbox/posdoctorado_INSP/proyectos/risk_mzmv/8.RData/results/ml_dengue/ml_dengue_cdmx.RData")
load("~/Dropbox/posdoctorado_INSP/proyectos/risk_mzmv/8.RData/area_of_interes/aoi.RData")


# Step3. extract the alcaldias of cdmx ####
mun <- rgeomex::AGEM_inegi19_mx[mzmv,]

mapview::mapview(x,
                 layer.name = "Probabilidad de Casos Importados",
                 na.color = NA,
                 col.regions = tidyterra::whitebox.colors(palette = "muted", 
                                                          n = 10,
                                                          rev = FALSE)) +
    mapview::mapview(mzmv,
                     layer.name = "Área Metropolitana",
                     alpha.regions = 0.,
                     legend = FALSE) +
    mapview::mapview(mun,
                     layer.name = "Municipios",
                     alpha.regions = 0.01,
                     legend = FALSE) +
    mapview::mapview(den_thin |> 
                         dplyr::filter(class == "presence"),
                     layer.name = "Presencia de Casos Importados",
                     col.regions = "#E01A59",
                     col = "white",
                     legend = FALSE)


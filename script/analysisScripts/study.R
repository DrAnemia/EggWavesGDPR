# Va llamamndo a las distintas funciones y aplicando distintas técnicas sobre los ficheros generados
# Nota: Hay casos en los que las imagenes quedan en blanco. Se pueden ver todas las imagenes si se ejecutan las funciones manualente


# Esto solo funciona en RStudio. Si no, hay que fijar manualmente el wd

#current_folder <- dirname(rstudioapi::getSourceEditorContext()$path)
#setwd(current_folder)
#setwd('../..')

initial_data = "data/initial_data/Aurora_P300_AV3_Raw Data.csv"
reference <- read.csv(initial_data, header = TRUE, sep=',')
reference <- reference[-c(1)]

source("pcaInitialData.R")
pcaInitialData(initial_data)
source("pcaFourier.R")
pcaFourier(initial_data)

score_data = "data/scores/without_rotation/score_Aurora_V1.csv"

source("agnesClustering.R")
agnesClustering(score_data, colnames(reference))
source("kmeansClustering.R")
kmeansClustering(score_data, colnames(reference))

score_rotation_data = "data/scores/with_rotation/score_Aurora_V1.csv"

source("agnesClustering.R")
agnesClustering(score_rotation_data, colnames(reference))
source("kmeansClustering.R")
kmeansClustering(score_rotation_data, colnames(reference))


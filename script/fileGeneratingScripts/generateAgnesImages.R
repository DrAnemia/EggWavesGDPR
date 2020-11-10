
# Utilizando los datos de los scores del segundo y tercer harmonico, obtenidos mediante generateScores, se aplica clusterización jerarquica y se almacenan las imagenes

library(ggplot2)
library(cluster)
library(factoextra)

current_folder <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(current_folder)
setwd('../..')

# Se definen los directorios de los scores rotados y sin rotar

rotation_initial_path <- 'data/scores/with_rotation/'
withoutrotation_initial_path <- 'data/scores/without_rotation/'

rotation_destination_path <- 'images/agnes/with_rotation/'
withoutrotation_destination_path <- 'images/agnes/without_rotation/'

if (file.exists(rotation_destination_path) == FALSE){
  dir.create('images')
  dir.create('images/agnes')
  dir.create(rotation_destination_path)
}
if (file.exists(withoutrotation_destination_path) == FALSE){
  dir.create(withoutrotation_destination_path)
}

reference <- read.csv('data/initial_data/Aurora_P300_AV3_Raw Data.csv', header = TRUE, sep=',')
reference <- reference[-c(1)]

paths <- list(c(rotation_initial_path, rotation_destination_path),
              c(withoutrotation_initial_path, withoutrotation_destination_path))


for(path in paths){
  
  initial_path <- path[1]
  destination_path <- path[2]
  print(initial_path)
  files = list.files(path = initial_path, pattern="*.csv")
  
  for (i in 1:length(files)){
    
    dir <- paste(initial_path, files[i], sep='')
    current_data <- read.csv(dir, header = TRUE, sep=',')
    rownames(current_data) <- colnames(reference)
    
    # Se calcula la distancia euclidea y se aplica agnes
    
    distance <- dist(current_data,method = "euclidean")
    
    hc_CL_Ward <- agnes(current_data, method = "ward")
    gap_stat <- clusGap(current_data, FUN = hcut, nstart = 25, K.max = 15, B = 25)
    hc_sg <- hclust(distance, method = "ward.D2" )
    
    sub_grp <- cutree(hc_sg, k = 2)
    
    name <- gsub("score_","",files[i])
    name <- gsub(".csv","",name)
    new_dir <- paste(destination_path,name,'.jpg',sep='')
    
    # Se guardan las imagenes 
    
    jpeg(new_dir)
    plot <- fviz_cluster(list(data = current_data, cluster = sub_grp), choose.vars = c("Second_PCA", "Third_PCA"), geom=c('point', 'text') )
    print(plot)
    dev.off()
  }
}



# Utilizando los datos de los scores del segundo y tercer harmonico, obtenidos mediante generateScores, se aplica kmeans y se almacenan las imagenes

library(ggplot2)
library(cluster)
library(factoextra)

current_folder <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(current_folder)
setwd('../..')

# Se definen los directorios de los scores rotados y sin rotar

rotation_initial_path <- 'data/scores/with_rotation/'
withoutrotation_initial_path <- 'data/scores/without_rotation/'

rotation_destination_path <- 'images/kmeans/with_rotation/'
withoutrotation_destination_path <- 'images/kmeans/without_rotation/'

reference <- read.csv('data/initial_data/Aurora_P300_AV3_Raw Data.csv', header = TRUE, sep=',')
reference <- reference[-c(1)]

paths <- list(c(rotation_initial_path, rotation_destination_path),
              c(withoutrotation_initial_path, withoutrotation_destination_path))


for(path in paths){
  
  initial_path <- path[1]
  destination_path <- path[2]
  
  files = list.files(path = initial_path, pattern="*.csv")
  
  for (i in 1:length(files)){
    
    dir <- paste(initial_path, files[i], sep='')
    current_data <- read.csv(dir, header = TRUE, sep=',')
    rownames(current_data) <- colnames(reference)
    
    # Se aplica kmeans con 2 centros
    
    cluster.2<-kmeans(current_data,centers=2,nstart=20)
    
    name <- gsub("score_","",files[i])
    name <- gsub(".csv","",name)
    new_dir <- paste(destination_path,name,'.jpg',sep='')
    
    # Se guardan las imagenes 
    
    jpeg(new_dir)
    plot <- fviz_cluster(cluster.2, data=current_data,
                   choose.vars = colnames(current_data))
    print(plot)
    dev.off()
  }
}

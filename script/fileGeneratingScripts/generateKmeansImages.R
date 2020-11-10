
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

if (file.exists(rotation_destination_path) == FALSE){
  dir.create('images')
  dir.create('images/kmeans')
  dir.create(rotation_destination_path)
}
if (file.exists(withoutrotation_destination_path) == FALSE){
  dir.create(withoutrotation_destination_path)
}
if (file.exists('data/scores_cluster') == FALSE){
  dir.create('data/scores_cluster')
  dir.create('data/scores_cluster/with_rotation')
  dir.create('data/scores_cluster/without_rotation')
}

reference <- read.csv('data/initial_data/Aurora_P300_AV3_Raw Data.csv', header = TRUE, sep=',')
reference <- reference[-c(1)]

paths <- list(c(rotation_initial_path, rotation_destination_path),
              c(withoutrotation_initial_path, withoutrotation_destination_path))

z<-0
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
    
    sc_destination_path <- gsub("scores","scores_cluster",initial_path)
    
    
    # Almacenamos los cluster en csv
    
    if(z != 0){
      z <- z+1
      v <- array(c(v,cluster.2$cluster), dim=c(60,z))
    }else{
      z <- 1
      v <- array(c(cluster.2$cluster), dim=c(60,1))
    }
    
    if(ncol(v) == 3){
      z<-0
      rownames(v) <- colnames(reference)
      colnames(v) <- c('V3','V4','V5')
      name <- gsub("_V3","",name)
      new_dir <- paste(sc_destination_path,name,'.csv',sep='')
      matrix.df <- as.data.frame(v)
      write.csv(matrix.df,new_dir)
    }
    
  }
}

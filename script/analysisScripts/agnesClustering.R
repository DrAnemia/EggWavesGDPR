agnesClustering <- function(dataFile, columns){
  
  library(ggplot2)
  library(cluster)
  library(factoextra)
  library(tidyverse)
  
  data <- read.csv(dataFile, header = TRUE, sep=',')
  rownames(data) <- columns
  
  # Visualización de los datos
  ggplot(data, aes(x=Second_PCA, y=Third_PCA)) +
    geom_point() + 
    geom_text(
      label=columns, 
      nudge_x = 0.25, nudge_y = 0.25, 
      check_overlap = T
    )
  
  # Se calcula la distancia euclidea y se visualiza 
  distance <- dist(data,method = "euclidean")
  
  distance_plot <- fviz_dist(distance, gradient = list(low = "#00AFBB", 
                                      mid = "white", high = "#FC4E07"))
  plot(distance_plot)
  
  # Se estudia el mejor método
  m <- c( "average", "single", "complete", "ward")
  names(m) <- c( "average", "single", "complete", "ward")
  
  ac <- function(x) {
    agnes(data, method = x)$ac
  }
  
  # El valor más alto de esta función devuelve cual es el mejor método
  map_dbl(m, ac)
  # Ward es el mejor método, por lo que es el que se usa para clusterizar
  
  # Se aplica agnes y se representa el dendograma
  hc_CL_Ward <- agnes(data, method = "ward")
  pltree(hc_CL_Ward, cex = 0.6, hang = -1, main = "Dendrogram of agnes - Ward")
  
  # Para encontrar el número de clusters adecuado que se deben utilizar es necesario buscar codos en las gráficas
  fviz_nbclust(data, hcut, method = "wss", k.max = 20)
  number_of_clusters <- fviz_nbclust(data, hcut, method = "silhouette")
  plot(number_of_clusters)
  
  # Parece que el número adecuado de clusters es 2
  
  # GAP method
  # Devuelve las estadísticas para cada número de clusters
  gap_stat <- clusGap(data, FUN = hcut, nstart = 25, K.max = 15, B = 25)

  # Devuelve las estadísticas para cada número de clusters
  fviz_gap_stat(gap_stat)
  hc_sg <- hclust(distance, method = "ward.D2" )
  
  # Se aplica el cluster y se muestra el número de casos por cluster
  sub_grp <- cutree(hc_sg, k = 2)
  table <- table(sub_grp)
  print(table)
  
  # Visualización sobre dendograma y gráfico
  
  plot(hc_sg, cex = 0.6)
  rect.hclust(hc_sg, k = 2, border = 2:5)

  fviz_cluster(list(data = data, cluster = sub_grp), choose.vars = c("Second_PCA", "Third_PCA"), geom=c('point', 'text') )
}
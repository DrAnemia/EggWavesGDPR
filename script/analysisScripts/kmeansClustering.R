kmeansClustering <- function(dataFile, columns){
  
  library(factoextra)

  
  data <- read.csv(dataFile, header = TRUE, sep=',')
  rownames(data) <- columns
  
  # Comprobamos el númeor optimo de clusters
  numberClusters <- fviz_nbclust(data, kmeans, method = "silhouette")
  plot(numberClusters)
  
  # Parece que lo mejor es usar 2
  
  cluster<-kmeans(data,centers=2,nstart=20)
  
  # Resultados
  str(cluster)
  cluster
  
  # Visualización
  cluster.1 <- fviz_cluster(cluster, data=data,
               choose.vars = colnames(data))
  plot(cluster.1)
  cluster.2 <- fviz_cluster(cluster, data=data,
               choose.vars = colnames(data),stand = FALSE, 
               ellipse.type = "norm") + theme_bw()
  plot(cluster.2)
  
  # Señales agrupadas por clusters
  datac1 <- cluster$cluster
  datac1
}
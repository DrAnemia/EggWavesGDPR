pcaInitialData <- function(dataFile){
  
  library(ggplot2)
  library(factoextra)
  
  data <- read.csv(dataFile, header = TRUE, sep=',')
  data <- data[-c(1)]
  
  # Se aplica PCA
  res.pca <- prcomp(data, scale = TRUE)
  
  # El número óptimo de componentes parece ser 3
  components <- fviz_eig(res.pca)
  plot(components)
  
  plot <- fviz_pca_var(res.pca,
               col.var = "contrib", 
               gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),
               repel = TRUE    
  )
  plot(plot)
  
  biplot(res.pca)
  
  # Lo mismo, pero mas confuso
  
  #fviz_pca_biplot(res.pca, repel = TRUE,
  #                col.var = "#2E9FDF", 
  #                col.ind = "#696969" 
  #)
  
  eig.val <- get_eigenvalue(res.pca)
  eig.val
  
  # Resultado de las variables
  res.var <- get_pca_var(res.pca)
  res.var$coord          # Coordenadas
  res.var$contrib        # Contribución
  res.var$cos2           # Calidad
  # Resultado por individuo
  res.ind <- get_pca_ind(res.pca)
  res.ind$coord          # Coordenadas
  res.ind$contrib        # Contribución
  res.ind$cos2           # Calidad 
  
}  
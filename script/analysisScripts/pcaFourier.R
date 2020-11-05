pcaFourier <- function(dataFile){
  
  library(ggplot2)
  library(fda)
  
  data <- read.csv(dataFile, header = TRUE, sep=',')
  data <- data[-c(1)]
  
  # Definición de la base de Fourier
  freq <- create.fourier.basis(c(0, 300), nbasis=65, period=300)
  
  harmaccelLfd <- vec2Lfd(c(0,(2*pi/300)^2,0), c(0, 300))
  harmfdPar     <- fdPar(freq, harmaccelLfd, lambda=1e5)
  
  # Preparación de los datos para aplicar Fourier
  matrix <- data.matrix(data)
  fdobj_df <- smooth.basis(1:300, matrix,
                           freq, fdnames=list("ms", "frame", "wave"))$fd
  
  # Se aplica PCA con 3 componentes
  df.pcalist = pca.fd(fdobj_df, 3)
  # Se muestran los valores
  print(df.pcalist$values)
  # Visualización de los harmonicos 
  without_rotation = plot.pca.fd(df.pcalist)
  
  # Se aplica la rotación
  df_rot = varmx.pca.fd(df.pcalist)
  # Visualización de los harmonicos con rotación 
  with_rotation = plot.pca.fd(df_rot)
}
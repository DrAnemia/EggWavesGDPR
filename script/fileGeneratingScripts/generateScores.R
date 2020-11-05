
# Almacena los valores del segundo y tercer harmonico (con y sin rotación) después de aplicar Fourier y PCA

library(ggplot2)
library(fda)
library(abind)

current_folder <- dirname(rstudioapi::getSourceEditorContext()$path)
setwd(current_folder)
setwd('../..')


# Se definen los directorios

initial_path <- 'data/initial_data/'
destination_path_with_rotation <- 'data/scores/with_rotation/'
destination_path_without_rotation <- 'data/scores/without_rotation/'   
sufix <- "_P300_AV3_Raw Data.csv"

files = list.files(path = initial_path, pattern="*.csv")

# Definición de la base de Fourier
freq <- create.fourier.basis(c(0, 300), nbasis=65, period=300)
harmaccelLfd <- vec2Lfd(c(0,(2*pi/300)^2,0), c(0, 300))
harmfdPar     <- fdPar(freq, harmaccelLfd, lambda=1e5)

for (i in 1:length(files)){
  if((i-1)%%3 == 0){
    name <- gsub(sufix,"",files[i])
    
    # Se leen todos los ficheros correspondientes a cada sujeto
    
    dir = paste(initial_path,files[i],sep = '')
    df_av3 <- read.csv(dir, header = TRUE, sep=',')
    df_av3 <- df_av3[-c(1)]
    dir = paste(initial_path,files[i+1],sep = '')
    df_av4 <- read.csv(dir, header = TRUE, sep=',')
    df_av4 <- df_av4[-c(1)]
    dir = paste(initial_path,files[i+2],sep = '')
    df_av5 <- read.csv(dir, header = TRUE, sep=',')
    df_av5 <- df_av5[-c(1)]
    
    # Preparación de los datos para aplicar Fourier
    
    matrix_av3 <- data.matrix(df_av3)
    matrix_av4 <- data.matrix(df_av4)
    matrix_av5 <- data.matrix(df_av5)
    
    fdobj_df_av3 <- smooth.basis(1:300, matrix_av3,
                                 freq, fdnames=list("ms", "frame", "wave"))$fd
    fdobj_df_av4 <- smooth.basis(1:300, matrix_av4,
                                 freq, fdnames=list("ms", "frame", "wave"))$fd
    fdobj_df_av5 <- smooth.basis(1:300, matrix_av5,
                                 freq, fdnames=list("ms", "frame", "wave"))$fd
    # PCA sobre las transformadas
    
    df.pcalist.v3 = pca.fd(fdobj_df_av3, 3)
    df.pcalist.v4 = pca.fd(fdobj_df_av4, 3)
    df.pcalist.v5 = pca.fd(fdobj_df_av5, 3)
    
    # Se guardan todos los datos en un csv
    
    df_versions = list(df.pcalist.v3, df.pcalist.v4, df.pcalist.v5)
    version <- 1
    for(df_v in df_versions){
      
      Second_PCA <- df_v$scores[,2]
      Third_PCA <- df_v$scores[,3]
      
      scores_df <- data.frame(Second_PCA, Third_PCA)
      
      path <- paste(destination_path_without_rotation,'score_',name,'_V',version,'.csv',sep = '')
      version <- version +1
      write.csv(scores_df,path, row.names = FALSE)
    }
    
    # Rotación
    
    df_rot_av3 = varmx.pca.fd(df.pcalist.v3)
    df_rot_av4 = varmx.pca.fd(df.pcalist.v4)
    df_rot_av5 = varmx.pca.fd(df.pcalist.v5)
    
    # Se guardan todos los datos rotados en un csv
    
    df_rot_versions = list(df_rot_av3, df_rot_av4, df_rot_av5)
    version <- 1
    for(df_rot in df_rot_versions){
    
      Second_PCA <- df_rot$scores[,2]
      Third_PCA <- df_rot$scores[,3]
    
      scores_df <- data.frame(Second_PCA, Third_PCA)
    
      path <- paste(destination_path_with_rotation,name,'_V',version,'.csv',sep = '')
      version <- version +1
      write.csv(scores_df,path, row.names = FALSE)
    }
  }
}

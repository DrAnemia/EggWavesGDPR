library(ggplot2)
library(gridExtra)
library(factoextra)

#current_folder <- dirname(rstudioapi::getSourceEditorContext()$path)
#setwd(current_folder)
#setwd('../..')

setwd('C:/Users/Pablo/Desktop/Señales EGG')

# Se definen los directorios de los scores rotados y sin rotar

initial_path <- 'data/initial_data/'
file_destination_path <- 'data/cca/'
image_destination_path <- 'images/cca/'


if (file.exists(file_destination_path) == FALSE){
  dir.create(file_destination_path)
}
if (file.exists(image_destination_path) == FALSE){
  dir.create(image_destination_path)
}


files = list.files(path = initial_path, pattern="*.csv")

secondbaisis <- create.fourier.basis(c(0, 300), nbasis=65, period=300)
harmaccelLfd <- vec2Lfd(c(0,(2*pi/300)^2,0), c(0, 300))
harmfdPar     <- fdPar(secondbaisis, harmaccelLfd, lambda=1e5)

ccafdPar = fdPar(secondbaisis, 2, 5e6)
ncon = 3

for(i in 1:length(files)){
  if(i%%3 == 0){
    # Nos quedamos con el nombre para mas adelante
    name <- gsub('_P300_AV5_Raw Data.csv','',files[i])
    
    # Cargamos los datos
    home <- read.csv(paste(initial_path, files[i-2],sep = ''), header = TRUE, sep=',')
    home <- home[-c(1)]
    field <- read.csv(paste(initial_path, files[i-1],sep = ''), header = TRUE, sep=',')
    field <- field[-c(1)]
    murder <- read.csv(paste(initial_path, files[i],sep=''), header = TRUE, sep=',')
    murder <- murder[-c(1)]
    
    # Sacamos la matriz
    matrixhome <- data.matrix(home)
    matrixfield <- data.matrix(field)
    matrixmurder <- data.matrix(murder)
    
    fdobj_home <- smooth.basis(1:300, matrixhome,
                               secondbaisis, fdnames=list("ms", "frame", "wave"))$fd
    fdobj_field <- smooth.basis(1:300, matrixfield,
                                secondbaisis, fdnames=list("ms", "frame", "wave"))$fd
    fdobj_murder <- smooth.basis(1:300, matrixmurder,
                                 secondbaisis, fdnames=list("ms", "frame", "wave"))$fd
    
    # Se aplica cca por parejas
    
    home_field = cca.fd(fdobj_home, fdobj_field, ncon,
                         ccafdPar, ccafdPar)
    home_murder = cca.fd(fdobj_home, fdobj_murder, ncon,
                     ccafdPar, ccafdPar)
    field_murder = cca.fd(fdobj_field, fdobj_murder, ncon,
                         ccafdPar, ccafdPar)
    
    # Visualización
    for(j in 1:3){
      cca_df <- data.frame(home_field$ccavar1[,j], home_field$ccavar2[,j],
                           home_murder$ccavar1[,j], home_murder$ccavar2[,j],
                           field_murder$ccavar1[,j], field_murder$ccavar2[,j])
      colnames(cca_df) <- c('hfh','hff','hmh','hmm','fmf','fmm')
      
      # Aprovechamos para kmeans
      
      cluster.1 <- kmeans(cca_df[c(1,2)],centers=2,nstart=20)
      cluster.2 <- kmeans(cca_df[c(3,4)],centers=2,nstart=20)
      cluster.3 <- kmeans(cca_df[c(5,6)],centers=2,nstart=20)
      
      cluster.p1 <- fviz_cluster(cluster.1, data=cca_df[c(1,2)],
                           choose.vars = colnames(cca_df[c(1,2)]),
                           main = NULL)
      cluster.p2 <- fviz_cluster(cluster.2, data=cca_df[c(3,4)],
                                 choose.vars = colnames(cca_df[c(3,4)]),
                                 main = NULL)
      cluster.p3 <- fviz_cluster(cluster.3, data=cca_df[c(5,6)],
                                 choose.vars = colnames(cca_df[c(5,6)]),
                                 main = NULL)

      p1 <- ggplot(cca_df, aes(x=hfh, y=hff)) +
        geom_point() + # Show dots
        geom_text(
          label=colnames(home), 
          nudge_x = 0.25, nudge_y = 0.25, 
          check_overlap = T
        )
      p2 <- ggplot(cca_df, aes(x=hmh, y=hmm)) +
        geom_point() + # Show dots
        geom_text(
          label=colnames(home), 
          nudge_x = 0.25, nudge_y = 0.25, 
          check_overlap = T
        )
      p3 <- ggplot(cca_df, aes(x=fmf, y=fmm)) +
        geom_point() + # Show dots
        geom_text(
          label=colnames(home), 
          nudge_x = 0.25, nudge_y = 0.25, 
          check_overlap = T
        )
      
      assign(paste('pcluster',j,'1',sep=''),cluster.p1)
      assign(paste('pcluster',j,'2',sep=''),cluster.p2)
      assign(paste('pcluster',j,'3',sep=''),cluster.p3)
      
      assign(paste('p',j,'1',sep=''),p1)
      assign(paste('p',j,'2',sep=''),p2)
      assign(paste('p',j,'3',sep=''),p3)
      
      write.csv(cca_df,paste(file_destination_path,name,'_',j,'_','component','.csv', sep=''))
    }
    jpeg(paste(image_destination_path,name,'Clustered','.jpg',sep=''))
    image <- grid.arrange(pcluster11,pcluster21,pcluster31,
                          pcluster12,pcluster22,pcluster32,
                          pcluster13,pcluster23,pcluster33,ncol=3)
    print(image)
    dev.off()
    
    jpeg(paste(image_destination_path,name,'.jpg',sep=''))
    image <- grid.arrange(p11,p21,p31,p12,p22,p32,p13,p23,p33,ncol=3)
    print(image)
    dev.off()
  }
}


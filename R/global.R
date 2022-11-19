############################################
## Define computer (for testing purposes) ##
############################################

if (Sys.info()[['nodename']]=="BI2404M") {
  data_folder <- "/Users/argelagr/shiny_embryo/data"
} else  {
  stop("Computer not recognised")
}

###############
## libraries ##
###############

library(R.utils)
library(HDF5Array)
library(data.table)
library(purrr)
library(DT)

# shiny
library(shiny)
library(shinyFiles)
library(shinythemes)
library(ggiraph)

# general viz
library(GGally)
library(cowplot)
library(ggrepel)
library(ggplot2)
require(patchwork)
require(ggpubr) # to do: remove this dependency?

# graph viz
# require(visNetwork)
# library(sna)
library(network)
library(ggraph)
library(igraph)
library(tidygraph)

library(Cairo)
options(shiny.usecairo=T)

###########################################
## Global variables for human data sets  ##
###########################################

human_datasets <- c("Unpublished","Xue2013")

human_stages <- list()
human_stages[["Unpublished"]] <- c("E3", "E4", "E5", "E6", "E7") 
human_stages[["Xue2013"]] <- c("Oocyte", "Zygote", "2C", "4C", "8C", "Morula")

human_celltypes <- list()
human_celltypes[["Unpublished"]] <- c("Prelineage", "Morula", "ICM", "Epiblast", "PrE", "TE_mural", "TE_polar")
human_celltypes[["Xue2013"]] <- c("Oocyte", "Zygote", "2C", "4C", "8C", "Morula")

human_celltype_colours <- list()
human_celltype_colours[["Unpublished"]] <- c(
  "Prelineage" = "#BFBFBF",
  "Morula" = "#B2DFEE",
  "ICM" = "#00B2EE",
  "Epiblast" = "#1C86EE",
  "PrE" = "#EEC900",
  "TE_mural" = "#D15FEE",
  "TE_polar" = "#8A2BE2"
)
human_celltype_colours[["Xue2013"]] <- viridis::viridis(n=length(human_celltypes[["Wang2021"]]))

human_stage_colors <- list()
human_stage_colors[["Unpublished"]] <- viridis::viridis(n=length(human_stages[["Unpublished"]]))
names(human_stage_colors[["Unpublished"]]) <- human_stages[["Unpublished"]]
human_stage_colors[["Xue2013"]] <- viridis::viridis(n=length(human_stages[["Xue2013"]]))
names(human_stage_colors[["Xue2013"]]) <- human_stages[["Xue2013"]]

###########################################
## Global variables for mouse data sets  ##
###########################################

mouse_datasets <- c("Argelaguet2019","Wang2021","PijuanSala2019")

mouse_stages <- list()
mouse_stages[["Argelaguet2019"]] <- c("E3.5", "E4.5", "E5.5", "E6.5", "E7.5", "E8.5")
mouse_stages[["PijuanSala2019"]] <- c("E6.5", "E6.75", "E7.0", "E7.25", "E7.5", "E7.75", "E8.0", "E8.25", "E8.5", "mixed_gastrulation")
mouse_stages[["Wang2021"]] <- c("zygote", "2cell", "early_4cell", "late_4cell", "8cell", "16cell", "ICM", "TE")

mouse_celltypes <- list()
mouse_celltypes[["Argelaguet2019"]] <- c(
  "ICM",
  "Primitive_endoderm",
  "Epiblast",
  "Primitive_Streak",
  "Caudal_epiblast",
  "PGC",
  "Anterior_Primitive_Streak",
  "Notochord",
  "Def._endoderm",
  "Gut",
  "Nascent_mesoderm",
  "Mixed_mesoderm",
  "Intermediate_mesoderm",
  "Caudal_Mesoderm",
  "Paraxial_mesoderm",
  "Somitic_mesoderm",
  "Pharyngeal_mesoderm",
  "Cardiomyocytes",
  "Allantois",
  "ExE_mesoderm",
  "Mesenchyme",
  "Haematoendothelial_progenitors",
  "Endothelium",
  "Blood_progenitors_1",
  "Blood_progenitors_2",
  "Erythroid1",
  "Erythroid2",
  "Erythroid3",
  "NMP",
  "Rostral_neurectoderm",
  "Caudal_neurectoderm",
  "Neural_crest",
  "Forebrain_Midbrain_Hindbrain",
  "Spinal_cord",
  "Surface_ectoderm",
  "Visceral_endoderm",
  "ExE_endoderm",
  "ExE_ectoderm",
  "Parietal_endoderm"
)
mouse_celltypes[["PijuanSala2019"]] <- c(
  "Epiblast",
  "Primitive_Streak",
  "Caudal_epiblast",
  "PGC",
  "Anterior_Primitive_Streak",
  "Notochord",
  "Def._endoderm",
  "Gut",
  "Nascent_mesoderm",
  "Mixed_mesoderm",
  "Intermediate_mesoderm",
  "Caudal_Mesoderm",
  "Paraxial_mesoderm",
  "Somitic_mesoderm",
  "Pharyngeal_mesoderm",
  "Cardiomyocytes",
  "Allantois",
  "ExE_mesoderm",
  "Mesenchyme",
  "Haematoendothelial_progenitors",
  "Endothelium",
  "Blood_progenitors_1",
  "Blood_progenitors_2",
  "Erythroid1",
  "Erythroid2",
  "Erythroid3",
  "NMP",
  "Rostral_neurectoderm",
  "Caudal_neurectoderm",
  "Neural_crest",
  "Forebrain_Midbrain_Hindbrain",
  "Spinal_cord",
  "Surface_ectoderm",
  "Visceral_endoderm",
  "ExE_endoderm",
  "ExE_ectoderm",
  "Parietal_endoderm"
)

mouse_celltypes[["Wang2021"]] <- c(
  "zygote",
  "2cell", 
  "early_4cell", 
  "late_4cell", 
  "8cell", 
  "16cell", 
  "ICM", 
  "TE" 
)

mouse_celltype_colours <- list()
mouse_celltype_colours[["Argelaguet2019"]] = c(
  "ICM" = "#C6E2FF",
  "Primitive_endoderm" = "darkgreen",
  "Epiblast" = "#635547",
  "Primitive_Streak" = "#DABE99",
  "Caudal_epiblast" = "#9e6762",
  "PGC" = "#FACB12",
  "Anterior_Primitive_Streak" = "#c19f70",
  "Notochord" = "#0F4A9C",
  "Def._endoderm" = "#F397C0",
  "Gut" = "#EF5A9D",
  "Nascent_mesoderm" = "#C594BF",
  "Mixed_mesoderm" = "#DFCDE4",
  "Intermediate_mesoderm" = "#139992",
  "Caudal_Mesoderm" = "#3F84AA",
  "Paraxial_mesoderm" = "#8DB5CE",
  "Somitic_mesoderm" = "#005579",
  "Pharyngeal_mesoderm" = "#C9EBFB",
  "Cardiomyocytes" = "#B51D8D",
  "Allantois" = "#532C8A",
  "ExE_mesoderm" = "#8870ad",
  "Mesenchyme" = "#cc7818",
  "Haematoendothelial_progenitors" = "#FBBE92",
  "Endothelium" = "#ff891c",
  "Blood_progenitors_1" = "#f9decf",
  "Blood_progenitors_2" = "#c9a997",
  "Erythroid1" = "#C72228",
  "Erythroid2" = "#f79083",
  "Erythroid3" = "#EF4E22",
  "NMP" = "#8EC792",
  "Rostral_neurectoderm" = "#65A83E",
  "Caudal_neurectoderm" = "#354E23",
  "Neural_crest" = "#C3C388",
  "Forebrain_Midbrain_Hindbrain" = "#647a4f",
  "Spinal_cord" = "#CDE088",
  "Surface_ectoderm" = "#f7f79e",
  "Visceral_endoderm" = "#F6BFCB",
  "ExE_endoderm" = "#7F6874",
  "ExE_ectoderm" = "#989898",
  "Parietal_endoderm" = "#1A1A1A"
)
mouse_celltype_colours[["PijuanSala2019"]] <- c(
  "Epiblast" = "#635547",
  "Primitive_Streak" = "#DABE99",
  "Caudal_epiblast" = "#9e6762",
  "PGC" = "#FACB12",
  "Anterior_Primitive_Streak" = "#c19f70",
  "Notochord" = "#0F4A9C",
  "Def._endoderm" = "#F397C0",
  "Gut" = "#EF5A9D",
  "Nascent_mesoderm" = "#C594BF",
  "Mixed_mesoderm" = "#DFCDE4",
  "Intermediate_mesoderm" = "#139992",
  "Caudal_Mesoderm" = "#3F84AA",
  "Paraxial_mesoderm" = "#8DB5CE",
  "Somitic_mesoderm" = "#005579",
  "Pharyngeal_mesoderm" = "#C9EBFB",
  "Cardiomyocytes" = "#B51D8D",
  "Allantois" = "#532C8A",
  "ExE_mesoderm" = "#8870ad",
  "Mesenchyme" = "#cc7818",
  "Haematoendothelial_progenitors" = "#FBBE92",
  "Endothelium" = "#ff891c",
  "Blood_progenitors_1" = "#f9decf",
  "Blood_progenitors_2" = "#c9a997",
  "Erythroid1" = "#C72228",
  "Erythroid2" = "#f79083",
  "Erythroid3" = "#EF4E22",
  "NMP" = "#8EC792",
  "Rostral_neurectoderm" = "#65A83E",
  "Caudal_neurectoderm" = "#354E23",
  "Neural_crest" = "#C3C388",
  "Forebrain_Midbrain_Hindbrain" = "#647a4f",
  "Spinal_cord" = "#CDE088",
  "Surface_ectoderm" = "#f7f79e",
  "Visceral_endoderm" = "#F6BFCB",
  "ExE_endoderm" = "#7F6874",
  "ExE_ectoderm" = "#989898",
  "Parietal_endoderm" = "#1A1A1A"
)

# mouse_celltype_colours[["Wang2021"]] <- c(
#   "Prelineage" = "#BFBFBF",
#   "Morula" = "#B2DFEE",
#   "ICM" = "#00B2EE",
#   "Epiblast" = "#1C86EE",
#   "PrE" = "#EEC900",
#   "TE_mural" = "#D15FEE",
#   "TE_polar" = "#8A2BE2"
# )
mouse_celltype_colours[["Wang2021"]] <- viridis::viridis(n=length(mouse_celltypes[["Wang2021"]]))
names(mouse_celltype_colours[["Wang2021"]]) <- mouse_celltypes[["Wang2021"]]

# Define stage colours
mouse_stage_colors <- list()
mouse_stage_colors[["Argelaguet2019"]] <- viridis::viridis(n=length(mouse_stages[["Argelaguet2019"]]))
names(mouse_stage_colors[["Argelaguet2019"]]) <- mouse_stages[["Argelaguet2019"]]
mouse_stage_colors[["PijuanSala2019"]] <- viridis::viridis(n=length(mouse_stages[["PijuanSala2019"]]))
names(mouse_stage_colors[["PijuanSala2019"]]) <- mouse_stages[["PijuanSala2019"]]
mouse_stage_colors[["Wang2021"]] <- viridis::viridis(n=length(mouse_stages[["Wang2021"]]))
names(mouse_stage_colors[["Wang2021"]]) <- mouse_stages[["Wang2021"]]

###############
## Functions ##
###############

minmax.normalisation <- function(x) {
  return((x-min(x,na.rm=T)) /(max(x,na.rm=T)-min(x,na.rm=T)))
}

ggplot_theme_NoAxes <- function() {
  theme(
    axis.title = element_blank(),
    axis.line = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank()
  )
}


matrix.please<-function(x) {
  m<-as.matrix(x[,-1])
  rownames(m)<-x[[1]]
  m
}

sort.abs <- function(dt, sort.field) dt[order(-abs(dt[[sort.field]]))]

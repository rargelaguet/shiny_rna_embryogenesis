
#####################
## Define settings ##
#####################

# if (Sys.info()[['nodename']]=="BI2404M") {
#   data_folder <- "/Users/argelagr/shiny_dnmt/data"
# } else if (Sys.info()[['nodename']]=="rargelaguet.local") {
#   data_folder <- "/Users/rargelaguet/shiny_dnmt/data"
# }
data_folder <- file.path(getwd(),"data")

###############################################
## Load global variables for human data sets ##
###############################################

# human_genes <- fread(paste0(data_folder,"/human/rna_expression/genes.txt"), header=F)[[1]]
# human_cells <- fread(paste0(data_folder,"/human/rna_expression/rna_expr_cells.txt"), header=F)[[1]]

human_genes_list <- list()
human_genes_list[["Unpublished"]] <- fread(file.path(data_folder,"human/Unpublished/rna_expression/genes.txt"), header=F)[[1]]
human_genes_list[["Xue2013"]] <- fread(paste0(data_folder,"/human/Xue2013/rna_expression/genes.txt"), header=F)[[1]]
human_genes <- Reduce("intersect",human_genes_list)

human_cells <- list()
human_cells[["Unpublished"]] <- fread(paste0(data_folder,"/human/Unpublished/rna_expression/rna_expr_cells.txt"), header=F)[[1]]
human_cells[["Xue2013"]] <- fread(paste0(data_folder,"/human/Xue2013/rna_expression/rna_expr_cells.txt"), header=F)[[1]]

###############################################
## Load global variables for mouse data sets ##
###############################################

mouse_genes_list <- list()
mouse_genes_list[["Argelaguet2019"]] <- fread(paste0(data_folder,"/mouse/Argelaguet2019/rna_expression/genes.txt"), header=F)[[1]]
mouse_genes_list[["PijuanSala2019"]] <- fread(paste0(data_folder,"/mouse/PijuanSala2019/rna_expression/genes.txt"), header=F)[[1]]
mouse_genes_list[["Wang2021"]] <- fread(paste0(data_folder,"/mouse/Wang2021/rna_expression/genes.txt"), header=F)[[1]]
mouse_genes <- Reduce("intersect",mouse_genes_list)

mouse_cells <- list()
mouse_cells[["Argelaguet2019"]] <- fread(paste0(data_folder,"/mouse/Argelaguet2019/rna_expression/rna_expr_cells.txt"), header=F)[[1]]
mouse_cells[["PijuanSala2019"]] <- fread(paste0(data_folder,"/mouse/PijuanSala2019/rna_expression/rna_expr_cells.txt"), header=F)[[1]]
mouse_cells[["Wang2021"]] <- fread(paste0(data_folder,"/mouse/Wang2021/rna_expression/rna_expr_cells.txt"), header=F)[[1]]

############################################
## Load cell metadata for human data sets ##
############################################

cell_metadata_human <- list()

# Load human scMT-seq data (Unpublished)
cell_metadata_human[["Unpublished"]] <- fread(paste0(data_folder,"/human/Unpublished/cell_metadata.txt.gz")) %>% 
  .[,cell:=id_rna] %>% setnames("lineage","celltype") %>% setkey(cell) %>% .[human_cells[["Unpublished"]]]

# Load scRNA-seq data (Xue2013)
cell_metadata_human[["Xue2013"]] <- fread(paste0(data_folder,"/human/Xue2013/cell_metadata.txt.gz")) %>% 
  setnames("lineage","celltype") %>%
  setkey(cell) %>% .[human_cells[["Xue2013"]]]

############################################
## Load cell metadata for mouse data sets ##
############################################

cell_metadata_mouse <- list()

# Load mouse gastrulation scNMT-seq data (Argelaguet2019)
cell_metadata_mouse[["Argelaguet2019"]] <- fread(paste0(data_folder,"/mouse/Argelaguet2019/cell_metadata.txt.gz")) %>%
  .[,cell:=id_rna] %>% setkey(cell) %>% .[mouse_cells[["Argelaguet2019"]]]

# Load mouse gastrulation scRNA-seq data (PijuanSala2019)
cell_metadata_mouse[["PijuanSala2019"]] <- fread(paste0(data_folder,"/mouse/PijuanSala2019/sample_metadata.txt.gz")) %>%
  .[,cell:=id] %>% setkey(cell) %>% .[mouse_cells[["PijuanSala2019"]]]

# Load mouse preimplantation scNMT-seq data (Wang2021)
cell_metadata_mouse[["Wang2021"]] <- fread(paste0(data_folder,"/mouse/Wang2021/cell_metadata.txt.gz")) %>%
  .[,stage:=celltype] %>% setkey(cell) %>% .[mouse_cells[["Wang2021"]]]

#############################################
## Load RNA expression for human data sets ##
#############################################

rna_expr_human_cells <- list()

# Load human scMT-seq data (Unpublished)
rna_expr_human_cells[["Unpublished"]] <- HDF5Array(file.path(data_folder,"human/Unpublished/rna_expression/rna_expr_cells.hdf5"), name = "rna_expr_logcounts")
colnames(rna_expr_human_cells[["Unpublished"]]) <- human_cells[["Unpublished"]]
rownames(rna_expr_human_cells[["Unpublished"]]) <- human_genes_list[["Unpublished"]]
stopifnot(cell_metadata_human[["Unpublished"]]$cell==colnames(rna_expr_human_cells[["Unpublished"]]))

# Load scRNA-seq data (Xue2013)
rna_expr_human_cells[["Xue2013"]] <- HDF5Array(file.path(data_folder,"human/Xue2013/rna_expression/rna_expr_cells.hdf5"), name = "rna_expr_logcounts")
colnames(rna_expr_human_cells[["Xue2013"]]) <- human_cells[["Xue2013"]]
rownames(rna_expr_human_cells[["Xue2013"]]) <- human_genes_list[["Xue2013"]]
stopifnot(cell_metadata_human[["Xue2013"]]$cell==colnames(rna_expr_human_cells[["Xue2013"]]))

#############################################
## Load RNA expression for mouse data sets ##
#############################################

rna_expr_mouse_cells <- list()

# Load mouse gastrulation scNMT-seq data (Argelaguet2019)
rna_expr_mouse_cells[["Argelaguet2019"]] <- HDF5Array(file.path(data_folder,"mouse/Argelaguet2019/rna_expression/rna_expr_cells.hdf5"), name = "rna_expr_logcounts")
colnames(rna_expr_mouse_cells[["Argelaguet2019"]]) <- mouse_cells[["Argelaguet2019"]]
rownames(rna_expr_mouse_cells[["Argelaguet2019"]]) <- mouse_genes_list[["Argelaguet2019"]]
stopifnot(cell_metadata_mouse[["Argelaguet2019"]]$id_rna==colnames(rna_expr_mouse_cells[["Argelaguet2019"]]))

# Load mouse gastrulation scRNA-seq data (PijuanSala2019)
rna_expr_mouse_cells[["PijuanSala2019"]] <- HDF5Array(file.path(data_folder,"mouse/pijuansala2019/rna_expression/rna_expr_cells.hdf5"), name = "rna_expr_logcounts")
colnames(rna_expr_mouse_cells[["PijuanSala2019"]]) <- mouse_cells[["PijuanSala2019"]]
rownames(rna_expr_mouse_cells[["PijuanSala2019"]]) <- mouse_genes_list[["PijuanSala2019"]]
stopifnot(cell_metadata_mouse[["PijuanSala2019"]]$id_rna==colnames(rna_expr_mouse_cells[["PijuanSala2019"]]))

# Load mouse preimplantation  scNMT-seq data (Wang2021)
rna_expr_mouse_cells[["Wang2021"]] <- HDF5Array(file.path(data_folder,"mouse/Wang2021/rna_expression/rna_expr_cells.hdf5"), name = "rna_expr_logcounts")
colnames(rna_expr_mouse_cells[["Wang2021"]]) <- mouse_cells[["Wang2021"]]
rownames(rna_expr_mouse_cells[["Wang2021"]]) <- mouse_genes_list[["Wang2021"]]
stopifnot(cell_metadata_mouse[["Wang2021"]]$cell==colnames(rna_expr_mouse_cells[["Wang2021"]]))

#########################
## Repetitive elements ##
#########################

# repeats_expr.dt <- fread(file.path(data_folder,"repeats/repeats_expr.txt.gz"))
# repeats_diff_expr.dt <- fread(file.path(data_folder,"repeats/repeats_diff_expr.txt.gz"))

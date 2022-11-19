# for testing
# shiny::loadSupport()

#############################
## Define global variables ##
#############################

# human_genes <- fread(paste0(data_folder,"/human/Unpublished/rna_expression/genes.txt"), header=F)[[1]]
# mouse_genes <- fread(paste0(data_folder,"/mouse/Argelaguet2019/rna_expression/genes.txt"), header=F)[[1]]

##############
## Shiny UI ##
##############

ui <- shinyUI(fluidPage(
  navbarPage(
    title = "Gene expression during early mammalian development",
    theme = shinytheme("spacelab"),

    tabPanel(
      title = "Overview", id = "overview",
      br(),
      includeMarkdown("overview.md")
    ),
    
    # tabPanel(
    #   title = "Dataset stats", id = "stats",
    #   sidebarPanel(width=3,
    #     selectInput(inputId = "stat_to_plot", label = "Statistic to plot", choices = c("Number of cells"="ncells", "Number of embryos"="nembryos", "Number of genes"="ngenes"), selected = "ncells"),
    #   ),
    #   mainPanel(
    #     # girafeOutput("umap", width = "1000px", height = "800px"),
    #     plotOutput("dataset_stats", width = "800px", height = "400px")
    #   )
    # ),
    
    #############################
    ## Gene expression (mouse) ##
    #############################
    
    tabPanel(
      title = "Gene expression (mouse)", id = "gene_expr_mouse",
      sidebarPanel(width=3,
                   selectInput("gene_expr_mouse_dataset", label = "Data set",  choices = list("Wang2021 (preimplantation)"="Wang2021", "Argelaguet2019 (postimplantation)"="Argelaguet2019", "PijuanSala2019 (postimplantation)"="PijuanSala2019"), selected = "Wang2021"),
                   selectizeInput("gene_expr_mouse_gene", label = "Select gene", choices=NULL, selected="T"),
                   selectInput("gene_expr_mouse_x_axis", label = "x-axis", choices = c("Celltype"="celltype", "Stage"="stage"), selected = "Celltype"),
                   conditionalPanel(
                     condition = "gene_expr_mouse_dataset == 'Argelaguet2019'",
                     checkboxInput("gene_expr_mouse_split_by_stage", label = "Split by stage?", value = TRUE)
                   ),
                   uiOutput("gene_expr_mouse_celltypes")
                   
      ),
      mainPanel(
        plotOutput("plot_gene_expr_mouse",  width = "1000px", height = "600px")
      )
    ),
    
    #############################
    ## Gene expression (human) ##
    #############################
    
    tabPanel(
      title = "Gene expression (human)", id = "gene_expr_human",
      sidebarPanel(width=3,
                   selectInput("gene_expr_human_dataset", label = "Data set",  choices = list("Unpublished (post-ZGA)"="Unpublished", "Xue2013 (pre-ZGA)"="Xue2013"), selected = "unpublished"),
                   selectizeInput("gene_expr_human_gene", label = "Select gene", choices=NULL, selected="T"),
                   selectInput("gene_expr_human_x_axis", label = "x-axis", choices = c("Celltype"="celltype", "Stage"="stage"), selected = "Celltype"),
                   # selectInput("split by", "gene_expr_human_split_by", choices = c("Celltype", "Stage"), selected = NULL),
                   uiOutput("gene_expr_human_celltypes")
      ),
      mainPanel(
        plotOutput("plot_gene_expr_human",  width = "900px", height = "500px")
      )
    ),
    

    #########################
    ## Repetitive elements ##
    #########################
    
    # tabPanel(
    #   title = "Repetitive elements", id = "repetitive",
    #   sidebarPanel(width=3,
    #     selectInput("repetitive_elements", "Elements", choices = repeat_classes, selected = c("IAP","LINE_L1","LTR_ERVK"), multiple = TRUE),
    #     selectInput("repetitive_classes", "Classes", choices = classes[classes!="WT"], selected = classes[classes!="WT"], multiple = TRUE),
    #     selectInput("repetitive_celltypes", "Celltypes", choices = celltypes_pseudobulk, selected = celltypes_pseudobulk[1:4], multiple = TRUE)
    #   ),
    #   mainPanel(
    #     HTML("A positive sign indicates that the repeat element is more expressed in the KO"),
    #     girafeOutput("plot_repetitive")
    #   )
    # ),
    
    # tags$style(HTML(".navbar-header { width:100% } .navbar-brand { width: 100%; text-align: left; font-size: 150%; }"))
    tags$style(HTML(".navbar-header { width:100% } .navbar-brand { width: 100%; font-size: 27px }")) # title text
  )
))

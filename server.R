
# for testing
# shiny::loadSupport()
# source("load_data.R")

##################
## Shiny server ##
##################

server <- function(input, output, session) {
  
  ###################
  ## Dataset stats ##
  ###################
  
  # plot_dataset_stats <- reactive({
  #   
  #   ## START TEST ##
  #   # input <- list()
  #   # input$stat_to_plot <- "ncells"
  #   ## END TEST ##
  #   
  #   if (input$stat_to_plot=="ncells") {
  #     to.plot <- cell_metadata.dt %>% .[,.N,by=c("class","dataset")]
  #     lab <- "Number of cells"
  #     plot_type <- "barplot"
  #   } else if (input$stat_to_plot=="nembryos") {
  #     to.plot <- cell_metadata.dt %>% 
  #       .[,.(N=length(unique(sample))), by=c("class","dataset")] %>%
  #       .[,N:=factor(N, levels=1:max(N))]
  #     lab <- "Number of embryos"
  #     plot_type <- "barplot"
  #   } else if (input$stat_to_plot=="ngenes") {
  #     to.plot <- cell_metadata.dt[,c("sample","class","dataset","nFeature_RNA")] %>% 
  #       setnames("nFeature_RNA","value")
  #     lab <- "Number of genes"
  #     plot_type <- "boxplot"
  #   }
  #   
  #   # c("ngenes","mit_percentage")
  #   
  #   if (plot_type=="barplot") {
  #     p <- ggbarplot(to.plot, x="class", y="N", fill="dataset", position=position_dodge(width = 0.75)) +
  #       labs(x="", y=lab) +
  #       scale_fill_brewer(palette="Dark2") +
  #       theme(
  #         legend.position = "top",
  #         legend.title = element_blank(),
  #         axis.text.y = element_text(colour="black",size=rel(0.8)),
  #         axis.text.x = element_text(colour="black",size=rel(1.0)),
  #       )
  #   } else if (plot_type=="boxplot") {
  #     
  #     to.plot.jitter <- to.plot %>% .[sample.int(n=nrow(.), size=nrow(.)/10)]
  #     
  #     p <- ggplot(to.plot, aes_string(x="sample", y="value", fill="class")) +
  #       ggrastr::geom_jitter_rast(aes(color=class), alpha=0.5, width=0.15, size=0.05, data=to.plot.jitter) +
  #       geom_boxplot(outlier.shape=NA, coef=1, alpha=0.9) +
  #       # facet_wrap(~variable, scales="free_y", labeller = as_labeller(facet.labels), nrow=1) +
  #       scale_fill_manual(values=class_colors) +
  #       scale_color_manual(values=class_colors) +
  #       guides(x = guide_axis(angle = 90)) +
  #       labs(x="", y=lab) +
  #       theme_classic() +
  #       theme(
  #         legend.title = element_blank(),
  #         legend.position = "top",
  #         axis.text.y = element_text(colour="black",size=rel(0.9)),
  #         # axis.text.x = element_text(colour="black",size=rel(0.55), angle=20, hjust=1, vjust=1),
  #         axis.text.x = element_text(colour="black",size=rel(0.85)),
  #         axis.title.x = element_blank()
  #       )
  #   }
  #   
  #   return(p)
  #   
  # })
  # 
  # output$dataset_stats = renderPlot({
  #   plot_dataset_stats()
  # })
  
  ###########################
  ## Gene expression human ##
  ###########################
  
  updateSelectizeInput(session = session, inputId = 'gene_expr_human_gene', choices = human_genes, server = TRUE, selected = "DPPA2") 
  
  plot_gene_expr_human <- reactive({
    
    ## START TEST ##
    # input <- list()
    # input$gene_expr_human_dataset <- "Xue2013"
    # input$gene_expr_human_gene <- "DPPA2"
    # input$gene_expr_human_celltypes <- human_celltypes[[input$gene_expr_human_dataset]]
    # input$gene_expr_human_x_axis <- "celltype"
    ## END TEST ##
    
    ## Define color legend
    
    if (input$gene_expr_human_x_axis=="celltype") {
      color_legend <- human_celltype_colours[[input$gene_expr_human_dataset]]
    } else if (input$gene_expr_human_x_axis=="stage") {
      color_legend <- human_stage_colors[[input$gene_expr_human_dataset]]
    }
    
    ## Prepare data
    
    to.plot <- cell_metadata_human[[input$gene_expr_human_dataset]] %>% 
      .[celltype%in%input$gene_expr_human_celltypes] %>%
      .[,celltype:=factor(celltype,levels=input$gene_expr_human_celltypes)]# %>%
      # .[,N:=.N,by="celltype"] %>% .[N>=10]
    to.plot$expr <- as.numeric(rna_expr_human_cells[[input$gene_expr_human_dataset]][input$gene_expr_human_gene,to.plot$cell])
    
    celltype.order <- human_celltypes[[input$gene_expr_human_dataset]][human_celltypes[[input$gene_expr_human_dataset]]%in%unique(to.plot$celltype)]
    stage.order <- human_stages[[input$gene_expr_human_dataset]][human_stages[[input$gene_expr_human_dataset]]%in%unique(to.plot$stage)]
    to.plot[,c("stage","celltype"):=list(factor(stage,levels=stage.order), factor(celltype,levels=celltype.order))]
    
    ## Generate boxplots
    
    p <- ggplot(to.plot, aes_string(x=input$gene_expr_human_x_axis, y="expr", fill=input$gene_expr_human_x_axis)) +
      geom_jitter(size=2.5, width=0.05, alpha=0.5, shape=21, stroke=0.1) +
      geom_violin(scale="width", alpha=0.40) +
      geom_boxplot(width=0.5, outlier.shape=NA, alpha=0.70) +
      stat_summary(fun.data = function(x) { return(c(y = max(to.plot$expr)+0.5, label = length(x)))}, geom = "text", size=4) +
      # scale_fill_manual(values=color_legend) +
      labs(x="",y="RNA expression", title=input$gene_expr_human_gene) +
      # guides(x = guide_axis(angle = 90)) +
      theme_classic() +
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.25)),
        strip.background = element_blank(),
        axis.text.x = element_text(colour="black",size=rel(1.50)),
        axis.text.y = element_text(colour="black",size=rel(1.25)),
        axis.title.y = element_text(colour="black",size=rel(1.25)),
        axis.ticks.x = element_blank(),
        legend.position = "none"
      )
    
    if (length(unique(to.plot[[input$gene_expr_human_x_axis]]))>=12) {
      p <- p + guides(x = guide_axis(angle = 90))
    }
    
    return(p)

  })
  
  output$plot_gene_expr_human = renderPlot({
    shiny::validate(need(input$gene_expr_human_dataset%in%human_datasets,"Please select a valid data set"))
    shiny::validate(need(input$gene_expr_human_gene%in%human_genes,"Please select gene"))
    shiny::validate(need(all(input$gene_expr_human_celltypes%in%human_celltypes[[input$gene_expr_human_dataset]]),"Please select celltype"))
    plot_gene_expr_human()
  })
  
  output$gene_expr_human_celltypes <- renderUI({
    selectInput("gene_expr_human_celltypes", "Celltypes", choices = human_celltypes[[input$gene_expr_human_dataset]], selected = human_celltypes[[input$gene_expr_human_dataset]], multiple = TRUE)
  })
  
  
  ###########################
  ## Gene expression mouse ##
  ###########################
  
  updateSelectizeInput(session = session, inputId = 'gene_expr_mouse_gene', choices = mouse_genes, server = TRUE, selected = "T") 
  
  plot_gene_expr_mouse <- reactive({
    
    ## START TEST ##
    # input <- list()
    # input$gene_expr_mouse_gene <- "Dppa2"
    # input$gene_expr_mouse_x_axis <- "celltype"
    # input$gene_expr_mouse_dataset <- "PijuanSala2019"
    # input$gene_expr_mouse_celltypes <- mouse_celltypes[[input$gene_expr_mouse_dataset]]
    # input$gene_expr_mouse_split_by_stage <- TRUE
    ## END TEST ##
    
    ## Define color legend
    
    if (input$gene_expr_mouse_x_axis=="celltype") {
      color_legend <- mouse_celltype_colours[[input$gene_expr_mouse_dataset]]
    } else if (input$gene_expr_mouse_x_axis=="stage") {
      color_legend <- mouse_stage_colors[[input$gene_expr_mouse_dataset]]
    }
    
    ## Load data
    
    to.plot <- cell_metadata_mouse[[input$gene_expr_mouse_dataset]] %>% 
      .[celltype%in%input$gene_expr_mouse_celltypes] %>%
      .[,celltype:=factor(celltype,levels=input$gene_expr_mouse_celltypes)] %>%
      .[,N:=.N,by="celltype"] %>% .[N>=10]
    to.plot$expr <- as.numeric(rna_expr_mouse_cells[[input$gene_expr_mouse_dataset]][input$gene_expr_mouse_gene,to.plot$cell])
      
    celltype.order <- mouse_celltypes[[input$gene_expr_mouse_dataset]][mouse_celltypes[[input$gene_expr_mouse_dataset]]%in%unique(to.plot$celltype)]
    stage.order <- mouse_stages[[input$gene_expr_mouse_dataset]][mouse_stages[[input$gene_expr_mouse_dataset]]%in%unique(to.plot$stage)]
    to.plot[,c("stage","celltype"):=list(factor(stage,levels=stage.order), factor(celltype,levels=celltype.order))]
    
    if (input$gene_expr_mouse_dataset%in%c("Argelaguet2019") & input$gene_expr_mouse_split_by_stage) {
      to.plot <- to.plot %>% .[,N:=.N,by=c("stage","celltype")] %>% .[N>=10]
    }
    
    ## Generate boxplots
  
    p <- ggplot(to.plot, aes_string(x=input$gene_expr_mouse_x_axis, y="expr", fill=input$gene_expr_mouse_x_axis)) +
      geom_jitter(size=2.5, width=0.05, alpha=0.5, shape=21, stroke=0.1) +
      geom_violin(scale="width", alpha=0.40) +
      geom_boxplot(width=0.5, outlier.shape=NA, alpha=0.70) +
      scale_fill_manual(values=color_legend) +
      labs(x="",y="RNA expression", title=input$gene_expr_mouse_gene) +
      theme_classic() +
      theme(
        plot.title = element_text(hjust=0.5, size=rel(1.25)),
        # axis.text.x = element_text(colour="black",size=rel(1.25)),
        axis.text.y = element_text(colour="black",size=rel(1.25)),
        axis.title.y = element_text(colour="black",size=rel(1.0)),
        axis.ticks.x = element_blank(),
        legend.position = "none"
      )
    
    # if (input$gene_expr_mouse_dataset%in%c("Argelaguet2019","PijuanSala2019") & input$gene_expr_mouse_split_by_stage) {
    #   p <- p + facet_grid(~stage, scales="free_x", space = "free_x") +
    #     theme(strip.background = element_rect(fill = NA, color = "black"), strip.text = element_text(size=rel(1.25)))
    # }
    
    if (length(unique(to.plot[[input$gene_expr_mouse_x_axis]]))>=12) {
      p <- p + guides(x = guide_axis(angle = 90)) + 
        stat_summary(fun.data = function(x) { return(c(y = max(to.plot$expr)+0.5, label = length(x)))}, geom = "text", size=3) +
        theme(axis.text.x = element_text(colour="black",size=rel(1.15)))
    } else {
      p <- p + 
        stat_summary(fun.data = function(x) { return(c(y = max(to.plot$expr)+0.5, label = length(x)))}, geom = "text", size=4) +
        theme(axis.text.x = element_text(colour="black",size=rel(1.25)))
    }
    
    return(p)
  })
  
  output$plot_gene_expr_mouse = renderPlot({
    shiny::validate(need(input$gene_expr_mouse_dataset%in%mouse_datasets,"Please select a valid data set"))
    shiny::validate(need(input$gene_expr_mouse_gene%in%mouse_genes,"Please select gene"))
    shiny::validate(need(all(input$gene_expr_mouse_celltypes%in%mouse_celltypes[[input$gene_expr_mouse_dataset]]),"Please select celltype"))
    plot_gene_expr_mouse()
  })

  output$gene_expr_mouse_celltypes <- renderUI({
    selectInput("gene_expr_mouse_celltypes", "Celltypes", choices = mouse_celltypes[[input$gene_expr_mouse_dataset]], selected = mouse_celltypes[[input$gene_expr_mouse_dataset]], multiple = TRUE)
  })
    
  
}


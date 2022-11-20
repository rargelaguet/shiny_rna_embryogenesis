
### Overview

The aim of this shiny app is to visualise the gene expression dynamics during early embryonic development across different mammalian species. For now I just incorporated mouse and human data sets, but I am open to add other species if someone sends me the data.

<p align="center">
  <img src="www/embryonic_development_diagram.png"/><br>
  <font size="2"> Image modified from <a href="https://journals.biologists.com/dev/article/145/21/dev167833/48530/Single-cell-transcriptome-analysis-of-human">this article</a></font>
</p>

### Mouse Data sets

- [Wang2021](https://www.nature.com/articles/s41467-021-21409-8): ~200 cells profled with scNOMeRe-seq (i.e. Smart-seq2 for the RNA expression) from zygote to blastocyst.

- [Argelaguet2019](https://www.nature.com/articles/s41586-019-1825-8): ~3k cells profiled with scRNA-seq (Smart-seq2) and scNMT-seq during post-implantation and gastrulation (E3.5 to E7.5, with some E8.5 cells too).

- [PijuanSala2019](https://www.nature.com/articles/s41586-019-0933-9): ~100k cells profiled with scRNA-seq (10x chromium V1) during gastrulation and early organogenesis (E6.5 to E8.5). Here we visualise the expression after \textit{in silico} bulk of cells by embryo and cell type.

### Human Data sets

<!-- - [Yan2013](https://www.nature.com/articles/nsmb.2660): scRNA-seq -->
- [Xue2013](https://pubmed.ncbi.nlm.nih.gov/23892778/): 27 cells from Zygote to Morula profiled with scRNA-seq
- [Petropolous2016](https://www.cell.com/fulltext/S0092-8674(16)30280-X): ~4500 cells from 8-cell stage (day 3 post-implantation) to the blastocyst stage (day 7 post-implantation) profiled with scRNA-seq, merged together with an additional ~1000 cells profiled with scMT-seq (unpublished)


### Code availability
Github repository with the code for the shiny app: https://github.com/rargelaguet/shiny_rna_embryogenesis
<!-- ### Data availability -->
<!-- Raw data is available at [GEO: GSE204908](https://www.ncbi.nlm.nih.gov/geo/query/acc.cgi?acc=GSE204908).   -->
<!-- Links to the parsed data objects is available in the github repository above. -->


### Contact

For questions, suggestions and requests you can open a github issue or reach me at ricard.argelaguet@gmail.com.
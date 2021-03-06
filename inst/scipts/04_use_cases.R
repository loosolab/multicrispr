#=======
# Load
#=======
    require(magrittr)
    require(multicrispr)
    require(ggplot2)

    blanken <- function(
        p, 
        axis.text.x        = element_blank(),
        axis.text.y        = element_blank(),
        axis.ticks.x       = element_blank(),
        axis.ticks.y       = element_blank(),
        panel.grid.major.x = element_line(size=.5),
        panel.grid.minor.x = element_line(size=.5)
        
    ){
        p + 
        theme(  strip.background   = element_blank(), 
                strip.text.x       = element_blank(), 
                axis.text.x        = axis.text.x,
                axis.text.y        = axis.text.y,
                axis.ticks.x       = axis.ticks.x,
                axis.ticks.y       = axis.ticks.y,
                panel.grid.major.y = element_blank(), 
                panel.grid.minor.y = element_blank(), 
                panel.grid.major.x = panel.grid.major.x, 
                panel.grid.minor.x = panel.grid.minor.x, 
                plot.background    = element_rect(fill = 'transparent', colour=NA)) + 
        guides(color = FALSE, size = FALSE, linetype = FALSE, alpha = FALSE)
    }
    reticulate::use_condaenv('azienv')
    
#=============
# TFBS
#=============
    bsgenome <- BSgenome.Mmusculus.UCSC.mm10::BSgenome.Mmusculus.UCSC.mm10
    index_genome(bsgenome)
    bedfile  <- system.file('extdata/SRF.bed', package='multicrispr')
    targets  <- multicrispr::bed_to_granges(bedfile, genome='mm10', plot = FALSE)
    extended <- extend(targets, -22, +22)
    spacers  <- find_spacers(
        extended, bsgenome, ontargetmethod = 'Doench2016', subtract_targets = TRUE)
    
    # Select target to showcase
    # Find a target that allows to showcase subtract_targets = TRUE
    # In the (200 NT wide) TFBS flanks, many examples like these can be found
    # In the (22 NT wide)  TFBS extensions, there are not so much examples like these
    # Still, we prefer the TFBS extensions because computations are faster and it is easier to explain why we targeting the extensions
    # In the extensions, we find two targets with mutual (exact) cross-matches
    # This is due to exact sequence duplication among those two targets
    spacers %>% subset(off == 0 & (T0>1 | T1>1 | T2>1))   %>% 
                gr2dt() %>%
                extract(,.SD[.N>2] ,by = 'targetname') %>% 
                dt2gr(seqinfo(spacers))
    c("chr13:119991554-119991569:+", "chr13:120070959-120070974:-") %>% 
    GRanges(, seqinfo = seqinfo(bsgenome)) %>% 
    extend(-22,+22) %>% 
    BSgenome::getSeq(bsgenome, .)
    
    # Fine then, let's focus on these targets
    selection <- 'chr13:119991554-119991569:+' # 'chr1:63177095-63177110:+'
    spacers  %<>% extract(.$targetname == selection)
    extended %<>% extract(.$targetname == selection)
    targets  %<>% extract(.$targetname == selection)
    BSgenome::vmatchPattern(Biostrings::DNAString("GTGAGAAGGTCGCCTTTATT"), bsgenome)
    rev(spacers)
    
    
    # Plot
    color_blue <- function(p) p + scale_color_manual(values = c(`chr13:119991554-119991569:+` = "#00BFC4"))
    plot_intervals(targets, color_var = 'targetname') %>% color_blue() %>% blanken()
    ggsave('../graphs/srf01.pdf',   width =1.3, height = 0.5, device = grDevices::cairo_pdf)
    
    plot_intervals(extended) %>% color_blue() %>% blanken()
    ggsave('../graphs/srf02_extended.pdf', width = 1.3, height = 0.9, device = grDevices::cairo_pdf,   bg = 'transparent')
    
    plot_intervals(spacers, alpha_var = NULL, size_var = NULL)  %>% color_blue() %>% blanken()
    ggsave('../graphs/srf03_spacers.pdf', width = 2, height = 1.4, device = grDevices::cairo_pdf,    bg = 'transparent')
    
    plot_intervals(spacers, size_var = NULL) %>% color_blue() %>% blanken()
    ggsave('../graphs/srf04_offtargets.pdf', width = 2, height = 1.4, device = grDevices::cairo_pdf, bg = 'transparent')
    
    plot_intervals(spacers) %>% color_blue() %>% blanken()
    ggsave('../graphs/srf05_ontargets.pdf', width = 2, height = 1.4, device = grDevices::cairo_pdf,  bg = 'transparent')
    
    rev(spacers)

# PE
#=====
    bsgenome <- BSgenome.Hsapiens.UCSC.hg38::BSgenome.Hsapiens.UCSC.hg38  
    gr <- char_to_granges(c(PRNP='chr20:4699600:+'), bsgenome)
    
    extended <- extend_for_pe(gr)
    plot_intervals(extended) %>% blanken()
    ggsave('../graphs/prnp02_extended.pdf', width=1.3, height=0.6, device = grDevices::cairo_pdf, bg = 'transparent')
    
    spacers <- find_primespacers(gr, bsgenome, ontargetmethod = 'Doench2016')
    rev(spacers)[c(1,3)]
    #(plot_intervals(spacers, alpha_var = 'type', size_var = NULL) + 
    #scale_alpha_manual(values = c(`spacer` = 1, `3 extension` = 1, `nicking spacer` = 0))) %>% blanken()
    #ggplot2::ggsave('../graphs/prnp03_primespacers.pdf', width=1.3, height=0.9, device = grDevices::cairo_pdf, bg = 'transparent')
    
    plot_intervals(spacers, alpha_var = NULL, size_var = NULL) %>% blanken()
    ggplot2::ggsave('../graphs/prnp03_spacers.pdf',  width=1.3, height=0.9, device = grDevices::cairo_pdf, bg = 'transparent')
    
    plot_intervals(spacers, size_var = NULL) %>% blanken()
    ggplot2::ggsave('../graphs/prnp04_offtargets.pdf', width=1.3, height=0.9, device = grDevices::cairo_pdf, bg = 'transparent')
    
    plot_intervals(spacers, alpha_var = NULL) %>% blanken()
    ggplot2::ggsave('../graphs/prnp05_ontargets.pdf', width=1.3, height=0.9, device = grDevices::cairo_pdf, bg = 'transparent')
    
    
    

% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/05_manipulate_ranges.R
\name{up_flank}
\alias{up_flank}
\alias{down_flank}
\alias{extend}
\title{Extend or Flank GRanges}
\usage{
up_flank(
  gr,
  start = -200,
  end = -1,
  strandaware = TRUE,
  bsgenome = NULL,
  verbose = FALSE,
  plot = FALSE,
  linetype_var = "set",
  ...
)

down_flank(
  gr,
  start = 1,
  end = 200,
  strandaware = TRUE,
  bsgenome = NULL,
  verbose = FALSE,
  plot = FALSE,
  linetype_var = "set",
  ...
)

extend(
  gr,
  start = -22,
  end = 22,
  strandaware = TRUE,
  bsgenome = NULL,
  verbose = FALSE,
  plot = FALSE,
  linetype_var = "set",
  ...
)
}
\arguments{
\item{gr}{\code{\link[GenomicRanges]{GRanges-class}}}

\item{start}{number or vector (same length as gr): start definition, 
relative to gr start (up_flank, extend) or gr end (down_flank).}

\item{end}{number or vector (same length as gr): end definition,
relative to gr start (up_flank) or gr end (extend, down_flank).}

\item{strandaware}{TRUE (default) or FALSE: consider strand information?}

\item{bsgenome}{NULL (default) or \code{\link[BSgenome]{BSgenome-class}}.
Required to update gr$seq if present.}

\item{verbose}{TRUE or FALSE (default)}

\item{plot}{TRUE or FALSE (default)}

\item{linetype_var}{string: gr var mapped to linetype}

\item{...}{passed to \code{\link{plot_intervals}}}
}
\value{
a \code{\link[GenomicRanges]{GRanges-class}}
}
\description{
Returns extensions, upstream flanks, or downstream flanks
}
\details{
\code{up_flank}   returns upstream flanks, in relation to start(gr).
\code{down_flank} returns downstream flanks, in relation to end(gr).
\code{extend}     returns extensions, in relation to start(gr) and end(gr)
}
\examples{
# PE example
#-----------
require(magrittr)
bsgenome <- BSgenome.Hsapiens.UCSC.hg38::BSgenome.Hsapiens.UCSC.hg38  
gr <- char_to_granges(c(PRNP  = 'chr20:4699600:+',         # snp
                         HBB  = 'chr11:5227002:-',            # snp
                         HEXA = 'chr15:72346580-72346583:-',  # del
                         CFTR = 'chr7:117559593-117559595:+'),# ins
                      bsgenome = bsgenome)
gr \%>\% up_flank( -22,  -1, plot=TRUE)
gr \%>\% up_flank( c(-10,-20,-30,-40),  -1, plot=TRUE)
gr \%>\% up_flank( -22,  -1, plot=TRUE, strandaware=FALSE)

gr \%>\% down_flank(+1, +22, plot=TRUE)
gr \%>\% down_flank(+1, c(10, 20, 30, 40), plot=TRUE)
gr \%>\% down_flank(+1, +22, plot=TRUE, strandaware=FALSE)

gr \%>\% extend(   -10, +20, plot=TRUE)
gr \%>\% extend(   -10, +20, plot=TRUE, strandaware=FALSE)

# TFBS example
#-------------
    bedfile <- system.file('extdata/SRF.bed', package='multicrispr')
    gr <- bed_to_granges(bedfile, genome = 'mm10')
    gr \%>\% extend(plot = TRUE)
    gr \%>\% up_flank(plot = TRUE)
    gr \%>\% down_flank(plot = TRUE)
}

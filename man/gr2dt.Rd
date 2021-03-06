% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/02_utilities.R
\name{gr2dt}
\alias{gr2dt}
\alias{dt2gr}
\title{GRanges <-> data.table}
\usage{
gr2dt(gr)

dt2gr(dt, seqinfo)
}
\arguments{
\item{gr}{\code{\link[GenomicRanges]{GRanges-class}}}

\item{dt}{data.table}

\item{seqinfo}{\code{\link[GenomeInfoDb]{Seqinfo-class}}}
}
\value{
data.table (gr2dt) or GRanges (dt2gr)
}
\description{
GRanges <-> data.table
}
\examples{
bsgenome <- BSgenome.Hsapiens.UCSC.hg38::BSgenome.Hsapiens.UCSC.hg38
gr <- char_to_granges(c(PRNP = 'chr20:4699600:+',             # snp
                            HBB  = 'chr11:5227002:-',             # snp
                            HEXA = 'chr15:72346580-72346583:-',   # del
                            CFTR = 'chr7:117559593-117559595:+'), # ins
                          bsgenome)
(dt <- gr2dt(gr))
(gr <- dt2gr(dt, BSgenome::seqinfo(bsgenome)))
}

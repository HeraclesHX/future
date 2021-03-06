library("future")
library("graphics")

plotWhatIsDone <- function(counts) {
  for (kk in seq_along(counts)) {
    f <- counts[[kk]]

    ## Already plotted?
    if (!inherits(f, "Future")) next

    ## Not resolved?
    if (!resolved(f)) next
    
    cat(sprintf("Plotting tile #%d of %d ...\n", kk, n))
    counts[[kk]] <- value(counts[[kk]])
    screen(kk)
    plot(counts[[kk]])
  } # for (kk ...)

  counts
} # plotWhatIsDone()


## Options
region <- getOption("future.demo.mandelbrot.region", 1L)
if (!is.list(region)) {
  if (region == 1L) {
    region <- list(xmid=-0.75, ymid=0.0, side=3.0)
  } else if (region == 2L) {
    region <- list(xmid=0.283, ymid=-0.0095, side=0.00026)
  } else if (region == 3L) {
    region <- list(xmid=0.282989, ymid=-0.01, side=3e-8)
  }
}
nrow <- getOption("future.demo.mandelbrot.nrow", 3L)
delay <- getOption("future.demo.mandelbrot.delay", interactive())
if (isTRUE(delay)) {
  delay <- function(counts) Sys.sleep(rexp(1, rate=2))
} else if (!is.function(delay)) {
  delay <- function(counts) {}
}

## Generate Mandelbrot tiles to be computed
Cs <- mandelbrotTiles(xmid=region$xmid, ymid=region$ymid,
                      side=region$side, nrow=nrow)

if (interactive()) {
  dev.new()
  plot.new()
  split.screen(dim(Cs))
  for (ii in seq_along(Cs)) {
    screen(ii)
    par(mar=c(0,0,0,0))
    text(x=1/2, y=1/2, sprintf("Future #%d\nunresolved", ii), cex=2)
  }
} else {
  split.screen(dim(Cs))
}


counts <- list()
n <- length(Cs)
for (ii in seq_len(n)) {
  cat(sprintf("Mandelbrot tile #%d of %d ...\n", ii, n))
  C <- Cs[[ii]]
  
  counts[[ii]] <- future({
    cat(sprintf("Calculating tile #%d of %d ...\n", ii, n))
    fit <- mandelbrot(C)
    
    ## Emulate slowness
    delay(fit)
    
    cat(sprintf("Calculating tile #%d of %d ... done\n", ii, n))
    fit
  })

  ## Plot tiles that are already resolved
  counts <- plotWhatIsDone(counts)
}


## Plot remaining tiles
repeat {
  counts <- plotWhatIsDone(counts)
  if (!any(sapply(counts, FUN=inherits, "Future"))) break
}
  


close.screen()


message("SUGGESTION: Try to rerun this demo after changing strategy for how futures are resolved, e.g. plan(multiprocess).\n")

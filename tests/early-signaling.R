source("incl/start.R")

options(future.debug=FALSE)

message("*** Early signaling of conditions ...")

message("*** Early signaling of conditions with eager futures ...")

plan(eager)
f <- future({ stop("bang!") })
r <- resolved(f)
stopifnot(r)
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

plan(eager, earlySignal=TRUE)
f <- try(future({ stop("bang!") }), silent=TRUE)
stopifnot(inherits(f, "try-error"))

message("*** Early signaling of conditions with eager futures ... DONE")


message("*** Early signaling of conditions with lazy futures ...")

plan(lazy)
f <- future({ stop("bang!") })
r <- resolved(f)
stopifnot(r)
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

plan(lazy, earlySignal=TRUE)

## Errors
f <- future({ stop("bang!") })
r <- try(resolved(f), silent=TRUE)
stopifnot(inherits(r, "try-error"))
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

## Warnings
f <- future({ warning("careful!") })
res <- tryCatch({
  r <- resolved(f)
}, condition = function(w) w)
stopifnot(inherits(res, "warning"))

## Messages
f <- future({ message("hey!") })
res <- tryCatch({
  r <- resolved(f)
}, condition = function(w) w)
stopifnot(inherits(res, "message"))

## Condition
f <- future({ signalCondition(simpleCondition("hmm")) })
res <- tryCatch({
  r <- resolved(f)
}, condition = function(w) w)
stopifnot(inherits(res, "condition"))

message("*** Early signaling of conditions with lazy futures ... DONE")

message("Number of available cores: ", availableCores())

message("*** Early signaling of conditions with multisession futures ...")

plan(multisession)
f <- future({ stop("bang!") })
r <- resolved(f)
stopifnot(r)
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

plan(multisession, earlySignal=TRUE)
f <- future({ stop("bang!") })
print(f)
r <- try(resolved(f), silent=TRUE)
stopifnot(inherits(r, "try-error") || inherits(f, "UniprocessFuture"))
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))


message("*** Early signaling of conditions with multisession futures ... DONE")


message("*** Early signaling of conditions with multiprocess futures ...")

plan(multiprocess)
f <- future({ stop("bang!") })
r <- resolved(f)
stopifnot(r)
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

plan(multiprocess, earlySignal=TRUE)
f <- future({ stop("bang!") })
print(f)
r <- try(resolved(f), silent=TRUE)
stopifnot(inherits(r, "try-error") || inherits(f, "UniprocessFuture"))
v <- try(value(f), silent=TRUE)
stopifnot(inherits(v, "try-error"))

message("*** Early signaling of conditions with multiprocess futures ... DONE")

message("*** Early signaling of conditions ... DONE")

source("incl/end.R")

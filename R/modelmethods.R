pifun <- function(x){UseMethod("pifun",x)}
pifun.Model <- function(x){return(x$pifun)}
  
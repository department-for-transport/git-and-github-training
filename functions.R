##Function to find file with a specific word in the title
find_file <- function(name){
  file <- list.files("G:/AFP/IHACAll/IHAC/015 DDU/005 Covid reporting/0001 R Projects/transport_modes_table/Data", recursive = TRUE, full.names = TRUE)
  file <- file[!grepl("~$", file, fixed = TRUE)]
  file <- file[grepl("xlsx", file, fixed = TRUE)]
  file <- file[grepl(name, file, ignore.case = TRUE)]
  file
}

##Function to round 0.5 up (instead of sometimes down)
round2 = function(x, n) {
  posneg = sign(x)
  z = abs(x)*10^n
  z = z + 0.5 + sqrt(.Machine$double.eps)
  z = trunc(z)
  z = z/10^n
  z*posneg
}


##%ni%
"%ni%" <- Negate("%in%")

#Calculate linear regression function

lm_eqn <- function(df, x, y){
  m <- lm(y ~ x, df);
  eq <- substitute(italic(y) == a + b %.% italic(x)*","~~italic(r)^2~"="~r2, 
                   list(a = format(unname(coef(m)[1]), digits = 2),
                        b = format(unname(coef(m)[2]), digits = 2),
                        r2 = format(summary(m)$r.squared, digits = 3)))
  as.character(as.expression(eq));
}


##Function to write data while replacing NA values with ".."
write.replace.data <- function(wb,
                               sheet,
                               x,
                               colNames = T,
                               startCol = 1,
                               startRow = 1,
                               rep.NA = '..',
                               ...){
  openxlsx::writeData(wb, 
                      sheet, 
                      x, 
                      startCol, 
                      startRow,
                      colNames = colNames,
                      ...)
  
  row_values <- 1:nrow(x)
  
  if (!is.null(rep.NA)) {
    for(c in 1:ncol(x)-1){
      for (r in row_values[is.na(x[,c])]){
        openxlsx::writeData(wb,
                            sheet,
                            rep.NA,
                            startRow = startRow + r - 1,
                            startCol = startCol + c - 1,
                            colNames = FALSE)}
    }
  }
  
}
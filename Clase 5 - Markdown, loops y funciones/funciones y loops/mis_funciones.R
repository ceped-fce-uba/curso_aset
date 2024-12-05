saludo <- function(nombre) {
  print(paste0("Hola,",nombre," que te trae por acá?"))
  
}
suma <- function(valor1, valor2) {
  valor1+valor2
}

deflactar_series <- function(base, variable,deflactor) {

}

seleccionar_ch <- function(base) {
  
  ch_columns_base <- base[, grep("^CH", colnames(base))]
  
  return(ch_columns_base)
  
}
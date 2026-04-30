saludo <- function(nombre) {
  print(paste0("Hola,",nombre," que te trae por acá?"))
  
}
suma <- function(valor1, valor2) {
  valor1+valor2
}

deflacta_series <- function(df,valor_nominal,indice_precios,col_periodo,base_elegida){
  
  indice_base <- df[indice_precios]/df[indice_precios][df[col_periodo] == base_elegida]*100 
  
  valor_real <- df[valor_nominal]/indice_base*100
  
  df["valor_real"]  <- valor_real
  return(df)  
} 

seleccionar_ch <- function(base) {
  
  ch_columns_base <- base[, grep("^CH", colnames(base))]
  
  return(ch_columns_base)
  
}
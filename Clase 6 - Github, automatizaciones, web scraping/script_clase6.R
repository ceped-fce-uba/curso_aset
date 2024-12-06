# Creación de funciones

suma <- function(valor1, valor3) {
  valor1+valor3
}

suma

suma(valor1 = 5,valor3 = 6)

saludo <- function(nombre) {
  print(paste0("Hola, ",nombre,". ¿Qué te trae por acá?"))
  
}

saludo("Facu")

saludo(nombre = "Juan")

saludo()

calcula_ratio <- function(vector) {
  
  vector.max  <-   max(vector)
  vector.min  <-   min(vector)
  
  return(vector.max/vector.min)
}

ratio <- calcula_ratio(vector = c(1,2,3,4))

ratio

ratio2 <- calcula_ratio(vector = c(1,2,3,4,"H"))

calcula_ratio(vector = c(1,2,3,4,"H"))

calcula_ratio <- function(vector) {
  
  assertthat::assert_that(is.numeric(vector),
                          msg = "Ingresá un vector numérico!")
  
  
  vector.max  <-   max(vector)
  vector.min  <-   min(vector)
  
  
  return(vector.max/vector.min)
}

calcula_ratio(vector = c(1,2,3,4,"H"))

calcula_ratio(vector = c(1,2,3,4,0))

calcula_ratio <- function(vector) {
  
  assertthat::assert_that(is.numeric(vector),
                          msg = "Ingresa un vector numérico")
  
  if(any(vector==0)){
    
    warning("Mensaje: Hay un cero en tu vector, no lo tomo en cuenta para el calculo")
    vector <- vector[vector!=0]
    
  }
  vector.max  <-   max(vector)
  vector.min  <-   min(vector)
  
  
  return(vector.max/vector.min)
}


calcula_ratio(vector = c(1,2,3,4,0))


# Deflactador de series

deflacta_series <- function(df,valor_nominal,indice_precios,col_periodo,base_elegida){
  
  indice_base <- df[indice_precios]/df[indice_precios][df[col_periodo] == base_elegida]*100 
  
  valor_real <- df[valor_nominal]/indice_base*100
  
  df["valor_real"]  <- valor_real
  return(df)  
} 

deflacta_series(df = base_salarios,
                valor_nominal = "salario_promedio",
                col_periodo = "anio_trim",
                indice_precios = "ipc",
                base_elegida = "2023T4")

# Iteraciones y loops

for(i in 1:10){
  print(i^2)
  
}

for(Valores in 1:10){
  
  print(Valores^2)
  
}

base_con_cno <- bases_2021_2023 %>% 
  filter(anio_trim == "2023T4") %>% 
  eph::organize_cno() 


vector = c(1, 3, 4, "Ultimo elemento del vector")

for(j in vector) {
  
  print(paste0("Estoy operando sobre el valor ", j))
  
}


#### Clase 6

text <- "Mi número es 4584-4579 y el de mi amigo es 1234-5678."
pattern <- "\\d{4}-\\d{4}"
telefonos <- regmatches(text, gregexpr(pattern, text))
print(telefonos)



textos <- c("R es genial", "Regex es poderosa", "R puede ser difícil al principio")
grep("p", textos)



montos <- c("$1.345.213,53", "$500,00", "$23.450,50", "$0,99", "$1.000,01", "$12.345.678,90", "$999.999,99", "$3,00")

# Función para limpiar y convertir los montos a numérico
convertir_a_numerico <- function(x) {
  # Eliminar el símbolo $
  x <- gsub("\\$", "", x)
  # Reemplazar puntos por nada (para los miles)
  x <- gsub("\\.", "", x)
  # Reemplazar la coma por un punto para los decimales
  x <- gsub(",", ".", x)
  # Convertir a numérico
  as.numeric(x)
}

# Aplicar la función al vector de montos
montos_limpios <- convertir_a_numerico(montos)

# Ver el resultado
montos_limpios

# Ejemplo con EPH

individual_t117 <- read.table(file = 'bases/usu_individual_t117.txt',
                              sep=";", 
                              dec=",", 
                              header = TRUE, 
                              fill = TRUE)

colnames(individual_t117)

ch_columns117 <- individual_t117[, grep("^CH", colnames(individual_t117))]
ch_columns217 <- individual_t217[, grep("^CH", colnames(individual_t217))]
ch_columns317 <- individual_t317[, grep("^CH", colnames(individual_t317))]

ch_columns

ch_columns <- individual_t117[, grep("^CH", colnames(individual_t117))]




ch_columns_t117 = seleccionar_ch(individual_t117)

source("mis_funciones.R")









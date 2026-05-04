
print('Hola mundo')
A = 1
A
A <- 2 # Operador de asignación 
A
B = 2 + 4
B

numero_grande = 10 + 100
numero_grande

numero_mas_grande = numero_grande + B

tasa_de_desocupacion <- 0.10

resultado = 1000/10000000

otro_numero = 10 * 10

elemento11 = 5 + 6

# Booleano: un objecto que toma True o False

A <- 10
B <- 20

booleando_comparacion = A > B

C <- 20

C <= B

A >= B

C == B

C != B

#Redefinimos los valores A y B
A <- 50
B <- 72

#Realizamos comparaciones lógicas

(A > 60 & B > 65)   # Estoy haciendo una comparación
(A < 60 | B < 65) 

(A > 60 & B > 65) & (A < 60 | B < 65) 

Otro_numero

vector <- c(1, 3, 4, "0343", 21, 45, 987)

vector[1]

vector[4]

categorias <- c("Desocupado", "Ocupado", "Inactivo")  #Estos son valores string, es decir, texto

class(A)

class(categorias)

vector_numerico <- c(1, 3, 4, 21, 45, 987)

class(vector_numerico)

dias_char <- c("Lunes","Viernes","Viernes","Jueves",
       "Martes", "Martes","Miercoles","Martes",
       "Miercoles")

class(dias_char)

table(dias_char)

funcion(argumento1, argumento2, ...)



dias_factor <- factor(dias_char,
                  levels = c("Lunes",
                            "Martes",
                            "Miercoles",
                            "Jueves",
                            "Viernes"))

dias_factor <- factor(dias_char, levels = c("Lunes", "Martes", "Miercoles","Jueves","Viernes"))

class(dias_factor)

table(dias_factor)


vector_prueba <- c(1,3,4)

vector_prueba_suma <- vector_prueba + 10

1:70

prueba_intervalo <- 1:30

vector_prueba_suma
vector_prueba_suma[2]
vector_prueba_suma[1:4]

#Missing values
NA
NaN

# Dataframes

AGLOMERADO  <- c(32,33,33,33,32)
SEXO  <-  c("Varon","Mujer","Mujer","Varon","Mujer")
EDAD  <-  c(60,54,18,27,32)

datos <- data.frame(AGLOMERADO, SEXO, EDAD)

print(datos)

class(datos)

datos[1, 1] # Primera fila, primera columna
datos[1, 1:2] # Primera fila, primera y segunda columna

datos[1:3, 1] # Primera a tercera fila, primera columna

datos$AGLOMERADO

datos$ESTADO <- "Ocupado"

datos$ESTADO

datos[1,]

datos_filtrados_aglo_32 <- datos[datos$AGLOMERADO == 32, ]

datos_filtrados_aglo_32_y_varon <- datos[datos$AGLOMERADO == 32 & datos$SEXO == "Varon",1:2 ]

lista <- list(A,B,C,D,E,datos$AGLOMERADO, DF = datos)

lista2 <- list(A,B,C,D,datos$AGLOMERADO, DF = datos)

lista # Esto da error

# Funciones  
# funcion(arg1, argumento2 = arg2, ...)

paste("La desocupacion es del", tasa_de_desocupacion*100, "%", sep = "-")

paste0("El numero es", A)

vectorna <- c(1, 2, NA, 4, 5)
sum(vectorna, na.rm = TRUE)

sum(vector)
sum(vector_prueba)

mean(vector_prueba)



install.packages("tidyverse")
library(tidyverse)

# Working directory
getwd()

individual_t117 <- read.table(file = 'Clase 1 - Presentacion y R base/bases/usu_individual_t117.txt',
                              sep=";", 
                              dec=",", 
                              header = TRUE, 
                              fill = TRUE)

setwd("C:/Users/facun/OneDrive/Documentos/GitHub/curso_aset/Clase 1 - Presentacion y R base")

getwd()

individual_t117 <- read.table(file = 'bases/usu_individual_t117.txt',
                              sep=";", 
                              dec=",", 
                              header = TRUE, 
                              fill = TRUE)

# Tasa de desocupación según sexo
# Se asume que existe una columna SEXO y una variable de condición laboral (ej: ESTADO)

tasa_desocupacion_sexo <- individual_t117 %>%
  group_by(SEXO) %>%
  summarise(
    total = n(),
    desocupados = sum(ESTADO == "Desocupado", na.rm = TRUE),
    tasa_desocupacion = (desocupados / total) * 100
  )

tasa_desocupacion_edad <- ind
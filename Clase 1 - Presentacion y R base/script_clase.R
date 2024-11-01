
#Operadores de asignación
hola = 1 + 1   #primer comando de R
hola
hola <- 3
A <- 150
B <- 132

# Operadores aritmeticos
C = A + B
x = A/B
y = A * B
z = A^B

print(C)

# Operadores lógicos

a = 2
b = 3

a>b
a >= b

a == B

B = a

B == a
B != a

es_igual <- B != a

es_igual2 <- B != k

#Redefinimos los valores A y B
A <- 50
B <- 72
#Realizamos comparaciones lógicas

(A > 60 & B > 65)

(A > 60 | B > 65)

# Objetos

class(C)

class(es_igual)

vector <- c(1, 3, 4, "0343", 21, 45, 987)

culquier_nombre <-  c(1, 3, 4, "0343", 21, 45, 987)

vector[4]


dias_char <- c("Lunes","Viernes","Viernes","Jueves",
               "Martes", "Martes","Miercoles","Martes",
               "Miercoles")
class(dias_char)

table(dias_char)

dias_factor <- factor(dias_char,
                      levels = c("Lunes", 
                                 "Martes", 
                                 "Miercoles",
                                 "Jueves",
                                 "Viernes"))
class(dias_factor)
table(dias_factor)

D <- c(1, 3, 4)
D <- D + 2
D

iterador <- 1:10

E

E <- D + 1:3

E_posicion2 <-  E[2]

rm(E_posicion2)


# Data frames

AGLOMERADO  <- c(32,33,33,33,32)

SEXO  <-  c("Varon","Mujer","Mujer","Varon","Mujer")

EDAD  <-  c(60,54,18,27,32)

Datos <- data.frame(AGLOMERADO, SEXO, EDAD)

class(Datos)

Datos[3,2]

Datos$AGLOMERADO

Datos$ESTADO <- "OCUPADO"

class(Datos$AGLOMERADO)

Datos$AGLOMERADO[3,2] # ERROR

Datos$AGLOMERADO[3]

Datos[Datos$AGLOMERADO==32, ]

LISTA <- list(A,B,C,Datos$AGLOMERADO, DF = Datos)
LISTA

paste("Pega","estas", 4, "palabras", sep = "-")

unique(Datos$AGLOMERADO)

cantidad_desocupados = 7

mi_numero = 8

otro_numero = mi_numero * 2

otro_numero > 10

Datos

# calculate average of EDAD by AGLOMERADO
aggregate(EDAD ~ AGLOMERADO, data = Datos, mean)


library(readxl)
comunas <- read_excel("Clase 1 - Presentacion y R base/bases/comunas.xlsx")

comunas2 <- comunas[1:3,]

saveRDS(comunas2, "Clase 1 - Presentacion y R base/bases/comunas2.rds")

comunas$AREA

mean(comunas$AREA)

comunas$COLUMNA_NUEVA <- "PRUEBA"

getwd()





getwd()
list.files()

archivos_carpeta <- list.files("Clase 6 - Github, automatizaciones, web scraping/bases")

library(rvest)

page <- read_html("https://www.pagina12.com.ar")

h1_tags <- page %>% html_nodes("h1") %>% html_text()
h2_tags <- page %>% html_nodes("h2") %>% html_text()
h3_tags <- page %>% html_nodes("h3") %>% html_text()
p_tags  <- page %>% html_nodes("p")  %>% html_text()

print(h2_tags)
print(h3_tags)

# XPath en pagina12
all_h2_in_xpath <- page %>% html_nodes(xpath = '//h2') %>% html_text()
print(all_h2_in_xpath)






# XPath en página oficial de Argentina
page2 <- read_html("https://www.argentina.gob.ar/encuesta-de-indicadores-laborales")

h2_tags_xpath <- page2 %>%
  html_nodes(xpath = '//*[@id="block-system-main"]/section[1]/article/div/div/div/div/table') %>%
  html_text()

h2_tags_xpath

# Procesar texto scrapeado en un dataframe
library(tidyverse)

lines <- str_split(h2_tags_xpath, "\n")[[1]]

cleaned_lines <- lines %>%
  str_trim() %>%
  .[. != ""]

encabezados      <- cleaned_lines[1:2]
regiones         <- cleaned_lines[c(3, 6, 9)]
mensual_values   <- cleaned_lines[c(4, 7, 10)]
anual_values     <- cleaned_lines[c(5, 8, 11)]

df <- data.frame(regiones, mensual_values, anual_values)
colnames(df) <- c("Region", encabezados)
print(df)

df

nombre_archivo <- paste0("df_", format(Sys.time(), "%Y%m%d_%H%M%S"), ".txt")
write.table(df, file = nombre_archivo, sep = "\t", row.names = FALSE)


## Regex

# Vector de prueba
textos <- c("R es genial", "Regex es poderosa", "R puede ser difícil al principio")

grep("R", textos)

grep('genial', textos)

grep('genial|puede', textos)

# Buscar elementos donde hay caracteres numericos
textos2 <- c("Tengo 2 perros", "No tengo mascotas", "Mi número es 12345")
grep("\\d", textos2)

library(stringr)

# Extraer todos los números de una cadena
texto_numeros <- "Hay 12 gatos y 34 perros en 2024"
vector_numeros <- str_extract_all(texto_numeros, "[0-9]+")

# Crear un vector con ejemplos de montos en formato string
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
montos_limpios * 2

montos * 2


individual_t117 <- read.table(file = 'Clase 6 - Github, automatizaciones, web scraping/bases/usu_individual_t117.txt',
                              sep=";", 
                              dec=",", 
                              header = TRUE, 
                              fill = TRUE)

ch_columns <- individual_t117[  , grep("^CH", colnames(individual_t117))]

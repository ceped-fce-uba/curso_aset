# ============================================================
# Clase 6 - Automatizaciones, web scraping y Github
# Programación y visualización en estadísticas laborales - ASET
# ============================================================


# 1. Organización y lectura de archivos ----------------------

# Verificar el directorio de trabajo
getwd()

# Listar los archivos del directorio de trabajo
archivos <- list.files()
archivos

# Listar los archivos de un directorio específico
archivos_carpeta <- list.files("bases")
archivos_carpeta

# Loop para leer y pegar archivos (requiere repositorio precariedad.mundial)
rutas <- list.files("Bases_homog/", full.names = T, pattern = ".rds")
Base <- data.frame()
for (i in rutas) {
  base_temp <- readRDS(i) %>%
    mutate(PERIODO = as.character(PERIODO),
           EDAD = as.numeric(EDAD),
           ING = as.numeric(ING))
  Base <- bind_rows(Base, base_temp)
  print(i)
}


# 2. Web Scraping --------------------------------------------

library(rvest)

page <- read_html("https://www.pagina12.com.ar")
page

# Extraer texto según tags HTML
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


# 3. Expresiones Regulares (Regex) ---------------------------

# Ejemplo 1: grep() con vector de textos
textos <- c("R es genial", "Regex es poderosa", "R puede ser difícil al principio")

grep("R", textos)           # busca la letra "R"
grep("\\bR\\b", textos)     # busca la palabra "R"

# Ejemplo 2: stringr - extraer números de una cadena
library(stringr)

texto_numeros <- "Hay 12 gatos y 34 perros en 2024"
str_extract_all(texto_numeros, "[0-9]+")

# Ejemplo 3: gsub() - limpiar montos en $
montos <- c("$1.345.213,53", "$500,00", "$23.450,50", "$0,99",
            "$1.000,01", "$12.345.678,90", "$999.999,99", "$3,00")

convertir_a_numerico <- function(x) {
  x <- gsub("\\$", "", x)   # eliminar $
  x <- gsub("\\.", "", x)   # eliminar puntos de miles
  x <- gsub(",", ".", x)    # coma decimal → punto
  as.numeric(x)
}

montos_limpios <- convertir_a_numerico(montos)
montos_limpios

# Ejemplo 4: grep() para seleccionar columnas de la EPH
individual_t117 <- read.table(file = 'bases/usu_individual_t117.txt',
                              sep = ";",
                              dec = ",",
                              header = TRUE,
                              fill = TRUE)

ch_columns <- individual_t117[, grep("^CH", colnames(individual_t117))]
print(colnames(ch_columns))


# 4. Imputación de datos -------------------------------------

library(eph)

variables_EPH <- c("P21", "CAT_OCUP", "ESTADO", "PP07H", "PP07I",
                   "PP04B1", "PP04A", "REGION", "ANO4", "PONDERA",
                   "REGION", "CH04", "CH06", "PP04C", "PP04C99",
                   "PP04B_COD", "P21")

base <- get_microdata(year = 2024, period = 1, vars = variables_EPH)

# Redefino -9 como NA y genero variables auxiliares
base$P21[base$P21 == -9] <- NA

base <- base %>%
  filter(ESTADO == 1) %>%
  mutate(
    edad = CH06,
    edad2 = edad * edad,
    tramo_etario = case_when(
      edad <= 30             ~ "Joven",
      edad > 30 & edad <= 50 ~ "Adulto",
      edad > 50              ~ "Adulto mayor"),
    sexo = case_when(
      CH04 == 1 ~ "Hombre",
      CH04 == 2 ~ "Mujer"),
    region = factor(
      case_when(
        REGION == 01 ~ "AMBA",
        REGION == 43 ~ "Centro",
        REGION == 40 ~ "NOA",
        REGION == 41 ~ "NEA",
        REGION == 42 ~ "Cuyo",
        REGION == 44 ~ "Patagonia"),
      levels = c("AMBA", "Centro", "NEA", "Cuyo", "Patagonia", "NOA")),
    sexo = factor(sexo, levels = c("Mujer", "Hombre")))

base <- base %>% select(sexo, edad, region, edad2, tramo_etario, P21)

# Imputación por media de grupo (sexo, tramo etario, región)
base <- base %>%
  group_by(sexo, tramo_etario, region) %>%
  mutate(P21_imputado = ifelse(is.na(P21), mean(P21, na.rm = TRUE), P21)) %>%
  ungroup()

# Tabla de valores imputados
library(kableExtra)

tabla <- base %>%
  group_by(sexo, tramo_etario, region) %>%
  summarise(P21_imputado = mean(P21, na.rm = TRUE))

tabla %>%
  head(10) %>%
  kable(caption = "<b>Tabla 1.</b> Valores imputados en el ejemplo") %>%
  kable_styling(bootstrap_options = c("striped"), full_width = F, position = "float_left")

# Imputación por regresión lineal
modelo <- lm(P21 ~ edad + edad2 + sexo + region + tramo_etario, data = base)

base$P21_prediccion <- predict(modelo, newdata = base)
base$p21_imputado_regresion <- ifelse(is.na(base$P21), base$P21_prediccion, base$P21)

# Imputación por random forest (machine learning)
# install.packages("ranger")
library(ranger)

base_train   <- base %>% filter(!is.na(P21))
modelo_ml    <- ranger(P21 ~ edad + edad2 + sexo + region + tramo_etario, data = base_train)

base$P21_prediccion_ml <- predict(modelo_ml, data = base)$predictions
base$p21_imputado_ml   <- ifelse(is.na(base$P21), base$P21_prediccion_ml, base$P21)

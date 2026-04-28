
# Trabajar con el directorio del local
archivos <- list.files()

archivos

archivos_carpeta <- list.files('bases')

archivos_carpeta

# Web Scraping
library(rvest)

page <- read_html("https://www.pagina12.com.ar")

page

class(page)


h1_tags <- page %>% html_nodes("h1") %>% html_text()

h1_tags

h2_tags <- page %>% html_nodes("h2") %>% html_text()

# get elements from h2_tags with the word "Milei"
h2_tags_milei <- page %>% html_nodes("h2:contains('Milei')") %>% html_text()

p_tags <- page %>% html_nodes("p") %>% html_text()

all_h2_in_xpath <- page %>% html_nodes(xpath = '//h2') %>% html_text()

pagina12 <- read_html("https://www.pagina12.com.ar")
clarin <- read_html("https://www.clarin.com")

h2_clarin <- clarin %>% html_nodes(xpath = '//h2') %>% html_text()


page2 <- read_html("https://www.argentina.gob.ar/encuesta-de-indicadores-laborales")

# Obtengo infromación usando Xpath
h2_tags_xpath <- page2 %>% html_nodes(xpath ='//*[@id="block-system-main"]/section[1]/article/div/div/div/div/table') %>% html_text()

library(tidyverse)
lines <- str_split(h2_tags_xpath, "\n")[[1]]

cleaned_lines <- lines %>%
  str_trim() %>%
  .[. != ""]

encabezados <- cleaned_lines[1:2] 
regiones <- cleaned_lines[c(3,6,9)]
mensual_values <- cleaned_lines[c(4,7,10)]
anual_values <- cleaned_lines[c(5,8,11)]

# Combino datos en un df
df <- data.frame(
  regiones,
  mensual_values,
  anual_values
)

colnames(df) <- c("Region", encabezados)

df


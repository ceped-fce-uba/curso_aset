library(rvest)
library(stringr)

contar_palabras <- function(url, nombre_sitio) {
  cat("\n---", nombre_sitio, "---\n")
  page <- read_html(url)
  texto <- page %>% html_nodes("*") %>% html_text() %>% paste(collapse = " ")

  conteo_trabajo <- str_count(texto, regex("trabajo", ignore_case = TRUE))
  conteo_messi   <- str_count(texto, regex("messi",   ignore_case = TRUE))

  cat("Veces que aparece 'Trabajo':", conteo_trabajo, "\n")
  cat("Veces que aparece 'Messi':  ", conteo_messi,   "\n")

  if (conteo_trabajo > conteo_messi) {
    cat("=>", nombre_sitio, "habla más de Trabajo que de Messi.\n")
  } else if (conteo_messi > conteo_trabajo) {
    cat("=>", nombre_sitio, "habla más de Messi que de Trabajo.\n")
  } else {
    cat("=> Empate en", nombre_sitio, "\n")
  }

  data.frame(sitio = nombre_sitio, trabajo = conteo_trabajo, messi = conteo_messi)
}

resultados <- rbind(
  contar_palabras("https://www.pagina12.com.ar", "Página 12"),
  contar_palabras("https://www.clarin.com",      "Clarín"),
  contar_palabras("https://www.infobae.com",     "Infobae")
)

cat("\n=== Resumen ===\n")
print(resultados)

resultados['diferencia'] <- resultados$trabajo - resultados$messi
resultados['proporcion']  <- ifelse(resultados$messi > 0, resultados$trabajo / resultados$messi, NA)
resultados <- resultados %>% arrange(desc(diferencia))
cat("\n=== Ranking de sitios por diferencia (Trabajo - Messi) ===\n")
print(resultados)   
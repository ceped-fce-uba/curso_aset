## ----warning=FALSE,message=FALSE-------------------------
library(tidyverse)
library(openxlsx)
library(eph)


## ----message= F------------------------------------------

eph_2025_t1 <-eph::get_microdata(year = 2025, period = 1)
  


## --------------------------------------------------------
asalariados_2025_t1 <- eph_2025_t1 %>%
  filter(ESTADO == 1, CAT_OCUP == 3) %>% # Ocupados asalariados
  mutate(
    nivel.ed = factor(
      case_when(NIVEL_ED %in% c(7,1,2,3) ~ "Menor a Secundaria",
                NIVEL_ED %in% c(4,5) ~ "Secundaria Completa",
                NIVEL_ED == 6 ~ "Superior Completo",
                TRUE ~ "Ns/Nr"),
      levels = c("Menor a Secundaria","Secundaria Completa","Superior Completo")),
    tamanio.establec = factor(
      case_when(PP04C %in% 1:6  ~ "Pequeño",
                PP04C %in% 7:8  ~ "Mediano",
                PP04C %in% 9:12 ~ "Grande",
                PP04C %in% 99   ~ "Ns/Nr"),
      levels = c("Pequeño","Mediano","Grande","Ns/Nr")),
    descuento_jubil = case_when(PP07H == 1 ~ "Si",
                                PP07H == 2 ~ "No"),
    part.time.inv = case_when(PP3E_TOT < 35 & PP03G == 1 ~ "Si",
                             TRUE ~ "No"),
    tiempo.determinado = case_when(PP07C ==  1 ~ "Si",
                                   TRUE ~ "No"))



## --------------------------------------------------------
calculate_tabulates(base = asalariados_2025_t1,
                         x = "descuento_jubil",
                         weights = "PONDERA")


## --------------------------------------------------------
calculate_tabulates(base = asalariados_2025_t1,
                         x = "descuento_jubil",
                         y = "nivel.ed",
                         add.totals = "both",
                         weights = "PONDERA")


## --------------------------------------------------------
calculate_tabulates(base = asalariados_2025_t1,
                         x = "descuento_jubil",
                         y = "nivel.ed",
                         add.percentage = "col", 
                         weights = "PONDERA")


## --------------------------------------------------------
#Consigna 1


## --------------------------------------------------------
asalariados_2025_t1_signos<- asalariados_2025_t1 %>% 
  mutate(signos.precariedad = ifelse(descuento_jubil == "No",yes = 1,no = 0)+
                              ifelse(part.time.inv == "Si",yes = 1,no = 0)+
                              ifelse(tiempo.determinado == "Si",yes = 1,no = 0))
           


## --------------------------------------------------------
asalariados_2025_t1_signos %>% 
  group_by(signos.precariedad) %>% 
  summarise(Poblacion = sum(PONDERA))


## --------------------------------------------------------




## --------------------------------------------------------
ocupados <- eph_2025_t1 %>% 
  filter(ESTADO == 1) %>% 
  eph::organize_cno() %>% 
  mutate(sector_definicion_nueva = 
           case_when(SECTOR == 1 ~ "Formal",
                     SECTOR == 2 ~ "Informal",
                     SECTOR == 3 ~ "Hogares",
                     TRUE ~ "N/S"),
         empleo_definicion_nueva = 
           case_when(EMPLEO == 1 ~ "Formal",
                     EMPLEO == 2 ~ "Informal",
                     TRUE ~ "N/S"))

cruce_sector_empleo <- calculate_tabulates(ocupados, 
                    x = "sector_definicion_nueva",
                    y = "empleo_definicion_nueva",weights = 
                      "PONDERA",add.totals = "both"
                    )

cruce_sector_empleo


## ----include = FALSE, eval = FALSE-----------------------
# ocupados_sector_formal <- ocupados %>%
#   filter(sector_definicion_nueva == "Formal")
# 
# 
# eph::calculate_tabulates(ocupados_sector_formal,x = "empleo_definicion_nueva",weights = "PONDERA")
# eph::calculate_tabulates(ocupados_sector_formal,x = "empleo_definicion_nueva",weights = "PONDERA",add.percentage = "col")
# 
# catocup <- eph::calculate_tabulates(
#   ocupados_sector_formal,x = "CAT_OCUP", y = "empleo_definicion_nueva",
#   weights = "PONDERA",add.percentage = "col")
# 
# 
# calif <- eph::calculate_tabulates(
#   ocupados_s_formal,x = "CALIFICACION", y = "empleo_definicion_nueva",
#   weights = "PONDERA",add.percentage = "col")
# 
# 


## --------------------------------------------------------
# Lectura desde las carpetas del curso
preca_mundial<- readRDS("fuentes/base_homogenea.RDS")

metadata_preca<- openxlsx::read.xlsx("fuentes/Metadata.xlsx",sheet = 1)


## ----include=FALSE---------------------------------------
set.seed(18122022)
options(scipen = 999)


## --------------------------------------------------------
preca_mundial %>% sample_n(10)


## ----warning=FALSE---------------------------------------
preca_seg_paises <- preca_mundial %>% 
  group_by(ANO,PAIS,PRECASEG) %>% 
  summarise(casos_ponderados = sum(WEIGHT)) %>% # Casos (ponderados) de PRECASEG por PAIS
  group_by(ANO,PAIS) %>% 
  mutate(porcentaje = casos_ponderados/sum(casos_ponderados), # Proporcíon de PRECASEG (0,1 y NA) por PAIS
         porcentaje = scales::percent(porcentaje))  # Transformo a % 


preca_seg_paises


## --------------------------------------------------------
preca_seg_sin_na <- preca_mundial %>% 
  filter(!is.na(PRECASEG)) %>% 
  group_by(ANO,PAIS,PRECASEG) %>% 
  summarise(casos_ponderados = sum(WEIGHT)) %>% 
  group_by(ANO,PAIS) %>% 
  mutate(porcentaje = casos_ponderados/sum(casos_ponderados),
         porcentaje = scales::percent(porcentaje)) 

preca_seg_sin_na


## --------------------------------------------------------
preca_seg_sexo <- preca_mundial %>% 
  filter(!is.na(PRECASEG)) %>% 
  group_by(PAIS,SEXO,PRECASEG) %>% 
  summarise(casos_ponderados = sum(WEIGHT)) %>% 
  group_by(PAIS,SEXO) %>% 
  mutate(porcentaje = casos_ponderados/sum(casos_ponderados),
         porcentaje = scales::percent(porcentaje)) 

preca_seg_sexo


## --------------------------------------------------------
preca_select <- preca_mundial %>% 
  select(PAIS,WEIGHT,starts_with("PRECA"))
preca_select %>% head(10)


## --------------------------------------------------------
preca_numericas <- preca_mundial %>% 
  select(PAIS,where(is.numeric))

preca_numericas  %>% head(10)


## --------------------------------------------------------
preca_completo <- preca_mundial %>% 
  filter(
    if_all(starts_with("PRECA"),~!is.na(.x))
         )

preca_completo %>% head(10)


## --------------------------------------------------------
ingreso_medio <- preca_mundial %>% 
  group_by(PAIS) %>% 
  summarise(across(starts_with("ING"),~ mean(.x,na.rm = T)))

ingreso_medio


## --------------------------------------------------------
preca_expresiones <- preca_mundial %>% 
  group_by(PAIS) %>% 
  summarise(
    across(starts_with("PRECA"),
           ~ sum(.x,na.rm = T)/ # Suma de casos con valor 1 en PRECA
             sum(!is.na(.x)) # Suma de casos sin NA en PRECA_
           )
    ) 
preca_expresiones


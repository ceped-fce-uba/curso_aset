## ---- warning=FALSE,message=FALSE---------------------------------------------------------------
library(tidyverse)
library(openxlsx)
library(eph)


## -----------------------------------------------------------------------------------------------
individual_t117 <-
  read.table("../Fuentes/usu_individual_t117.txt",
  sep = ";",
  dec = ",",
  header = TRUE,
  fill = TRUE )
  


## -----------------------------------------------------------------------------------------------
variables <- c("CODUSU","NRO_HOGAR","COMPONENTE","ANO4","TRIMESTRE",
               "AGLOMERADO","CH03","CH04","CH06","ESTADO","CAT_OCUP","CAT_INAC","PP04A",
               "PP04B_COD","PP07H","P21","P47T","PONDERA","PP04D_COD","PP04C",
               "PP07A","PP07C","PP05B2_ANO","PP04B3_ANO","PP07E","NIVEL_ED",
               "PONDIIO","PP04C","PP03G","PP3E_TOT")



## -----------------------------------------------------------------------------------------------
asalariados.t117 <- individual_t117 %>%
  filter(ESTADO == 1, CAT_OCUP == 3) %>% # Ocupados asalariados
  select(all_of(variables)) %>% 
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



## -----------------------------------------------------------------------------------------------
calculate_tabulates(base = asalariados.t117,
                         x = "descuento_jubil",
                         weights = "PONDERA")


## -----------------------------------------------------------------------------------------------
calculate_tabulates(base = asalariados.t117,
                         x = "descuento_jubil",
                         y = "nivel.ed",
                         add.totals = "both",
                         weights = "PONDERA")


## -----------------------------------------------------------------------------------------------
calculate_tabulates(base = asalariados.t117,
                         x = "descuento_jubil",
                         y = "nivel.ed",
                         add.percentage = "col", 
                         weights = "PONDERA")


## -----------------------------------------------------------------------------------------------
#Ejercicio 1


## -----------------------------------------------------------------------------------------------
asalariados.t117.signos<- asalariados.t117 %>% 
  mutate(signos.precariedad = ifelse(descuento_jubil == "No",yes = 1,no = 0)+
                              ifelse(part.time.inv == "Si",yes = 1,no = 0)+
                              ifelse(tiempo.determinado == "Si",yes = 1,no = 0))
           


## -----------------------------------------------------------------------------------------------
asalariados.t117.signos %>% 
  group_by(signos.precariedad) %>% 
  summarise(Poblacion = sum(PONDERA))


## -----------------------------------------------------------------------------------------------
#Ejercicio 2


## -----------------------------------------------------------------------------------------------
base.hogar<- get_microdata(year = 2017,trimester = 1,type = "hogar",
              vars = c("CODUSU","NRO_HOGAR","ANO4","TRIMESTRE","IV6","II7",
                       "IV8","IV12_1","IV12_2"))



## -----------------------------------------------------------------------------------------------

base.indiv.hogar <- individual_t117 %>% 
  select(all_of(variables)) %>% 
  left_join(base.hogar, by = c("CODUSU", "NRO_HOGAR", "ANO4", "TRIMESTRE"))


## ----message=FALSE, warning=FALSE---------------------------------------------------------------
base.indiv.hogar.cat <-base.indiv.hogar %>%  
  mutate(
    estado.ocup = case_when(
      ESTADO == 1 & CAT_OCUP == 3 & PP07H == 1 ~ "Asalariadx Proteg",
      ESTADO == 1 & CAT_OCUP == 3 & PP07H == 2 ~ "Asalariadx Precario",
      ESTADO == 1 & CAT_OCUP == 2 ~ "Cuenta Propia",
      ESTADO == 3 & CAT_INAC == 1 ~ "Jubiladx",
      ESTADO %in% 2:3 & CAT_INAC != 1 ~ "Desocupadx e Inactivx"),
    es.propietario = case_when(II7 %in%  c(1,2) ~ "Si",
                                  TRUE ~ "No"),
    agua.dentro.vivienda = case_when(IV6 == 1 ~ "Si",
                                 TRUE ~ "No"))


## -----------------------------------------------------------------------------------------------
base.indiv.hogar.cat.jefe <- base.indiv.hogar.cat %>% 
  group_by(CODUSU,NRO_HOGAR) %>% 
  mutate(estado.ocup.jefe = estado.ocup[CH03==1]) %>% 
  filter(!is.na(estado.ocup.jefe)) #saco casos residuales como patrones o TFSR


## -----------------------------------------------------------------------------------------------
calculate_tabulates(base = base.indiv.hogar.cat.jefe,
                    x = "estado.ocup.jefe",
                    y = "agua.dentro.vivienda",
                    add.percentage = "row",
                    weights = "PONDERA")

## -----------------------------------------------------------------------------------------------
calculate_tabulates(base = base.indiv.hogar.cat.jefe,
                    x = "estado.ocup.jefe",
                    y = "es.propietario",
                    add.percentage = "row",
                    weights = "PONDERA")


## -----------------------------------------------------------------------------------------------



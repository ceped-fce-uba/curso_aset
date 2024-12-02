

base <- readRDS("C:/Users/facun/OneDrive/Documentos/GitHub/ceped-data/www/data/salarios.Rds")

library(tidyverse)
base <- readRDS("C:/Users/facun/OneDrive/Documentos/GitHub/precariedad.mundial/base_homogenea.Rds") %>% 
  filter(CALIF %in%  c("Alta","Media","Baja")) %>% 
  filter(SECTOR == "Priv", !is.na(CALIF), !is.na(TAMA)) %>%
  mutate(grupos = case_when(CATOCUP == "Cuenta propia" ~ paste0("Cuentapropista - ",CALIF),
                            TRUE ~ paste0(TAMA, " - ",CALIF)),
         tamanio.calif = factor(grupos,
                                levels = 
                                  c("Cuentapropista - Baja",
                                    "Cuentapropista - Media",
                                    "Cuentapropista - Alta",
                                    "Pequeño - Baja",
                                    "Pequeño - Media",
                                    "Pequeño - Alta",
                                    "Mediano - Baja",
                                    "Mediano - Media", 
                                    "Mediano - Alta",
                                    "Grande - Baja",
                                    "Grande - Media",
                                    "Grande - Alta"
                                  ))) %>% 
  group_by(PAIS,tamanio.calif) %>% 
  summarise(casos_pond = sum(WEIGHT,na.rm = T)) %>% 
  group_by(PAIS) %>% 
  mutate(particip.ocup= casos_pond/sum(casos_pond))



## ATENCION: hay que tener los repositorios clonados en el local y cambiar la ruta para que coincida con la de tu directorio

PATH_LOCAL = "C:/Users/facun/OneDrive/Documentos/GitHub/"

#Leer datos de salarios del CEPED

base_salarios_ceped_data <- readRDS(paste0(PATH_LOCAL, "/ceped-data/www/data/salarios.Rds"))

#Leer datos desde precaridedad mundial y transformarlos

library(tidyverse)
base <- readRDS(paste0(PATH_LOCAL, "/precariedad.mundial/base_homogenea.Rds")) %>% 
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

# Leer eph y procesar datos tal como se hizo en la clase 7

bases <- readRDS(paste0(PATH_LOCAL, "curso_aset/Clase 7 - PowerBI/bases/bases_eph.Rds"))

bases <- bases %>% 
  mutate(anio_trim  = paste0(ANO4,"T",TRIMESTRE))

base_salarios <- bases %>% 
  filter(ESTADO == 1, CAT_OCUP ==3,P21>0)

serie_salarios <- base_salarios %>% 
group_by(anio_trim) %>% 
summarise(salario_promedio = weighted.mean(P21,PONDIIO))

serie_salarios2 <- serie_salarios %>% 
  mutate(salario_promedio = round(salario_promedio,0))

serie_salarios_sexo <- base_salarios %>% 
  group_by(anio_trim, CH04) %>% 
  summarise(salario_promedio = weighted.mean(P21,PONDIIO))
## ----warning=FALSE,message=FALSE------------------
library(tidyverse)
library(openxlsx)
library(eph)
library(scales)


## -------------------------------------------------
list.files("Fuentes/")


## -------------------------------------------------
indiv_t4_25 <-
  read.table("Fuentes/usu_individual_T425.txt",
  sep = ";",
  dec = ",",
  header = TRUE,
  fill = TRUE)
  
  
Aglom <- openxlsx::read.xlsx("Fuentes/Aglomerados y Regiones EPH.xlsx")


## -------------------------------------------------
Datos  <- indiv_t4_25[c("AGLOMERADO","MAS_500","CH04","CH06","P47T","PONDERA","PONDII")]


## -------------------------------------------------
summary(Datos) 


## -------------------------------------------------
unique(Datos$AGLOMERADO)


## -------------------------------------------------
sample_n(tbl = Datos,size = 9)


## -------------------------------------------------
table(Datos$MAS_500,Datos$CH04) 


## -------------------------------------------------
eph::calculate_tabulates(base = Datos,x = "MAS_500",y = "CH04",weights = "PONDERA",add.totals = "both")


## -------------------------------------------------
data_filtrada <- Datos %>% 
  filter(CH04==1 , CH06>=50)



## -------------------------------------------------
Datos %>% 
    filter(CH04==1| CH06>=50) %>% 
    head(10) # Comando para que muestre los primeros 10 datos



## -------------------------------------------------
Datos %>% 
  slice_max(order_by = P47T,n = 10)


## -------------------------------------------------
Datos <- Datos %>% 
  rename(EDAD = CH06)

head(Datos)


## -------------------------------------------------
Datos <- Datos %>% 
  mutate(Edad_cuadrado=EDAD^2,
         Edad_cubo =EDAD^3) 

head(Datos)


## ----max------------------------------------------
Datos <- Datos %>% 
  mutate(Grupos_Etarios = case_when(EDAD  < 18   ~ "Menores",
                                 EDAD  %in%  18:65   ~ "Adultos",
                                 EDAD  > 65 ~ "Adultos Mayores"))
head(Datos)


## -------------------------------------------------
#Conservo solo 2 variables
Datos %>% 
  select(CH04,PONDERA)

#Conservo todas las variables desde la 3era
Datos %>% 
  select(3:ncol(.))


## -------------------------------------------------
Datos <- Datos %>% 
  arrange(CH04,EDAD)

head(Datos)


## -------------------------------------------------
#Recuerden que los menores de un año están clasificados con el valor -1
Datos <- Datos %>% 
  mutate(edad.corregida=ifelse(EDAD == -1,yes = 0,no = EDAD))

#R BASE#
mean(Datos$edad.corregida,na.rm = T) #sin ponderar
weighted.mean(Datos$edad.corregida,Datos$PONDERA) #ponderado

#Tidyverse

Datos %>%      
 summarise(Edad_prom = mean(edad.corregida),  #sin ponderar
           Edad_prom_pond = weighted.mean(x = edad.corregida,w = PONDERA)) #ponderado



## -------------------------------------------------
Datos %>% 
  group_by(CH04) %>%
  summarise(Edad_Prom = weighted.mean(EDAD,PONDERA))


## -------------------------------------------------
Encadenado <- Datos %>% 
  filter(Grupos_Etarios == "Adultos") %>% 
  mutate(Sexo = case_when(CH04 == 1 ~ "Varon",
                          CH04 == 2 ~ "Mujer")) %>% 
  select(-Edad_cuadrado)
  
Encadenado


## ----echo=TRUE------------------------------------
head(Aglom)

Datos_join <- Datos %>% 
  left_join(.,Aglom, by = "AGLOMERADO")

head(Datos_join)



## -------------------------------------------------
Poblacion_Aglomerados <- Datos_join %>% 
  group_by(Nom_Aglo) %>% 
  summarise(Menores = sum(PONDERA[Grupos_Etarios=="Menores"]),
            Adultos = sum(PONDERA[Grupos_Etarios=="Adultos"]),
            Adultos_Mayores = sum(PONDERA[Grupos_Etarios=="Adultos Mayores"]))

Poblacion_Aglomerados


## -------------------------------------------------
pob.aglo.long <- Poblacion_Aglomerados %>% 
  pivot_longer(cols = 2:4,names_to = "Grupo_Etario",values_to = "Poblacion")

pob.aglo.long


## -------------------------------------------------
pob.aglo.long %>% 
  pivot_wider(names_from = "Grupo_Etario",values_from = "Poblacion")
  


## ----echo=TRUE------------------------------------
Poblacion_ocupados <- indiv_t4_25 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]))

Poblacion_ocupados


## ----echo=TRUE------------------------------------
Empleo <- indiv_t4_25 %>% 
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Tasa_Empleo    = Ocupados/Poblacion)

Empleo


## -------------------------------------------------
Empleo %>% 
  mutate(Tasa_Empleo_Porc = scales::percent(Tasa_Empleo))


## -------------------------------------------------
Empleo_aglo <- indiv_t4_25 %>% 
  group_by(AGLOMERADO)%>%
  summarise(Poblacion         = sum(PONDERA),
            Ocupados          = sum(PONDERA[ESTADO == 1]),
            Tasa_Empleo    = Ocupados/Poblacion)



## ----eval=FALSE-----------------------------------
# dir.create("Resultados")
# openxlsx::write.xlsx(x = Empleo,file =  "Resultados/miexportacion.xlsx")


## ----eval=FALSE-----------------------------------
# dir.create("Resultados")
# openxlsx::write.xlsx(
#   x = list(Empleo,Empleo_aglo),
#   file =  "Resultados/miexportacion_2.xlsx")


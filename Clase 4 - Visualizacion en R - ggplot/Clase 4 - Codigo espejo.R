library(tidyverse) # cargamos la librería tidyverse (que incorpora ggplot)
library(ggthemes) # diseños preconfigurados para los gráficos ggplot
library(readxl) # Cargamos readxl para traer levantar excels

# iris es un set de datos clásico, que ya viene incorporado en R
iris[1:10,]
plot(iris)
#Al especificar una variable, puedo ver el valor que toma cada uno de sus registros (Index)
plot(iris$Sepal.Length,type = "p") # Un punto por cada valor
plot(iris$Sepal.Length,type = "l") # Una linea que una cada valor
plot(iris$Sepal.Length,type = "b") #Ambas
hist(iris$Sepal.Length, col = "lightsalmon1", main = "Histograma")

## ruta_archivo <- "../grafico1.PNG"
## ruta_archivo
## png(ruta_archivo)
## plot(iris$Sepal.Length,type = "b")
## dev.off()

Individual_t119 <- read.table("Fuentes/usu_individual_t119.txt",
                              sep=";", dec=",", header = TRUE, fill = TRUE)

aglomerados <- read_excel("Fuentes/Aglomerados EPH.xlsx")
regiones <- read_excel("Fuentes/Regiones.xlsx")

salario_y_no_registro <- Individual_t119 %>% 
  filter(ESTADO == 1, CAT_OCUP == 3) %>% 
  group_by(ANO4,TRIMESTRE,REGION,AGLOMERADO) %>% 
  summarise(tasa_no_reg = sum(PONDERA[PP07H == 2])/sum(PONDERA),
            salario_prom = weighted.mean(P21,PONDIIO),
            asalariados = sum(PONDERA)) %>% 
  ungroup() %>% 
  left_join(aglomerados,by = c("AGLOMERADO")) %>% 
  left_join(regiones,by = c("REGION"))

salario_y_no_registro

ggplot(data = salario_y_no_registro,
       aes(x = salario_prom,
       y = tasa_no_reg,
       size = asalariados,
       color = Region))+
  geom_point()+
  labs(title = "Salario promedio y tasa de no registro por aglomerados",
       subtitle = "31 Aglomerados. 1er Trimestre de 2019.",
       x = "Salario promedio",
       y = "Tasa de no registro")+
  theme_minimal()+
  guides(size = F)+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  scale_x_continuous(labels = scales::number_format(big.mark = ".",decimal.mark = ","))

capa1 <- ggplot(data = salario_y_no_registro,
                aes(x = salario_prom,
                y = tasa_no_reg,
                size = asalariados,
                color = Region))

capa1

capa2 <- capa1 +  
  geom_point()

capa2

capa3 <- capa2 +
  labs(title = "Salario promedio y tasa de no registro por aglomerados",
       subtitle = "31 Aglomerados. 1er Trimestre de 2019.",
       x = "Salario promedio",
       y = "Tasa de no registro")

capa3

grafico_final <- capa3 +
theme_minimal()+
  guides(size = FALSE)+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  scale_x_continuous(labels = scales::number_format(big.mark = ".",decimal.mark = ","))


grafico_final

library(plotly)

grafico_final <- ggplot(data = salario_y_no_registro,
       aes(x = salario_prom,
       y = tasa_no_reg,
       size = asalariados,
       aglo = Nom_Aglo, #Aca creo un parametro del aes que depende de Nom_Aglo
       color = Region))+
  geom_point()+
  labs(title = "Salario promedio y tasa de no registro por aglomerados",
       subtitle = "31 Aglomerados. 1er Trimestre de 2019.",
       x = "Salario promedio",
       y = "Tasa de no registro")+
  theme_minimal()+
  guides(size = F)+
  scale_y_continuous(labels = scales::percent_format(accuracy = 1))+
  scale_x_continuous(labels = scales::number_format(big.mark = ".",decimal.mark = ","))

ggplotly(grafico_final,tooltip = "aglo")

library(GGally)

ggpairs(iris,  mapping = aes(color = Species))

base_para_otros_ejemplos <- Individual_t119 %>%
  left_join(regiones) %>% 
  filter(P21>0) %>% 
  mutate(Sexo = case_when(CH04 == 1 ~ "Varón",
                          CH04 == 2 ~ "Mujer")) 

library(ggridges) 

ggplot(base_para_otros_ejemplos, aes(x = P21, y = Sexo, fill=Sexo)) + 
  geom_density_ridges()+
  scale_x_continuous(limits = c(0,60000))#Restrinjo el gráfico hasta ingresos de $60000

## iris <- iris
## #Correr en la consola
## esquisse::esquisser()

ggplot(base_para_otros_ejemplos, aes(x = Region, y = P21)) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))#Restrinjo el gráfico hasta ingresos de $40000


ggplot(base_para_otros_ejemplos, aes(x= Region, y = P21 ,fill = Region )) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))+
  facet_wrap(vars(Sexo))

ggplot(base_para_otros_ejemplos, aes(x= Sexo, y = P21, group = Sexo, fill = Sexo )) +
  geom_boxplot()+
  scale_y_continuous(limits = c(0, 40000))+
  facet_wrap(vars(Region),nrow = 1) +
  theme(legend.position = "none")


ggplot(base_para_otros_ejemplos, aes(x = P21,weights = PONDIIO))+ 
geom_histogram(fill='salmon', color='grey25')+
scale_x_continuous(limits = c(0,50000))

ggplot(base_para_otros_ejemplos, aes(x = P21,weights = PONDIIO))+ 
geom_density(fill='salmon', color='grey25')+
scale_x_continuous(limits = c(0,50000))

ggplot(base_para_otros_ejemplos, aes(x = P21,weights = PONDIIO))+ 
geom_density(adjust = 2,fill='salmon', color='grey25')+
scale_x_continuous(limits = c(0,50000))


ggplot(base_para_otros_ejemplos, aes(x = P21,weights = PONDIIO))+ 
geom_density(adjust = 0.01,fill='salmon', color='grey25')+
scale_x_continuous(limits = c(0,50000))

ggdata <- base_para_otros_ejemplos %>% 
  filter(!is.na(NIVEL_ED),
         NIVEL_ED!=7, 
         PP04A !=3) %>% 
  mutate(NIVEL_ED = factor(case_when(NIVEL_ED == 1  ~ 'Primaria \n Incompleta', # '\n' significa carriage return, o enter
                                     NIVEL_ED == 2  ~ 'Primaria \n Completa',
                                     NIVEL_ED == 3  ~ 'Secundaria \nIncompleta',
                                     NIVEL_ED == 4  ~ 'Secundaria \nCompleta',
                                     NIVEL_ED == 5  ~ 'Superior \nUniversitaria \nIncompleta',
                                     NIVEL_ED == 6  ~ 'Superior \nUniversitaria \nCompleta',
                                     FALSE          ~ 'Otro'),
                           levels= c('Primaria \n Incompleta',
                                     'Primaria \n Completa',
                                     'Secundaria \nIncompleta',
                                     'Secundaria \nCompleta',
                                     'Superior \nUniversitaria \nIncompleta',
                                     'Superior \nUniversitaria \nCompleta')),
         Sexo     = case_when(CH04 == 1 ~ 'Varón',
                              CH04 == 2 ~ 'Mujer'),
         Establecimiento    = case_when(PP04A == 1 ~ 'Estatal',
                                        PP04A == 2 ~ 'Privado',
                                        FALSE      ~ 'Otro'))


ggplot(ggdata, aes(CH06, P21, colour = Sexo, shape = Sexo, alpha = P21))+
  geom_smooth() + 
  labs(
    x = 'Edad',
    y = 'ingreso',
    title = 'Ingreso por ocupación principal',
    subtitle = 'Según edad, nivel educativo y sexo') +
  theme_minimal()+
  scale_y_continuous()+
  scale_alpha(guide = FALSE)+
  facet_grid(~NIVEL_ED)


ggplot(ggdata, aes(CH06, P21, colour = Sexo, weight = PONDIIO)) +
  geom_smooth(method = "lm", formula = y ~ poly(x, 2)) +
  labs(x = 'Edad',
       y = 'ingreso',
       title = 'Regresion cuadrática del Ingreso por ocupación principal respecto de la Edad',
       subtitle = 'Según Nivel educativo y sexo') +
  theme_minimal()+
  facet_grid( ~ NIVEL_ED)

ggplot(ggdata, aes(CH06, P21, colour = Establecimiento, weight = PONDIIO)) +
  geom_smooth(method = "lm") +
  labs(
  x = 'Edad',
  y = 'ingreso',
  title = 'Tendencia del ingreso por ocupación principal',
  subtitle = 'Según edad, nivel educativo, sexo y tipo de establecimiento') +
  theme_minimal()+
  facet_grid(Sexo ~ NIVEL_ED)

#ggsave(filename = paste0("../regresion lineal.png"),scale = 2)

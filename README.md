---
title: "Herramientas de programación para la producción y difusión de estadísticas socioeconómicas"
subtitle: "Materiales de cursada - ASET 2026"
author-title: "Docentes:"
authors:
  - name: Facundo Lastra
  - name: Guido Weksler
institution: "Centro de Estudios sobre Población, Empleo y Desarrollo (CEPED) - FCE, UBA"
date: "2026"
---

# Presentación

Este repositorio contiene los materiales de cursada del programa de capacitación en **R** orientado al análisis de datos laborales. El curso está estructurado en 8 clases progresivas que abarcan desde los fundamentos del lenguaje hasta técnicas avanzadas de análisis, visualización y automatización.

Los materiales se encuentran organizados por clases, incluyendo scripts de R, bases de datos de práctica, documentos HTML con contenido teórico y ejercicios prácticos resueltos.

# Objetivos del curso

- Dominar las herramientas fundamentales de **R** para análisis estadístico
- Aplicar técnicas específicas para el procesamiento de la **Encuesta Permanente de Hogares (EPH)**
- Desarrollar habilidades en **visualización de datos** y **automatización de reportes**
- Integrar herramientas complementarias como **Git**, **Power BI** y **Google Sheets**
- Implementar flujos de trabajo reproducibles para investigación social

# Estructura del programa

## Módulo I: Fundamentos

### Clase 1 - Presentación y R Base

**Contenidos:**

- Descripción del programa "R" y lógica sintáctica del lenguaje
- Configuración del entorno: Visual Studio Code para R
- Caracteres especiales y operadores (asignación, lógicos, aritméticos)
- Definición de objetos: Valores, Vectores, DataFrames, Tibbles, Listas
- Tipos de variables: numéricas, caracteres, factores, lógicas
- Funciones básicas del lenguaje
- Primera introducción a **GitHub**
- Programación asistida con herramientas de IA

**Materiales:** [Clase 1 - Presentación y R base/](./Clase%201%20-%20Presentacion%20y%20R%20base/)

### Clase 2 - EPH e Introducción a Tidyverse

**Contenidos:**

- Presentación de la Encuesta Permanente de Hogares (EPH)
- Lectura de bases de datos en diferentes formatos
- Análisis exploratorio y recomendaciones metodológicas
- Limpieza de datos: renombrar y recodificar variables
- Creación y selección de variables, ordenamiento y agrupamiento
- Aplicación de filtros sobre bases de datos
- **Tidyr**: manejo de la disposición de datos (pivot_longer, pivot_wider)
- Operaciones de unión: Joins y bind_rows
- Medidas de resumen estadístico

**Materiales:** [Clase 2 - EPH e Intro a Tidyverse/](./Clase%202%20-%20EPH%20e%20Intro%20a%20Tidyverse/)

### Clase 3 - Indicadores de Precariedad y Tidyverse Avanzado

**Contenidos:**

- **Tidyverse avanzado**: selectores (starts_with, ends_with) y funciones across()
- Tratamiento de valores faltantes (missing values/NA's)
- Conceptos de informalidad y precariedad laboral
- Operacionalización con variables EPH
- Indicadores unidimensionales y co-ocurrencia de fenómenos
- **Precariedad Mundial**: comparación internacional y homogeneización
- Estimación de indicadores comparativos

**Materiales:** [Clase 3 - Indicadores de Precariedad/](./Clase%203%20-%20Indicadores%20de%20Precariedad%20-%20Tidyverse2/)

## Módulo II: Visualización y Documentación

### Clase 4 - Visualización en R con ggplot2

**Contenidos:**

- Introducción al paquete **ggplot2**
- Lógica de capas en el armado de gráficos
- Variantes de geometrías: líneas, puntos, barras, boxplots
- Aesthetics y customización visual
- Facets para gráficos múltiples
- Gráficos interactivos con **ggplotly**

**Materiales:** [Clase 4 - Visualización en R/](./Clase%204%20-%20Visualizacion%20en%20R%20-%20ggplot/)

### Clase 5 - Markdown, Loops y Funciones

**Contenidos:**

- **R Markdown** y **R Notebook** para documentos reproducibles
- Opciones de visualización de código en reportes
- Configuración de gráficos y tablas en informes
- Caracteres especiales y recursos multimedia
- Código embebido para automatización de reportes
- **Estructuras iterativas** (loops)
- **Creación de funciones** personalizadas

**Materiales:** [Clase 5 - Markdown, loops y funciones/](./Clase%205%20-%20Markdown,%20loops%20y%20funciones/)

## Módulo III: Herramientas Avanzadas

### Clase 6 - Git, GitHub y Automatizaciones

**Contenidos:**

- Introducción a **Git** y control de versiones
- Funcionalidades avanzadas de **GitHub**: Issues, Branches, Merges
- **GitHub Pages** para publicación web
- Automatización de procesos con R
- **Expresiones regulares**
- Introducción al **Web Scraping**
- Técnicas de imputación de datos faltantes

**Materiales:** [Clase 6 - GitHub y automatizaciones/](./Clase%206%20-%20Github,%20automatizaciones,%20web%20scraping/)

### Clase 7 - Power BI

**Contenidos:**

- Introducción a **Power BI** y su ecosistema
- Conexión con múltiples fuentes de datos
- Transformación de datos con **Power Query**
- Creación de visualizaciones profesionales
- Diseño de dashboards interactivos
- Publicación y distribución de reportes

**Materiales:** [Clase 7 - PowerBI/](./Clase%207%20-%20PowerBI/)

### Clase 8 - Integración con Google Sheets y Looker

**Contenidos:**

- Conexión a **Google Sheets** desde R
- Configuración de APIs y autenticación
- Armado de flujos de datos automatizados
- Creación de visualizaciones con **Looker**
- Diseño de dashboards empresariales
- Automatización y programación de reportes

**Materiales:** [Clase 8 - GoogleSheets y Looker/](./Clase%208%20-%20GoogleSheets%20y%20Looker/)

---

**Asociación Argentina de Especialistas en Estudios del Trabajo (ASET)**  
*Facultad de Ciencias Económicas - Universidad de Buenos Aires*
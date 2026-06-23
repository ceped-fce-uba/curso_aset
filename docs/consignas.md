> **Curso ASET 2026**  
> **Docentes:** Facundo Lastra y Guido Weksler  

# **Trabajo Práctico Final**  

Para acreditar la realización del curso, se deberá enviar a los docentes un repositorio de GitHub que responda a las siguientes consignas, en grupos de hasta **2 integrantes**.  El repositorio deberá incluir un script de procesamiento de datos en R y un informe elaborado en Rmarkdown, Quarto o en formato .html, utilizando gráficos realizados con `ggplot`.

**Fecha de entrega:**  
**1 de Octubre del 2026**  

---

## **Consignas**  

1. **Selección de encuesta:**  
   - Elegir una encuesta de hogares relevada por el instituto nacional de estadística oficial de algún país
   - Si lo hablamos con antelación, podemos trabajar sobre otra fuente de datos de estadísticas socio-laborales
   - *(Se puede elegir un país o fuente de datos que esté en el repositorio del proyecto Precariedad Mundial)*

2. **Informe de análisis exploratorio**  
   - Escribir un informe donde se realice un análisis exploratorio sobre:  
     - La cantidad de casos que posee la encuesta según:  
       - **Sexo**  
       - **Rangos etarios**  
       - **Otras variables de interés** relacionadas con la problemática de la precariedad laboral.  
   - Crear una **variable dummy** que exprese situaciones de empleo precario.  
     - Detallar en el informe la población a la cual aplica dicha variable (¿ocupados?, ¿sólo asalariados?, etc.).  
   - Analizar la incidencia de la precariedad en el conjunto poblacional correspondiente, desagregando el análisis según:  
     - **Sexo**  
     - **Rangos etarios**  
     - **Otras variables de interés**

3.  **Script en R**  
    -El script deberá seguir los siguientes pasos: 
      - Carga de datos: tomar todos los datos presentes en una carpeta del repositorio `\bases` (para que pueda ser corrido en el futuro si se agregan bases de datos)
      - Transformación: crear las variables necesarias para el análisis exploratorio del punto **2.** y elaborar tablas/gráficos
      - Guardado: guardar los resultados en `\resultados`
      - Log: el script deberá generar un archivo csv o txt indicando las veces que fue corrido

4. **Dashboard:**  
   - Elaborar un dashboard para visualizar los datos procesados utilizando alguna extensión de R, PowerBI o Looker.  
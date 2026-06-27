library(shiny)
library(tidyverse)
library(plotly)

# ---- Rutas de datos ----
# Cambiar PATH_LOCAL si los repositorios están en otra ubicación
PATH_LOCAL <- "C:/Users/facun/OneDrive/Documentos/GitHub/"

# ---- EPH: salarios de asalariados privados ----
bases <- readRDS("../bases/bases_eph.Rds") %>%
  mutate(anio_trim = paste0(ANO4, "T", TRIMESTRE))

base_salarios_eph <- bases %>%
  filter(ESTADO == 1, CAT_OCUP == 3, P21 > 0)

serie_general <- base_salarios_eph %>%
  group_by(anio_trim, ANO4) %>%
  summarise(salario = round(weighted.mean(P21, PONDIIO), 0), .groups = "drop")

serie_sexo <- base_salarios_eph %>%
  group_by(anio_trim, ANO4, CH04) %>%
  summarise(salario = round(weighted.mean(P21, PONDIIO), 0), .groups = "drop") %>%
  mutate(sexo = ifelse(CH04 == 1, "Varón", "Mujer"))

anios_eph <- sort(unique(base_salarios_eph$ANO4))

# ---- CEPED-DATA: salarios ----
ceped_ok <- FALSE
base_salarios_ceped <- tryCatch({
  dat <- readRDS(paste0(PATH_LOCAL, "ceped-data/www/data/salarios.Rds"))
  ceped_ok <- TRUE
  dat
}, error = function(e) NULL)

# ---- Precariedad Mundial: estructura del empleo ----
pm_ok <- FALSE
base_pm <- tryCatch({
  dat <- readRDS(paste0(PATH_LOCAL, "precariedad.mundial/base_homogenea.Rds")) %>%
    filter(CALIF %in% c("Alta", "Media", "Baja")) %>%
    filter(SECTOR == "Priv", !is.na(CALIF), !is.na(TAMA)) %>%
    mutate(grupos = case_when(
      CATOCUP == "Cuenta propia" ~ paste0("Cuentapropista - ", CALIF),
      TRUE                       ~ paste0(TAMA, " - ", CALIF)
    ),
    tamanio.calif = factor(grupos, levels = c(
      "Cuentapropista - Baja",  "Cuentapropista - Media",  "Cuentapropista - Alta",
      "Pequeño - Baja",         "Pequeño - Media",          "Pequeño - Alta",
      "Mediano - Baja",         "Mediano - Media",           "Mediano - Alta",
      "Grande - Baja",          "Grande - Media",            "Grande - Alta"
    ))) %>%
    group_by(PAIS, tamanio.calif) %>%
    summarise(casos_pond = sum(WEIGHT, na.rm = TRUE), .groups = "drop") %>%
    group_by(PAIS) %>%
    mutate(particip.ocup = casos_pond / sum(casos_pond))
  pm_ok <- TRUE
  dat
}, error = function(e) NULL)

paises_pm <- if (pm_ok) sort(unique(base_pm$PAIS)) else character(0)

# ---- Paleta Precariedad Mundial ----
colores_pm <- c(
  "Cuentapropista - Baja"  = "#d45f5f", "Cuentapropista - Media" = "#e0897f",
  "Cuentapropista - Alta"  = "#ecb3a0",
  "Pequeño - Baja"         = "#5b8db8", "Pequeño - Media"        = "#84aecf",
  "Pequeño - Alta"         = "#aecde6",
  "Mediano - Baja"         = "#4a9e7c", "Mediano - Media"        = "#72bb9c",
  "Mediano - Alta"         = "#9dd4ba",
  "Grande - Baja"          = "#7c5cbf", "Grande - Media"         = "#9e83d4",
  "Grande - Alta"          = "#c0aae8"
)

# ---- Tema ggplot común ----
tema_base <- theme_minimal(base_size = 12) +
  theme(
    plot.title       = element_text(size = 13, face = "bold", color = "#1a1a1a"),
    panel.grid.minor = element_blank()
  )

# ============================================================
# UI
# ============================================================

ui <- navbarPage(
  title = "Tablero de datos — Clase 7",
  theme = NULL,

  header = tags$head(tags$style(HTML("
    body    { font-family: Arial, sans-serif; background: #f5f4f0; }
    .navbar { background-color: #1a1a1a !important; border: none; }
    .navbar .navbar-brand, .navbar-nav > li > a { color: #fff !important; }
    .navbar-nav > li.active > a { background-color: #c0392b !important; }
    .well   { background: #fff; border: 1px solid #e0ddd8; }
    .aviso  { background:#fff8f0; border-left:4px solid #e67e22; padding:12px 16px;
               border-radius:3px; font-size:0.88rem; color:#7a4a10; margin-top:12px; }
    code    { background:#f0ede8; padding:2px 5px; border-radius:3px; color:#c0392b; }
  "))),

  # ----------------------------------------------------------
  # Panel 1: EPH
  # ----------------------------------------------------------
  tabPanel(
    "EPH — Salarios Argentina",
    br(),
    sidebarLayout(
      sidebarPanel(
        width = 3,
        sliderInput("anios_eph", "Rango de años:",
                    min = min(anios_eph), max = max(anios_eph),
                    value = c(min(anios_eph), max(anios_eph)),
                    step = 1, sep = ""),
        hr(),
        p("Salario nominal promedio de asalariados del sector privado.",
          "Fuente: EPH (INDEC).",
          style = "font-size:0.8rem; color:#777; line-height:1.5;")
      ),
      mainPanel(
        width = 9,
        tabsetPanel(
          tabPanel("Serie general",  br(), plotOutput("plot_eph_general", height = "380px")),
          tabPanel("Por sexo",       br(), plotOutput("plot_eph_sexo",    height = "380px")),
          tabPanel("Tabla de datos", br(), div(style = "overflow-x:auto;", tableOutput("tabla_eph")))
        )
      )
    )
  ),

  # ----------------------------------------------------------
  # Panel 2: Precariedad Mundial
  # ----------------------------------------------------------
  tabPanel(
    "Precariedad Mundial",
    br(),
    if (!pm_ok) {
      div(class = "aviso",
          tags$b("Datos no disponibles."), " Para visualizar este panel cloná el repositorio ",
          tags$code("precariedad.mundial"), " en ", tags$code(PATH_LOCAL),
          " y reiniciá la app.")
    } else {
      sidebarLayout(
        sidebarPanel(
          width = 3,
          selectInput("pais_pm", "País:",
                      choices  = paises_pm,
                      selected = paises_pm[1]),
          hr(),
          p("Estructura del empleo privado por tamaño de empresa y calificación.",
            "Fuente: Precariedad Mundial.",
            style = "font-size:0.8rem; color:#777; line-height:1.5;")
        ),
        mainPanel(
          width = 9,
          tabsetPanel(
            tabPanel("Gráfico", br(), plotOutput("plot_pm", height = "420px")),
            tabPanel("Tabla",   br(), div(style = "overflow-x:auto;", tableOutput("tabla_pm")))
          )
        )
      )
    }
  ),

  # ----------------------------------------------------------
  # Panel 3: CEPED-DATA
  # ----------------------------------------------------------
  tabPanel(
    "Salarios CEPED-DATA",
    br(),
    if (!ceped_ok) {
      div(class = "aviso",
          tags$b("Datos no disponibles."), " Para visualizar este panel cloná el repositorio ",
          tags$code("ceped-data"), " en ", tags$code(PATH_LOCAL),
          " y reiniciá la app.")
    } else {
      sidebarLayout(
        sidebarPanel(
          width = 3,
          uiOutput("filtros_ceped"),
          hr(),
          p("Serie de salarios elaborada por el CEPED (UBA).",
            "Fuente: CEPED-DATA.",
            style = "font-size:0.8rem; color:#777; line-height:1.5;")
        ),
        mainPanel(
          width = 9,
          tabsetPanel(
            tabPanel("Gráfico", br(), plotlyOutput("plot_ceped", height = "480px")),
            tabPanel("Tabla",   br(), div(style = "overflow-x:auto;", tableOutput("tabla_ceped")))
          )
        )
      )
    }
  )
)

# ============================================================
# Server
# ============================================================

server <- function(input, output) {

  # ---- EPH ----

  eph_filtrado <- reactive({
    serie_general %>% filter(ANO4 >= input$anios_eph[1], ANO4 <= input$anios_eph[2])
  })
  eph_sexo_filtrado <- reactive({
    serie_sexo %>% filter(ANO4 >= input$anios_eph[1], ANO4 <= input$anios_eph[2])
  })

  output$plot_eph_general <- renderPlot({
    ggplot(eph_filtrado(), aes(x = anio_trim, y = salario, group = 1)) +
      geom_line(color = "#c0392b", linewidth = 0.9) +
      geom_point(color = "#c0392b", size = 1.4) +
      scale_y_continuous(labels = scales::dollar_format(prefix = "$", big.mark = ".", decimal.mark = ",")) +
      labs(title = "Salario nominal promedio — asalariados privados (EPH)", x = NULL, y = "Salario ($)") +
      tema_base + theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 7))
  })

  output$plot_eph_sexo <- renderPlot({
    ggplot(eph_sexo_filtrado(), aes(x = anio_trim, y = salario, color = sexo, group = sexo)) +
      geom_line(linewidth = 0.9) + geom_point(size = 1.4) +
      scale_color_manual(values = c("Varón" = "#2980b9", "Mujer" = "#c0392b")) +
      scale_y_continuous(labels = scales::dollar_format(prefix = "$", big.mark = ".", decimal.mark = ",")) +
      labs(title = "Salario nominal promedio por sexo (EPH)", x = NULL, y = "Salario ($)", color = NULL) +
      tema_base +
      theme(axis.text.x = element_text(angle = 90, vjust = 0.5, size = 7), legend.position = "top")
  })

  output$tabla_eph <- renderTable({
    eph_filtrado() %>% select(Período = anio_trim, `Salario promedio ($)` = salario)
  }, striped = TRUE, hover = TRUE, bordered = TRUE)

  # ---- Precariedad Mundial ----

  if (pm_ok) {
    pm_filtrado <- reactive({
      base_pm %>% filter(PAIS == input$pais_pm)
    })

    output$plot_pm <- renderPlot({
      ggplot(pm_filtrado(), aes(x = tamanio.calif, y = particip.ocup, fill = tamanio.calif)) +
        geom_col(width = 0.7) +
        coord_flip() +
        scale_fill_manual(values = colores_pm, guide = "none") +
        scale_y_continuous(labels = scales::percent_format(accuracy = 1)) +
        labs(
          title = paste0("Estructura del empleo privado — ", input$pais_pm),
          subtitle = "Por tamaño de empresa y calificación",
          x = NULL, y = "Participación en el empleo"
        ) +
        tema_base
    })

    output$tabla_pm <- renderTable({
      pm_filtrado() %>%
        select(`Categoría` = tamanio.calif,
               `Casos ponderados` = casos_pond,
               `Participación` = particip.ocup) %>%
        mutate(Participación = scales::percent(Participación, accuracy = 0.1))
    }, striped = TRUE, hover = TRUE, bordered = TRUE)
  }

  # ---- CEPED-DATA ----

  if (ceped_ok) {
    variables_ceped <- sort(unique(base_salarios_ceped$cod.variable))
    paises_ceped    <- sort(unique(base_salarios_ceped$nombre.pais))

    output$filtros_ceped <- renderUI({
      tagList(
        selectInput("var_ceped", "Variable:",
                    choices  = variables_ceped,
                    selected = variables_ceped[1]),
        selectizeInput("paises_ceped", "Países:",
                       choices  = paises_ceped,
                       selected = head(paises_ceped, 4),
                       multiple = TRUE,
                       options  = list(placeholder = "Seleccioná uno o más países..."))
      )
    })

    ceped_filtrado <- reactive({
      req(input$var_ceped, input$paises_ceped)
      base_salarios_ceped %>%
        filter(cod.variable == input$var_ceped,
               nombre.pais  %in% input$paises_ceped)
    })

    output$plot_ceped <- renderPlotly({
      df <- ceped_filtrado()
      p <- ggplot(df, aes(x = ANO4, y = valor, color = nombre.pais,
                          group = nombre.pais, text = paste0(nombre.pais, "<br>Año: ", ANO4, "<br>Valor: ", valor))) +
        geom_line(linewidth = 0.9) +
        geom_point(size = 1.8) +
        scale_y_continuous(labels = scales::comma_format(big.mark = ".", decimal.mark = ",")) +
        labs(title = input$var_ceped, x = NULL, y = "Valor", color = NULL) +
        tema_base +
        theme(legend.position = "top")

      ggplotly(p, tooltip = "text") %>%
        layout(
          legend = list(orientation = "h", x = 0, y = 1.12, xanchor = "left"),
          margin = list(t = 80)
        )
    })

    output$tabla_ceped <- renderTable({
      ceped_filtrado() %>%
        select(País = nombre.pais, Año = ANO4, Variable = cod.variable, Valor = valor)
    }, striped = TRUE, hover = TRUE, bordered = TRUE)
  }
}

shinyApp(ui, server)

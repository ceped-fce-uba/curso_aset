library(rvest)
library(tidyverse)

page <- read_html("https://www.pagina12.com.ar")

h2_tags <- page %>% html_nodes("h2") %>% html_text()

print(h2_tags)


library(blastula)

create_smtp_creds_file('credenciales_gmail', 
                       user= 'marajadesantelmo@gmail.com', 
                       provider= 'gmail')


library(tidyverse)

# Crear un mensaje de correo electrónico
email <- compose_email(
  body = md("Este es un correo de prueba enviado desde R utilizando el paquete blastula.")
)

# Enviar el correo electrónico
email %>%
  smtp_send(
    from = "marajadesantelmo@gmail.com",   
    to = "marajadesantelmo@gmail.com",         
    subject = "Correo de prueba desde R", 
    credentials = creds_file("credenciales_gmail") 
  )



# Integración R GoogleSheets

library(googlesheets4)
library(googledrive)
gs4_auth()

gsheet <- gs4_create("GoogleSheet de prueba en el curso de R", sheets = list(sheet1 = data.frame(A = 1:3, B = 4:6)))


data2 <- read_sheet("https://docs.google.com/spreadsheets/d/117auXj20VY2iZPNy7c3PZDkaBsWqSh1ev_b62xHQs8w", sheet = "Hoja 1")



as_id(gsheet)

drive_auth()   
drive_share(as_id(gsheet), email_address = "marajadesantelmo@gmail.com", role = "writer")

df

sheet_write(data = df,  ss = as_id(gsheet), sheet = "Mis datos")
range_clear(ss = as_id(gsheet), sheet = "sheet1") 

sheet_write(data = data,  ss = as_id(gsheet), sheet = "Mis datos")



library(googlesheets4)
library(googledrive)

# autenticate googlesheets

gs4_auth()

# create a google sheet
new_sheet <- gs4_create("GoogleSheet de prueba", sheets = list(sheet1 = data.frame(A = 1:3, B = 4:6)))

# Share the sheet with a specific email
drive_share(as_id(new_sheet), email_address = "marajadesantelmo@gmail.com", role = "writer")

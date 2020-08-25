
#importo los datos
data <- read_delim("AMBA Julio 2020 - para JM (1).csv", 
                   ";", escape_double = FALSE, locale = locale(encoding = "ISO-8859-1"), 
                   trim_ws = TRUE)

#me quedo con un subset de columnas (para probar)
data_subset <- data[c("Edad", "Sexo", "Estudios","p02", "p03","p04","p05","p12","p15","p19","p20","p23")]

#Como son variables categoricas, las transformo en numericas:

data_subset$Edad = as.numeric(factor(data_subset$Edad,ordered = TRUE, 
                                     levels =  c("16-23", "24-29", "30-44", "45-59", "60-74", "Mas de 75")))


data_subset$Sexo = as.numeric(factor(data_subset$Sexo,ordered = TRUE, 
                                       levels =  c("Mujer", "Otros", "Varon")))


data_subset$Estudios = as.numeric(factor(data_subset$Estudios,ordered = TRUE, 
                                     levels =  c("Primario", "Secundario", "Superior")))


map = setNames(c( 1, 2, 3, 4, 5, 6 , 7),
               c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena"))

data_subset$gestion_alberto = as.numeric(factor(data_subset$p04,ordered = TRUE, 
                                             levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$gestion_kicillof = as.numeric(factor(data_subset$p05,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$imagen_larreta = as.numeric(factor(data_subset$p15,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$imagen_kicillof = as.numeric(factor(data_subset$p12,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$preocupacion_covid = as.numeric(factor(data_subset$p19,ordered = TRUE, 
                                                levels = c("Muy preocupado", "Bastante preocupado", "Poco preocupado", "No sabe", "Nada preocupado")))

data_subset$riesgo_covid = as.numeric(factor(data_subset$p20,ordered = TRUE, 
                                                   levels = c("Muy en riesgo", "Bastante en riesgo", "Poco en riesgo", "No sabe", "Nada en riesgo")))

data_subset$covid_salud_economia = as.numeric(factor(data_subset$p23,ordered = FALSE, 
                                             levels = c("La situación económica",  "No sabe","La situación sanitaria")))

data_subset$clase_social = as.numeric(factor(data_subset$p02,ordered = FALSE, 
                                                     levels = c("Clase baja",       "Clase media baja", "Clase media" ,     "No sabe"  ,        "Clase media alta", "Clase alta" )))
data_subset$espacio_politico <- data_subset$p03



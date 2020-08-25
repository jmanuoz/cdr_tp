
#importo los datos
data <- read.csv(file = 'AMBA Julio 2020 - para JM (1).csv', sep=";")

#me quedo con un subset de columnas (para probar)
data_subset <- data[c("Edad", "Sexo", "Estudios", "p03","p04","p05","p12","p15")]

#Como son variables categoricas, las transformo en numericas:
map = setNames(c(0, 1, 2, 3, 4, 5),
               c("16-23", "24-29", "30-44", "45-59", "60-74", "Mas de 75"))
data_subset$Edad <- map[unlist(data_subset$Edad)]

map = setNames(c(0, 1, 2),
               c("Mujer", "Otros", "Varon"))
data_subset$Sexo <- map[unlist(data_subset$Sexo)]


map = setNames(c(0, 1, 2),
               c("Primario", "Secundario", "Superior"))
data_subset$Estudios <- map[unlist(data_subset$Estudios)]

map = setNames(c( 1, 2, 3, 4, 5, 6 , 7),
               c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena"))
#data_subset$gestion_alberto <- map[unlist(data_subset$p04)]
data_subset$gestion_alberto = as.numeric(factor(data_subset$p04,ordered = TRUE, 
                                             levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$gestion_kicillof = as.numeric(factor(data_subset$p05,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$imagen_larreta = as.numeric(factor(data_subset$p15,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))
data_subset$imagen_kicillof = as.numeric(factor(data_subset$p12,ordered = TRUE, 
                                                levels = c("Muy Mala", "Mala", "Regular negativa","No sabe","Regular positiva", "Buena", "Muy buena")))

# data_subset$gestion_kicillof <- map[unlist(data_subset$p05)]
# data_subset$gestion_larreta <- map[unlist(data_subset$p07)]
# data_subset$imagen_larreta <- map[unlist(data_subset$p15)]
# data_subset$imagen_kicillof <- map[unlist(data_subset$p12)]
#map = setNames(c(0, 1, 2, 3, 4, 5, 6 , 7),
#               c("Cambiemos", "Radicalismo", "A Ninguno", "No sabe", "Otro", "Izquierda", "Peronismo", "Kirchnerismo"))
#data_subset$espacio_politico <- map[unlist(data_subset$p03)]
data_subset$espacio_politico <- data_subset$p03
print(dim(data_subset))


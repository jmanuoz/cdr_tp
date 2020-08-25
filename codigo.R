
#importo los datos
data <- read.csv(file = 'AMBA Julio 2020 - para JM (1).csv', sep=";")

#me quedo con un subset de columnas (para probar)
data_subset <- data[c("Edad", "Sexo", "Estudios", "p03","p04","p05","p12","p15")]

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


data_subset$espacio_politico <- data_subset$p03
print(dim(data_subset))


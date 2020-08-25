library(shiny)
library(scatterplot3d)
library(misc3d)

library(plotly)
library(factoextra)
library(corrplot)

#Este archivo transforma los datos de texto a valores numéricos para poder trabajarlos en las reducciones
source("codigo.R", encoding = "UTF-8")
#setwd("D:/materias/visualización de datos/TP")
ui <- fluidPage(
  
  # Application title
  titlePanel("Predicciones sobre encuesta COVID 2020"),
  #plotOutput('corrplot'),
 
  # Sidebar with a slider input for number of bins 
  titlePanel("Panel"),
  sidebarLayout(
    sidebarPanel(
     
      checkboxGroupInput("variables", 
                  h3("Seleccione la variable dependiente"), 
                  choices = c("Edad"           ,                "Estudios"        ,                 "Sexo", "gestion_alberto", "gestion_kicillof", "gestion_larreta" , "imagen_kicillof", "imagen_larreta"  ),
                  selected = c("Edad"           ,                "Estudios"        ,                 "Sexo")),
      selectInput("dependent", 
                         h3("Seleccione espacio politico"), 
                  choices = c("Cambiemos", "Radicalismo", "A Ninguno", "No sabe", "Otro", "Izquierda", "Peronismo", "Kirchnerismo"   ),
                  selected = c("Kirchnerismo"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("coeficientes")
    )
  )
  
)

# Define server logic required to draw a histogram
server <- function(input, output) {
  
  output$coeficientes <- renderPlot({
    
    #Genero la columna a predecir
    data_subset$target <- ifelse(data_subset$espacio_politico == input$dependent, 1, 0) 
    data_subset_complete = data_subset[complete.cases(data_subset), ]
    #Hago la regresion lineal
   
    model <- lm( reformulate(input$variables,"target") , data = data_subset_complete)
    #Printeo los coeficientes
    
    print(summary(model)$coef)
    
    #ploteo los coeficientes
    minx = min(summary(model)$coef[,1])-max(summary(model)$coef[,2])*2
    maxx =max(summary(model)$coef[,1])+max(summary(model)$coef[,2])*2
    x <- seq(minx, maxx, length=1000)
    colors=c('red','green','blue','orange',"#009999", "black")
    for(i in 1:(length(input$variables)+1)){
      y_feature <- dnorm(x, mean=summary(model)$coef[i,1] , sd=summary(model)$coef[i,2])
      if(i == 1){
        plot(x, y_feature,ylab="coeficiente de las variables", type="l", lwd=1, col=colors[i], ylim=c(0,100), xlim=c(minx,maxx))
        print(colors[i])
      }else{
        lines(x,y_feature,col=colors[i])
        print(colors[i])
      }
    }
    legend("topright", legend=c('Bias',input$variables),
           col=colors[1:(length(input$variables)+1)], lty=1, cex=0.8,title="Variables")
    print(colors[1:(length(input$variables)+1)])
    
     
     
  })
 
  
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
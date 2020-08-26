library(shiny)
library(scatterplot3d)
library(misc3d)

library(plotly)
library(factoextra)
library(corrplot)
library(e1071) 
#install.packages('caTools') 
library(caTools) 
#install.packages("randomForest")
library("randomForest")
#Este archivo transforma los datos de texto a valores numéricos para poder trabajarlos en las reducciones
source("codigo.R", encoding = "UTF-8")
source("tpfinal_metricas.R", encoding = "UTF-8")
features_data =  c("Edad"           ,                "Estudios"        ,                 "Sexo", "clase_social",
              
              "gestion_alberto", "gestion_kicillof",  "imagen_kicillof", "imagen_larreta",
              "preocupacion_covid","riesgo_covid","covid_salud_economia")
#setwd("D:/materias/visualización de datos/TP")
ui <- fluidPage(
  
  # Application title
  titlePanel("Predicciones sobre encuesta COVID 2020"),
  
  plotOutput('corrplot'),
  # Sidebar with a slider input for number of bins 
  titlePanel("Panel"),
  sidebarLayout(
    sidebarPanel(
     
      checkboxGroupInput("variables", 
                  h3("Seleccione la variable dependiente"), 
                  choices =features_data,
                  selected = c("Edad"           ,                "Estudios"        ,                 "Sexo")),
      selectInput("dependent", 
                         h3("Seleccione espacio politico"), 
                  choices = c("Cambiemos", "Radicalismo", "A Ninguno", "No sabe", "Otro", "Izquierda", "Peronismo", "Kirchnerismo"   ),
                  selected = c("Kirchnerismo"))
    ),
    
    # Show a plot of the generated distribution
    mainPanel(
      plotOutput("coeficientes"),plotOutput("clasificacion")
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
    
    #print(summary(model)$coef)
    
    #ploteo los coeficientes
    minx = min(summary(model)$coef[,1])-max(summary(model)$coef[,2])*2
    maxx =max(summary(model)$coef[,1])+max(summary(model)$coef[,2])*2
    x <- seq(minx, maxx, length=1000)
    colors=c('red','green','blue','orange',"#009999", "black")
    for(i in 1:(length(input$variables)+1)){
      y_feature <- dnorm(x, mean=summary(model)$coef[i,1] , sd=summary(model)$coef[i,2])
      if(i == 1){
        plot(x, y_feature,ylab="coeficiente de las variables", type="l", lwd=1, col=colors[i], ylim=c(0,100), xlim=c(minx,maxx))
        
      }else{
        lines(x,y_feature,col=colors[i])
        
      }
    }
    legend("topright", legend=c('Bias',input$variables),
           col=colors[1:(length(input$variables)+1)], lty=1, cex=0.8,title="Variables")
    print(colors[1:(length(input$variables)+1)])
    
     
     
  })
 
  output$corrplot <- renderPlot({
    data_subset$target <- ifelse(data_subset$espacio_politico == input$dependent, 1, 0) 
    subset = data_subset[c(features_data,"target")]
    subset = subset[complete.cases(subset), ]
    corrplot(cor(subset), order = "hclust")
    
    
  })
  
  output$clasificacion <- renderPlot({
    #Genero la columna a predecir
    data_subset$target <- ifelse(data_subset$espacio_politico == input$dependent, 1, 0) 
    data_subset_feature = data_subset[c('target',input$variables)]
    data_subset_complete = data_subset_feature[complete.cases(data_subset_feature), ]
    set.seed(123) 
    split <- sample.split(data_subset_complete$target) 
    
    training_set <- subset(data_subset_complete, split == TRUE) 
    test_set <- subset(data_subset_complete, split == FALSE) 
    drops <- c("target")
    #test_set = test_set[ , !(names(test_set) %in% drops)]
    #-------------------------------------------------------
    SVM <- svm(formula = target ~ ., 
               data = training_set, 
               kernel = 'linear') 
    
    y_pred_SVM_float <- predict(SVM, newdata = test_set[ , !(names(test_set) %in% drops)])
    y_pred_SVM <- ifelse(y_pred_SVM_float > 0.01, 1, 0)
    
    #-------------------------------------------------------
    RF <- randomForest(target~.,
                       data=training_set,
                       ntree=10,
                       proximity=T)
    
    
    
    y_pred_RF_float <- predict(RF, newdata = test_set[ , !(names(test_set) %in% drops)])
    y_pred_RF <- ifelse(y_pred_RF_float > 0.5, 1, 0)
    
    
    #-------------------------------------------------------
    #LR
    LR <- lm(target~.,
             data = training_set)
    
    y_pred_LR_float <- predict(LR, newdata = test_set[ , !(names(test_set) %in% drops)])
    y_pred_LR <- ifelse(y_pred_LR_float > 0.5, 1, 0)
    
    accuracy_svm = accuracy(y_pred_SVM,test_set$target)
    accuracy_rf = accuracy(y_pred_RF,test_set$target)
    accuracy_lr = accuracy(y_pred_LR,test_set$target)
    
    recall_svm = recall(y_pred_SVM,test_set$target)
    recall_rf =recall(y_pred_RF,test_set$target)
    recall_lr =recall(y_pred_LR,test_set$target)
    
    precision_svm = precision(y_pred_SVM,test_set$target)
    precision_rf = precision(y_pred_RF,test_set$target)
    precision_lr = precision(y_pred_LR,test_set$target)
    
    roc_auc_svm = ROC_AUC(test_set$target,y_pred_SVM_float)$auc
    roc_auc_rf = ROC_AUC(test_set$target,y_pred_RF_float)$auc
    roc_auc_lr = ROC_AUC(test_set$target,y_pred_LR_float)$auc
    
    df <- data.frame("metodo" = c('SVM','Randomf Forest','LR','SVM','Randomf Forest','LR'), "scores" = c(accuracy_svm,accuracy_rf,accuracy_lr,
                                                                                                         roc_auc_svm,roc_auc_rf,roc_auc_lr),'metrics'=c('accuracy','accuracy','accuracy','roc_auc','roc_auc','roc_auc'))
    print(df)
    p<-ggplot(data=df, aes(x=metodo, y=scores, fill=metrics)) +
      geom_bar(stat="identity", position=position_dodge())+ ggtitle("Métricas por clasificador")
    p
  })
  
  
}

# Run the application 
shinyApp(ui = ui, server = server)
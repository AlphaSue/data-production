#server.R


library(shiny)
library(plyr)
#For ggplot2 Graphics Library
library(ggplot2)

trainData <- read.csv("./data/train.csv")

dataset <- trainData
dataset<-as.data.frame(dataset)
shinyServer(
	function(input, output) {

		#Option to choose sample size
		dataset <- reactive(function() {
			trainData[sample(nrow(trainData), input$sampleSize), ]
			})

		#Option to download the Dataset
		output$downloadData <- downloadHandler(
    		filename = function() { paste(input$dataset, '.csv', sep='') },
    		content = function(file) {
      		write.csv(dataset(), file)
    		}
  		)

  		output$mytable1 <- renderDataTable({
    		trainData
  		}, options = list(bSortClasses = TRUE))

		#Draw ggplot based/reactive on user input


	output$plot <- reactivePlot(function() {
p<-ggplot(trainData,aes(x=Age,y=Pclass,color=Survived))+geom_point()
print(p)
}, height=700)

output$oid1<-renderPrint({input$x})
output$oid2<-renderPrint({input$y})
output$oid3<-renderPrint({input$color})

}


)
